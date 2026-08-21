import json
import boto3
import os
import sys
from datetime import datetime, timezone
from decimal import Decimal

sys.path.insert(0, os.path.dirname(__file__))
from assess_logic import assess_session
from exercise_logic import run_exercise


def floats_to_decimal(obj):
    """Recursively convert floats to Decimal for DynamoDB storage."""
    if isinstance(obj, float):
        return Decimal(str(obj))
    elif isinstance(obj, dict):
        return {k: floats_to_decimal(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [floats_to_decimal(i) for i in obj]
    return obj


dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')
table = dynamodb.Table(os.environ.get('TABLE', 'hope-sessions'))
BUCKET = os.environ.get('HOPE_BUCKET', 'hope-data-placeholder')


_REQUIRED_SAMPLE_KEYS = (
    'time', 'flex1', 'flex2', 'fsr1', 'fsr2', 'emg',
    'ax', 'ay', 'az', 'gx', 'gy', 'gz',
)

ASSESS_ACCUMULATION_SECS = 180   # 3 minutes
EXERCISE_ACCUMULATION_SECS = 300  # 5 minutes


def _validate_payload(device_id, sensor_data):
    """Lightweight shape check. Both ends are well-behaved so this only catches
    obviously malformed payloads (string instead of number, missing keys) that
    would otherwise crash assess_logic with a confusing 502."""
    if not isinstance(sensor_data, list):
        return 'sensor data must be a list of samples'
    if not sensor_data:
        return 'sensor data array is required'
    sample = sensor_data[0]
    if not isinstance(sample, dict):
        return 'each sample must be an object'
    missing = [k for k in _REQUIRED_SAMPLE_KEYS if k not in sample]
    if missing:
        return f'sample missing required keys: {missing}'
    for k in _REQUIRED_SAMPLE_KEYS:
        v = sample[k]
        if not isinstance(v, (int, float)) or isinstance(v, bool):
            return f'sample[{k!r}] must be a number, got {type(v).__name__}'
    return None


def _s3_read_json(key):
    """Read and parse a JSON object/array from S3. Returns None if the key
    does not exist.

    S3's get_object raises botocore.exceptions.ClientError with code
    'NoSuchKey' when the object is missing. We catch the broad Exception
    to handle both that and any transient error gracefully.
    """
    try:
        obj = s3.get_object(Bucket=BUCKET, Key=key)
        return json.loads(obj['Body'].read())
    except Exception:
        return None


def _s3_write_json(key, data):
    """Write a JSON-serializable object to S3."""
    s3.put_object(
        Bucket=BUCKET,
        Key=key,
        Body=json.dumps(data),
        ContentType='application/json',
    )


def handler(event, context):
    """Ingest endpoint: accepts sensor data from the ESP32 glove.

    The glove sends batches of ~100 samples every ~10 seconds to POST /ingest.
    The backend ACCUMULATES batches for a minimum duration before scoring:
      - Assessment phase: 3 minutes (180 seconds)
      - Exercise phase: 5 minutes (300 seconds)

    The glove sends only its device_id and raw sensor data — it has no
    knowledge of sessions, modes, or exercise names. This handler looks up
    the active session for the device and routes by DATA PRESENCE, not by
    status string:

      - assessment_results absent → assessment phase (accumulate then score)
      - assessment_results present → exercise phase (accumulate then score)

    Routing by data presence rather than `status` avoids a race: the patient
    can submit the post-assessment questionnaire between batches, which
    otherwise would overwrite the lifecycle marker.
    """
    raw = event.get('body') or ''
    try:
        body = json.loads(raw) if raw.strip() else {}
    except (ValueError, TypeError):
        return respond(400, {'error': 'invalid_json', 'message': 'Request body must be valid JSON'})

    device_id = body.get('device_id')
    sensor_data = body.get('data', [])
    force_score = body.get('force_score', False)

    if not device_id:
        return respond(400, {'error': 'missing_device_id', 'message': 'device_id is required'})

    err = _validate_payload(device_id, sensor_data)
    if err:
        return respond(400, {'error': 'invalid_payload', 'message': err})

    # Look up the active session for this device (status != 'completed')
    result = table.scan(
        FilterExpression='device_id = :did AND #s <> :done',
        ExpressionAttributeNames={'#s': 'status'},
        ExpressionAttributeValues={
            ':did': device_id,
            ':done': 'completed'
        }
    )

    items = result.get('Items', [])
    if not items:
        return respond(404, {
            'error': 'no_active_session',
            'message': f'No active session linked to device {device_id}. '
                       f'Link the device first via PUT /sessions/{{id}}/device'
        })

    # Pick the most recent active session
    session = sorted(items, key=lambda x: x.get('created_at', ''), reverse=True)[0]
    session_id = session['session_id']

    # Re-fetch with strongly consistent read to get the latest status.
    # The scan above uses eventually consistent reads and may return stale data
    # (e.g., still showing 'questionnaire_done' when the status is already 'assessed').
    fresh = table.get_item(Key={'session_id': session_id}, ConsistentRead=True)
    session = fresh.get('Item', session)

    # Route by DATA presence, not by the status string. Status can be overwritten
    # by PUT /questionnaire to 'questionnaire_done' in between the assessment and
    # exercise ingest batches; if we routed on status we'd mistake the exercise
    # batch for a retry-assessment and overwrite assessment_results. Using the
    # presence of assessment_results is the canonical invariant: if assessment
    # results exist, the glove is posting exercise data. The glove itself has
    # no knowledge of phase.
    ar = session.get('assessment_results')
    if ar:
        needed = ar.get('needed_training', []) if isinstance(ar, dict) else []
        exercise_name = needed[0] if needed else 'Unknown'
        return process_exercise(session_id, session, sensor_data, exercise_name, force_score)
    else:
        return process_assessment(session_id, session, sensor_data, force_score)


# ---------------------------------------------------------------------------
# Accumulation helpers
# ---------------------------------------------------------------------------

def _accumulate_batch(session_id, session, sensor_data, phase):
    """Append a batch of samples to the S3 accumulation file and update
    DynamoDB metadata. Returns (accumulated_samples, batch_count, seconds_elapsed,
    seconds_required, is_ready).

    phase: 'assessment' or 'exercise'
    """
    now = datetime.now(timezone.utc)
    now_iso = now.isoformat()

    accumulation_key = f'sensor-data/{session_id}/{phase}_batches.json'
    threshold = ASSESS_ACCUMULATION_SECS if phase == 'assessment' else EXERCISE_ACCUMULATION_SECS

    # Read existing accumulated samples (if any) from S3
    existing = _s3_read_json(accumulation_key)
    if existing is None:
        existing = []

    # Extend with the new batch
    existing.extend(sensor_data)

    # Write back the accumulated data
    _s3_write_json(accumulation_key, existing)

    # Determine if this is the first batch for this phase
    ingest_started_at = session.get('ingest_started_at')
    current_batch_count = int(session.get('batch_count', 0) or 0)

    if not ingest_started_at:
        # First batch: set ingest_started_at
        ingest_started_at = now_iso
        new_batch_count = 1
        table.update_item(
            Key={'session_id': session_id},
            UpdateExpression=(
                'SET ingest_started_at = :started, last_batch_at = :now, '
                'batch_count = :bc, #st = :status'
            ),
            ExpressionAttributeNames={'#st': 'status'},
            ExpressionAttributeValues={
                ':started': ingest_started_at,
                ':now': now_iso,
                ':bc': new_batch_count,
                ':status': f'accumulating_{phase}',
            },
        )
    else:
        # Subsequent batch: update last_batch_at and increment batch_count
        new_batch_count = current_batch_count + 1
        table.update_item(
            Key={'session_id': session_id},
            UpdateExpression='SET last_batch_at = :now, batch_count = :bc',
            ExpressionAttributeValues={
                ':now': now_iso,
                ':bc': new_batch_count,
            },
        )

    # Compute elapsed time
    started_dt = datetime.fromisoformat(ingest_started_at)
    elapsed = (now - started_dt).total_seconds()
    is_ready = elapsed >= threshold

    return existing, new_batch_count, elapsed, threshold, is_ready


def _clear_accumulation_fields(session_id):
    """Remove the transient accumulation metadata from DynamoDB so the next
    phase starts clean."""
    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression='REMOVE ingest_started_at, last_batch_at, batch_count',
    )


# ---------------------------------------------------------------------------
# Assessment
# ---------------------------------------------------------------------------

def _score_assessment_now(session_id, sensor_data):
    """Score a single batch immediately (simulator path). Bypasses accumulation."""
    s3_key = f'sensor-data/{session_id}/assess.json'
    _s3_write_json(s3_key, sensor_data)

    results = assess_session(sensor_data)

    assessment_results = {k: ('PASS' if v else 'FAIL') for k, v in results['results'].items()}
    assessment_results['needed_training'] = results['needed_training']
    assessment_features = {k: str(v) for k, v in results['features'].items()}

    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression=(
            'SET assessment_results = :ar, assessment_features = :af, '
            'sensor_data_assess_s3 = :s3, #st = :status'
        ),
        ExpressionAttributeNames={'#st': 'status'},
        ExpressionAttributeValues={
            ':ar': assessment_results,
            ':af': assessment_features,
            ':s3': s3_key,
            ':status': 'assessed',
        },
    )

    return respond(200, {
        'session_id': session_id,
        'assessment_results': assessment_results,
        'assessment_features': assessment_features,
        'status': 'assessed',
    })


