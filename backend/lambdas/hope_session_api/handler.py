import json
import boto3
import uuid
import os
from datetime import datetime, timezone
from decimal import Decimal


class _DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super().default(o)


def _floats_to_decimal(obj):
    """Recursively convert floats → Decimal so DynamoDB will accept them.

    The questionnaire contains floats (e.g. sleep_hours: 7.5, body_temperature: 37.0).
    DynamoDB's TypeSerializer rejects Python float — it requires Decimal.
    """
    if isinstance(obj, float):
        return Decimal(str(obj))
    if isinstance(obj, dict):
        return {k: _floats_to_decimal(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [_floats_to_decimal(v) for v in obj]
    return obj

_S3_REGION = os.environ.get('HOPE_S3_REGION', os.environ.get('AWS_REGION', 'eu-west-3'))
dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3', region_name=_S3_REGION,
                  config=boto3.session.Config(signature_version='s3v4'))
table = dynamodb.Table('hope-sessions')
BUCKET = os.environ.get('HOPE_BUCKET', 'hope-data-placeholder')


def handler(event, context):
    method = event['httpMethod']
    path = event['resource']
    path_params = event.get('pathParameters') or {}
    raw_body = event.get('body') or ''
    try:
        body = json.loads(raw_body) if raw_body.strip() else {}
    except (ValueError, TypeError):
        return respond(400, {'error': 'invalid_json', 'message': 'Request body must be valid JSON or empty'})

    if method == 'POST' and path == '/sessions':
        return create_session()

    elif method == 'PUT' and path == '/sessions/{session_id}/questionnaire':
        return save_questionnaire(path_params['session_id'], body)

    elif method == 'POST' and path == '/sessions/{session_id}/video-upload-url':
        return get_video_upload_url(path_params['session_id'])

    elif method == 'PUT' and path == '/sessions/{session_id}/device':
        return link_device(path_params['session_id'], body)

    elif method == 'GET' and path == '/sessions':
        return list_sessions()

    elif method == 'GET' and path == '/sessions/{session_id}':
        return get_session(path_params['session_id'])

    elif method == 'DELETE' and path == '/sessions/{session_id}':
        return delete_session(path_params['session_id'])

    elif method == 'POST' and path == '/sessions/{session_id}/redo-assessment':
        return redo_assessment(path_params['session_id'])

    return respond(404, {'error': 'not_found'})


def _session_exists(session_id):
    """Return True iff a row with this session_id exists in DynamoDB."""
    return 'Item' in table.get_item(Key={'session_id': session_id}, ConsistentRead=True)


def create_session():
    session_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc).isoformat()
    table.put_item(Item={
        'session_id': session_id,
        'created_at': now,
        'status': 'created'
    })
    return respond(201, {'session_id': session_id, 'created_at': now, 'status': 'created'})


def save_questionnaire(session_id, body):
    """Save questionnaire answers; advance status only if the session hasn't
    progressed past it yet.

    The app shows the questionnaire AFTER the assessment, so by the time this
    runs the session's status is typically already 'assessed' or later. We must
    NOT regress it back to 'questionnaire_done' — doing so would break any
    consumer that treats status as a monotonic lifecycle marker. We always
    write the questionnaire data, but leave status alone if it's already
    'assessed' or 'exercised'.
    """
    answers = _floats_to_decimal(body.get('answers', body))
    # Fetch current status to decide whether to advance it.
    current = table.get_item(Key={'session_id': session_id}, ConsistentRead=True).get('Item', {})
    current_status = current.get('status', 'created')

    if current_status in ('assessed', 'exercised',
                          'accumulating_assessment', 'accumulating_exercise'):
        # Already past the questionnaire step in the lifecycle — update answers only.
        table.update_item(
            Key={'session_id': session_id},
            UpdateExpression='SET questionnaire = :q',
            ExpressionAttributeValues={':q': answers},
        )
        return respond(200, {'status': current_status})

    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression='SET questionnaire = :q, #s = :s',
        ExpressionAttributeNames={'#s': 'status'},
        ExpressionAttributeValues={':q': answers, ':s': 'questionnaire_done'},
    )
    return respond(200, {'status': 'questionnaire_done'})


def get_video_upload_url(session_id):
    if not _session_exists(session_id):
        return respond(404, {'error': 'session_not_found', 'message': f'No session with id {session_id}'})
    key = f'videos/{session_id}/video.mp4'
    url = s3.generate_presigned_url(
        'put_object',
        Params={'Bucket': BUCKET, 'Key': key, 'ContentType': 'video/mp4'},
        ExpiresIn=600
    )
    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression='SET video_s3_key = :k',
        ExpressionAttributeValues={':k': key}
    )
    return respond(200, {'upload_url': url, 's3_key': key, 'expires_in': 600})


def link_device(session_id, body):
    """Link a device to this session for the /ingest endpoint.

    Single-glove demo: linking the same device to a fresh session orphans the
    previous one (the user can always restart). The /ingest router picks the
    newest session by created_at so the older orphaned session is naturally
    ignored — we don't actively rewrite it.
    """
    device_id = body.get('device_id')
    if not device_id:
        return respond(400, {'error': 'missing_device_id', 'message': 'device_id is required'})

    if not _session_exists(session_id):
        return respond(404, {'error': 'session_not_found', 'message': f'No session with id {session_id}'})

    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression='SET device_id = :d',
        ExpressionAttributeValues={':d': device_id}
    )
    return respond(200, {'status': 'device_linked', 'device_id': device_id})