def _score_exercise_now(session_id, sensor_data, exercise_name):
    """Score a single batch immediately (simulator path). Bypasses accumulation."""
    s3_key = f'sensor-data/{session_id}/exercise.json'
    _s3_write_json(s3_key, {'exercise': exercise_name, 'data': sensor_data})

    results = run_exercise(sensor_data, exercise_name)

    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression=(
            'SET exercise_results = :er, sensor_data_exercise_s3 = :s3, #st = :status'
        ),
        ExpressionAttributeNames={'#st': 'status'},
        ExpressionAttributeValues={
            ':er': floats_to_decimal(results),
            ':s3': s3_key,
            ':status': 'exercised',
        },
    )

    return respond(200, {
        'session_id': session_id,
        'exercise_results': results,
        'status': 'exercised',
    })


def process_assessment(session_id, session, sensor_data, force_score=False):
    # force_score=True: score immediately on this single batch (used by the
    # Flutter app's simulator). The real glove never sends this flag.
    if force_score:
        return _score_assessment_now(session_id, sensor_data)

    accumulated, batch_count, elapsed, required, is_ready = _accumulate_batch(
        session_id, session, sensor_data, 'assessment'
    )

    if not is_ready:
        return respond(200, {
            'session_id': session_id,
            'status': 'accumulating_assessment',
            'batch_count': batch_count,
            'seconds_elapsed': round(elapsed, 1),
            'seconds_required': required,
        })

    # --- Threshold reached: score the accumulated data ---

    # Also store the final accumulated data at the standard S3 key so the
    # rest of the system (download, replay) sees the same path.
    s3_key = f'sensor-data/{session_id}/assess.json'
    _s3_write_json(s3_key, accumulated)

    results = assess_session(accumulated)

    # Persisted shape matches GET /sessions/{id} so clients only need to
    # understand one schema. assessment_results merges PASS/FAIL strings with
    # the needed_training list; features are stored as strings (DynamoDB
    # number->Decimal coercion is fine, but we stringify for consistency with
    # how the rest of the surface treats them).
    assessment_results = {k: ('PASS' if v else 'FAIL') for k, v in results['results'].items()}
    assessment_results['needed_training'] = results['needed_training']
    assessment_features = {k: str(v) for k, v in results['features'].items()}

    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression=(
            'SET assessment_results = :ar, assessment_features = :af, '
            'sensor_data_assess_s3 = :s3, #st = :status '
            'REMOVE ingest_started_at, last_batch_at, batch_count'
        ),
        ExpressionAttributeNames={'#st': 'status'},
        ExpressionAttributeValues={
            ':ar': assessment_results,
            ':af': assessment_features,
            ':s3': s3_key,
            ':status': 'assessed',
        },
    )

    return respond(200, {
        'session_id': session_id,
        'assessment_results': assessment_results,
        'assessment_features': assessment_features,
        'status': 'assessed',
    })


# ---------------------------------------------------------------------------
# Exercise
# ---------------------------------------------------------------------------

def process_exercise(session_id, session, sensor_data, exercise_name, force_score=False):
    if force_score:
        return _score_exercise_now(session_id, sensor_data, exercise_name)

    accumulated, batch_count, elapsed, required, is_ready = _accumulate_batch(
        session_id, session, sensor_data, 'exercise'
    )

    if not is_ready:
        return respond(200, {
            'session_id': session_id,
            'status': 'accumulating_exercise',
            'batch_count': batch_count,
            'seconds_elapsed': round(elapsed, 1),
            'seconds_required': required,
        })

    # --- Threshold reached: score the accumulated data ---

    s3_key = f'sensor-data/{session_id}/exercise.json'
    _s3_write_json(s3_key, {'exercise': exercise_name, 'data': accumulated})

    results = run_exercise(accumulated, exercise_name)

    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression=(
            'SET exercise_results = :er, sensor_data_exercise_s3 = :s3, #st = :status '
            'REMOVE ingest_started_at, last_batch_at, batch_count'
        ),
        ExpressionAttributeNames={'#st': 'status'},
        ExpressionAttributeValues={
            ':er': floats_to_decimal(results),
            ':s3': s3_key,
            ':status': 'exercised',
        },
    )

    return respond(200, {
        'session_id': session_id,
        'exercise_results': results,
        'status': 'exercised',
    })


def respond(status_code, body):
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(body, cls=_DecimalEncoder)
    }


class _DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super().default(o)