def list_sessions():
    result = table.scan()
    sessions = sorted(result.get('Items', []), key=lambda x: x.get('created_at', ''), reverse=True)
    summaries = []
    for s in sessions:
        ar = s.get('assessment_results') or {}
        er = s.get('exercise_results') or {}
        passed = sum(1 for v in ar.values() if v == 'PASS' and isinstance(v, str))
        total = len([k for k in ar if k not in ('needed_training', 'features')])
        status = s.get('status', 'created')
        summary_item = {
            'session_id': s['session_id'],
            'created_at': s.get('created_at', ''),
            'status': status,
            'has_video': bool(s.get('video_s3_key')),
            'assessment_summary': {
                'passed': passed,
                'total': total,
                'needed_training': ar.get('needed_training', [])
            },
            'exercise_name': er.get('exercise') if er else None,
            'exercise_overall_percent': er.get('overall_percent') if er else None,
        }
        # Include accumulation progress when a phase is accumulating
        if status in ('accumulating_assessment', 'accumulating_exercise'):
            summary_item['batch_count'] = int(s['batch_count']) if s.get('batch_count') is not None else 0
        summaries.append(summary_item)
    return respond(200, {'sessions': summaries})


def redo_assessment(session_id):
    """Clear assessment_results so the next /ingest batch is treated as a fresh
    assessment instead of an exercise. Also clears any exercise_results that
    might have been written. Status is reset to 'created'.

    The Flutter app calls this from the assessment-results screen when the user
    taps "redo". The /ingest router keys on presence of assessment_results, so
    removing the attribute is sufficient — no other state needs to be reset.
    """
    if not _session_exists(session_id):
        return respond(404, {'error': 'session_not_found', 'message': f'No session with id {session_id}'})

    table.update_item(
        Key={'session_id': session_id},
        UpdateExpression=(
            'REMOVE assessment_results, assessment_features, exercise_results, '
            'sensor_data_assess_s3, sensor_data_exercise_s3, '
            'ingest_started_at, last_batch_at, batch_count '
            'SET #s = :s'
        ),
        ExpressionAttributeNames={'#s': 'status'},
        ExpressionAttributeValues={':s': 'created'},
    )

    # Clean up any accumulation S3 files from the previous attempt
    for suffix in ('assessment_batches.json', 'exercise_batches.json'):
        try:
            s3.delete_object(Bucket=BUCKET, Key=f'sensor-data/{session_id}/{suffix}')
        except Exception:
            pass

    return respond(200, {'status': 'created', 'session_id': session_id})


def delete_session(session_id):
    """Hard-delete a session row + its S3 artifacts.

    Practitioner-mode action. There is no archive/soft-delete — this is a
    single-user demo and the practitioner has full authority over the log.
    """
    item = table.get_item(Key={'session_id': session_id}, ConsistentRead=True).get('Item')
    if not item:
        return respond(404, {'error': 'session_not_found', 'message': f'No session with id {session_id}'})

    sid = item['session_id']
    for key in (item.get('sensor_data_assess_s3'),
                item.get('sensor_data_exercise_s3'),
                item.get('video_s3_key'),
                f'sensor-data/{sid}/assessment_batches.json',
                f'sensor-data/{sid}/exercise_batches.json'):
        if key:
            try:
                s3.delete_object(Bucket=BUCKET, Key=key)
            except Exception:
                pass

    table.delete_item(Key={'session_id': session_id})
    return respond(200, {'status': 'deleted', 'session_id': session_id})


def get_session(session_id):
    result = table.get_item(Key={'session_id': session_id})
    item = result.get('Item')
    if not item:
        return respond(404, {'error': 'session_not_found', 'message': f'No session with id {session_id}'})

    video_url = None
    if item.get('video_s3_key'):
        video_url = s3.generate_presigned_url(
            'get_object',
            Params={'Bucket': BUCKET, 'Key': item['video_s3_key']},
            ExpiresIn=3600
        )

    status = item.get('status', 'created')

    # Determine accumulation phase and required seconds for the Flutter app
    accumulation_phase = None
    seconds_required = None
    if status == 'accumulating_assessment':
        accumulation_phase = 'assessment'
        seconds_required = 180
    elif status == 'accumulating_exercise':
        accumulation_phase = 'exercise'
        seconds_required = 300

    return respond(200, {
        'session_id': item['session_id'],
        'created_at': item['created_at'],
        'status': status,
        'device_id': item.get('device_id'),
        'questionnaire': item.get('questionnaire'),
        'assessment_results': item.get('assessment_results'),
        'assessment_features': item.get('assessment_features'),
        'exercise_results': item.get('exercise_results'),
        'video_url': video_url,
        'ingest_started_at': item.get('ingest_started_at'),
        'last_batch_at': item.get('last_batch_at'),
        'batch_count': int(item['batch_count']) if item.get('batch_count') is not None else None,
        'accumulation_phase': accumulation_phase,
        'seconds_required': seconds_required,
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
