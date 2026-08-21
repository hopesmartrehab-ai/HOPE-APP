"""Routing tests for hope_ingest.handler.

The key invariant: the glove has no knowledge of phase. It always POSTs the
same payload to /ingest. The backend decides whether the batch is an
assessment or an exercise based on the session's state. We route on the
presence of `assessment_results` (not the `status` string), because status
can change independently when the patient submits the post-assessment
questionnaire.

As of 2026-05, the handler accumulates sensor batches over time before
scoring: 180s for assessment, 300s for exercise. The first batch starts
the accumulation window; subsequent batches append data. Scoring only
fires once the elapsed time since the first batch exceeds the threshold.
"""
import json
import os
import importlib.util
import pytest
import boto3
from datetime import datetime, timezone, timedelta
from moto import mock_aws

HANDLER_PATH = os.path.join(os.path.dirname(__file__), '../lambdas/hope_ingest/handler.py')
TABLE_NAME = 'hope-sessions'
BUCKET_NAME = 'hope-data-test'
DEVICE_ID = 'hope-glove-01'


def _sample_batch(n=3):
    return [
        {
            'time': i * 50,
            'flex1': 40, 'flex2': 35,
            'fsr1': 50, 'fsr2': 45,
            'emg': 300,
            'ax': 1000, 'ay': -500, 'az': 16000,
            'gx': 10, 'gy': -5, 'gz': 3,
        }
        for i in range(n)
    ]


def _set_env():
    os.environ['AWS_DEFAULT_REGION'] = 'us-east-1'
    os.environ['AWS_ACCESS_KEY_ID'] = 'test'
    os.environ['AWS_SECRET_ACCESS_KEY'] = 'test'
    os.environ['HOPE_BUCKET'] = BUCKET_NAME
    os.environ['TABLE'] = TABLE_NAME


def _load_handler():
    spec = importlib.util.spec_from_file_location('hope_ingest_handler', HANDLER_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


@pytest.fixture
def ingest_setup():
    with mock_aws():
        _set_env()
        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        table = ddb.create_table(
            TableName=TABLE_NAME,
            KeySchema=[{'AttributeName': 'session_id', 'KeyType': 'HASH'}],
            AttributeDefinitions=[{'AttributeName': 'session_id', 'AttributeType': 'S'}],
            BillingMode='PAY_PER_REQUEST'
        )
        s3 = boto3.client('s3', region_name='us-east-1')
        s3.create_bucket(Bucket=BUCKET_NAME)
        handler_mod = _load_handler()
        yield handler_mod, table, s3


def _ingest_event(body):
    return {'body': json.dumps(body)}


def _put_session(table, session_id, **attrs):
    item = {'session_id': session_id, 'created_at': '2026-04-14T00:00:00+00:00'}
    item.update(attrs)
    table.put_item(Item=item)


def _past_iso(seconds_ago):
    """Return an ISO timestamp string `seconds_ago` seconds in the past."""
    return (datetime.now(timezone.utc) - timedelta(seconds=seconds_ago)).isoformat()


class TestIngestRouting:
    def test_no_linked_session_returns_404(self, ingest_setup):
        handler_mod, _table, _s3 = ingest_setup
        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch()}
        ), None)
        assert resp['statusCode'] == 404
        assert 'no_active_session' in resp['body']

    def test_first_batch_starts_assessment_accumulation(self, ingest_setup):
        """Fresh session, no assessment_results yet. The first batch should NOT
        score immediately but instead start the accumulation window."""
        handler_mod, table, _s3 = ingest_setup
        sid = 'sess-1'
        _put_session(table, sid, status='created', device_id=DEVICE_ID)

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(100)}
        ), None)
        body = json.loads(resp['body'])
        assert resp['statusCode'] == 200
        assert body['status'] == 'accumulating_assessment'
        assert body['batch_count'] == 1
        # No scoring yet — assessment_results must NOT be in the response.
        assert 'assessment_results' not in body

    def test_second_batch_after_assessment_starts_exercise_accumulation(self, ingest_setup):
        """Session already has assessment_results -> exercise accumulation starts."""
        handler_mod, table, _s3 = ingest_setup
        sid = 'sess-2'
        _put_session(
            table, sid,
            status='assessed',
            device_id=DEVICE_ID,
            assessment_results={
                'Reach': 'FAIL', 'Grasp': 'PASS',
                'Manipulation': 'FAIL', 'Release': 'FAIL',
                'needed_training': ['Reach', 'Manipulation', 'Release'],
            },
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(100)}
        ), None)
        body = json.loads(resp['body'])
        assert resp['statusCode'] == 200
        # First exercise batch starts accumulation, not scoring.
        assert body['status'] == 'accumulating_exercise'
        assert body['batch_count'] == 1

    def test_questionnaire_status_does_not_confuse_router(self, ingest_setup):
        """Regression guard for the routing bug fixed on 2026-04-14.

        After assessment, the patient may submit the questionnaire which writes
        status='questionnaire_done'. The next /ingest batch (exercise data) must
        still be routed to the exercise branch -- not re-run assessment and
        overwrite the results.
        """
        handler_mod, table, _s3 = ingest_setup
        sid = 'sess-3'
        original_results = {
            'Reach': 'PASS', 'Grasp': 'FAIL',
            'Manipulation': 'FAIL', 'Release': 'FAIL',
            'needed_training': ['Grasp', 'Manipulation', 'Release'],
        }
        _put_session(
            table, sid,
            status='questionnaire_done',
            device_id=DEVICE_ID,
            assessment_results=original_results,
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(100)}
        ), None)
        body = json.loads(resp['body'])
        assert resp['statusCode'] == 200
        # Exercise accumulation starts (not assessment), confirming routing by
        # data presence not status string.
        assert body['status'] == 'accumulating_exercise'
        assert body['batch_count'] == 1

        # Assessment results must still be intact in DynamoDB.
        item = table.get_item(Key={'session_id': sid}).get('Item', {})
        assert item['assessment_results']['Reach'] == 'PASS'


class TestAssessmentAccumulation:
    """Tests for the assessment accumulation window (180s threshold)."""

    def test_first_assessment_batch_returns_accumulating(self, ingest_setup):
        """First batch sets status to accumulating_assessment, stores data in S3,
        and returns accumulating status with batch_count=1."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-assess-1'
        _put_session(table, sid, status='created', device_id=DEVICE_ID)

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(50)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'accumulating_assessment'
        assert body['batch_count'] == 1

        # Verify DynamoDB state.
        item = table.get_item(Key={'session_id': sid}).get('Item', {})
        assert item['status'] == 'accumulating_assessment'
        assert 'ingest_started_at' in item
        assert 'last_batch_at' in item
        assert int(item['batch_count']) == 1

        # Verify S3 batch file was created.
        s3_obj = s3.get_object(Bucket=BUCKET_NAME, Key=f'sensor-data/{sid}/assessment_batches.json')
        stored = json.loads(s3_obj['Body'].read().decode())
        assert len(stored) == 50

    def test_assessment_accumulates_multiple_batches(self, ingest_setup):
        """Two batches within the threshold should both accumulate without scoring."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-assess-multi'
        _put_session(table, sid, status='created', device_id=DEVICE_ID)

        # First batch.
        resp1 = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(30)}
        ), None)
        body1 = json.loads(resp1['body'])
        assert body1['status'] == 'accumulating_assessment'
        assert body1['batch_count'] == 1

        # Second batch (still within 180s -- ingest_started_at was just set).
        resp2 = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body2 = json.loads(resp2['body'])
        assert body2['status'] == 'accumulating_assessment'
        assert body2['batch_count'] == 2

        # Verify accumulated data in S3 contains samples from both batches.
        s3_obj = s3.get_object(Bucket=BUCKET_NAME, Key=f'sensor-data/{sid}/assessment_batches.json')
        stored = json.loads(s3_obj['Body'].read().decode())
        assert len(stored) == 50  # 30 + 20

        # Verify DynamoDB batch_count.
        item = table.get_item(Key={'session_id': sid}).get('Item', {})
        assert int(item['batch_count']) == 2

    def test_assessment_scores_after_threshold(self, ingest_setup):
        """When ingest_started_at is 180+ seconds ago, the next batch should
        trigger scoring and return assessment_results."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-assess-score'

        # Pre-populate with accumulation state as if the first batch arrived 200s ago.
        initial_data = _sample_batch(80)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/assessment_batches.json',
            Body=json.dumps(initial_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_assessment',
            device_id=DEVICE_ID,
            ingest_started_at=_past_iso(200),  # 200s ago, exceeds 180s threshold
            last_batch_at=_past_iso(10),
            batch_count=3,
        )

        # Send another batch; this one should trigger scoring.
        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'assessed'
        assert 'assessment_results' in body

        # Verify assessment_results are PASS/FAIL strings.
        ar = body['assessment_results']
        for key, val in ar.items():
            if key == 'needed_training':
                assert isinstance(val, list)
            else:
                assert val in ('PASS', 'FAIL'), f'{key}={val!r}'

        # Verify DynamoDB is updated to 'assessed' with assessment_results.
        item = table.get_item(Key={'session_id': sid}).get('Item', {})
        assert item['status'] == 'assessed'
        assert 'assessment_results' in item

    def test_assessment_does_not_score_before_threshold(self, ingest_setup):
        """When ingest_started_at is less than 180s ago, scoring must not happen."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-assess-early'

        initial_data = _sample_batch(50)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/assessment_batches.json',
            Body=json.dumps(initial_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_assessment',
            device_id=DEVICE_ID,
            ingest_started_at=_past_iso(90),  # Only 90s ago, below 180s threshold
            last_batch_at=_past_iso(5),
            batch_count=2,
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'accumulating_assessment'
        assert body['batch_count'] == 3
        assert 'assessment_results' not in body

    def test_accumulated_data_is_merged_for_scoring(self, ingest_setup):
        """When scoring fires, ALL accumulated batches are used, not just
        the last one. Verify the scored S3 file contains data from all batches."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-assess-merge'

        # Pre-populate S3 with accumulated data (two earlier batches).
        # Use distinct time values so we can verify the merge later.
        batch_a = [
            {'time': i * 50, 'flex1': 40, 'flex2': 35, 'fsr1': 50, 'fsr2': 45,
             'emg': 300, 'ax': 1000, 'ay': -500, 'az': 16000,
             'gx': 10, 'gy': -5, 'gz': 3}
            for i in range(40)
        ]
        batch_b = [
            {'time': 2000 + i * 50, 'flex1': 42, 'flex2': 37, 'fsr1': 55, 'fsr2': 48,
             'emg': 320, 'ax': 1100, 'ay': -450, 'az': 15800,
             'gx': 12, 'gy': -4, 'gz': 2}
            for i in range(40)
        ]
        accumulated = batch_a + batch_b
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/assessment_batches.json',
            Body=json.dumps(accumulated),
            ContentType='application/json',
        )

        _put_session(
            table, sid,
            status='accumulating_assessment',
            device_id=DEVICE_ID,
            ingest_started_at=_past_iso(200),
            last_batch_at=_past_iso(5),
            batch_count=2,
        )

        # Third batch triggers scoring.
        batch_c = [
            {'time': 4000 + i * 50, 'flex1': 38, 'flex2': 33, 'fsr1': 48, 'fsr2': 42,
             'emg': 280, 'ax': 950, 'ay': -520, 'az': 16200,
             'gx': 8, 'gy': -6, 'gz': 4}
            for i in range(20)
        ]

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': batch_c}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'assessed'
        assert 'assessment_results' in body

        # Verify the final assess.json in S3 contains all 100 samples (40+40+20).
        s3_obj = s3.get_object(Bucket=BUCKET_NAME, Key=f'sensor-data/{sid}/assess.json')
        scored_data = json.loads(s3_obj['Body'].read().decode())
        assert len(scored_data) == 100


class TestExerciseAccumulation:
    """Tests for the exercise accumulation window (300s threshold)."""

    def test_first_exercise_batch_returns_accumulating(self, ingest_setup):
        """First exercise batch should accumulate, not score."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-ex-1'
        _put_session(
            table, sid,
            status='assessed',
            device_id=DEVICE_ID,
            assessment_results={
                'Reach': 'FAIL', 'Grasp': 'PASS',
                'Manipulation': 'FAIL', 'Release': 'FAIL',
                'needed_training': ['Reach', 'Manipulation', 'Release'],
            },
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(50)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'accumulating_exercise'
        assert body['batch_count'] == 1
        assert 'exercise_results' not in body

        # Verify DynamoDB state.
        item = table.get_item(Key={'session_id': sid}).get('Item', {})
        assert item['status'] == 'accumulating_exercise'
        assert 'ingest_started_at' in item
        assert int(item['batch_count']) == 1

    def test_exercise_accumulates_multiple_batches(self, ingest_setup):
        """Multiple exercise batches within the 300s window should accumulate."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-ex-multi'
        _put_session(
            table, sid,
            status='assessed',
            device_id=DEVICE_ID,
            assessment_results={
                'Reach': 'FAIL', 'Grasp': 'PASS',
                'Manipulation': 'FAIL', 'Release': 'FAIL',
                'needed_training': ['Reach', 'Manipulation', 'Release'],
            },
        )

        # First batch.
        resp1 = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(30)}
        ), None)
        body1 = json.loads(resp1['body'])
        assert body1['status'] == 'accumulating_exercise'
        assert body1['batch_count'] == 1

        # Second batch.
        resp2 = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(25)}
        ), None)
        body2 = json.loads(resp2['body'])
        assert body2['status'] == 'accumulating_exercise'
        assert body2['batch_count'] == 2

        # Verify DynamoDB.
        item = table.get_item(Key={'session_id': sid}).get('Item', {})
        assert int(item['batch_count']) == 2
        assert item['status'] == 'accumulating_exercise'

    def test_exercise_scores_after_threshold(self, ingest_setup):
        """When ingest_started_at is 300+ seconds ago, the exercise batch should
        trigger scoring and return exercise_results."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-ex-score'

        # Pre-populate with exercise accumulation state.
        exercise_data = _sample_batch(80)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/exercise_batches.json',
            Body=json.dumps(exercise_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_exercise',
            device_id=DEVICE_ID,
            assessment_results={
                'Reach': 'FAIL', 'Grasp': 'PASS',
                'Manipulation': 'FAIL', 'Release': 'FAIL',
                'needed_training': ['Reach', 'Manipulation', 'Release'],
            },
            ingest_started_at=_past_iso(320),  # 320s ago, exceeds 300s threshold
            last_batch_at=_past_iso(15),
            batch_count=4,
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'exercised'
        assert 'exercise_results' in body
        assert body['exercise_results']['exercise'] == 'Reach'

        # Verify DynamoDB.
        item = table.get_item(Key={'session_id': sid}).get('Item', {})
        assert item['status'] == 'exercised'

    def test_exercise_does_not_score_before_threshold(self, ingest_setup):
        """Exercise batches should not trigger scoring if within the 300s window."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-ex-early'

        exercise_data = _sample_batch(60)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/exercise_batches.json',
            Body=json.dumps(exercise_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_exercise',
            device_id=DEVICE_ID,
            assessment_results={
                'Reach': 'FAIL', 'Grasp': 'PASS',
                'Manipulation': 'FAIL', 'Release': 'FAIL',
                'needed_training': ['Reach', 'Manipulation', 'Release'],
            },
            ingest_started_at=_past_iso(150),  # Only 150s ago, well below 300s
            last_batch_at=_past_iso(5),
            batch_count=3,
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(15)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'accumulating_exercise'
        assert body['batch_count'] == 4
        assert 'exercise_results' not in body


class TestAccumulationEdgeCases:
    """Edge cases and boundary conditions for accumulation."""

    def test_assessment_at_exact_threshold_boundary(self, ingest_setup):
        """At exactly 180s elapsed, scoring should trigger."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-boundary-180'

        initial_data = _sample_batch(60)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/assessment_batches.json',
            Body=json.dumps(initial_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_assessment',
            device_id=DEVICE_ID,
            ingest_started_at=_past_iso(180),  # Exactly at threshold
            last_batch_at=_past_iso(5),
            batch_count=2,
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'assessed'
        assert 'assessment_results' in body

    def test_exercise_at_exact_threshold_boundary(self, ingest_setup):
        """At exactly 300s elapsed, exercise scoring should trigger."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-boundary-300'

        exercise_data = _sample_batch(60)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/exercise_batches.json',
            Body=json.dumps(exercise_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_exercise',
            device_id=DEVICE_ID,
            assessment_results={
                'Reach': 'FAIL', 'Grasp': 'PASS',
                'Manipulation': 'FAIL', 'Release': 'FAIL',
                'needed_training': ['Reach', 'Manipulation', 'Release'],
            },
            ingest_started_at=_past_iso(300),  # Exactly at threshold
            last_batch_at=_past_iso(5),
            batch_count=3,
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'exercised'
        assert 'exercise_results' in body

    def test_accumulating_status_preserved_between_batches(self, ingest_setup):
        """Sending a batch to a session already in accumulating_assessment status
        should continue accumulating (not restart or confuse the router)."""
        handler_mod, table, s3 = ingest_setup
        sid = 'acc-continue'

        initial_data = _sample_batch(30)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/assessment_batches.json',
            Body=json.dumps(initial_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_assessment',
            device_id=DEVICE_ID,
            ingest_started_at=_past_iso(60),  # 60s ago
            last_batch_at=_past_iso(10),
            batch_count=1,
        )

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(25)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'accumulating_assessment'
        assert body['batch_count'] == 2

        item = table.get_item(Key={'session_id': sid}).get('Item', {})
        assert item['status'] == 'accumulating_assessment'


class TestIngestResponseShape:
    """The /ingest response shape was previously inconsistent with GET /sessions/{id}.
    /ingest returned `{Reach: bool}` and `needed_training` at top level; GET returned
    PASS/FAIL strings merged with `needed_training`. Now both shapes match.
    """

    def test_assessment_response_uses_pass_fail_strings(self, ingest_setup):
        """When scoring does fire (after threshold), the response must still use
        PASS/FAIL strings."""
        handler_mod, table, s3 = ingest_setup
        sid = 'shape-1'

        initial_data = _sample_batch(80)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/assessment_batches.json',
            Body=json.dumps(initial_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_assessment',
            device_id=DEVICE_ID,
            ingest_started_at=_past_iso(200),
            last_batch_at=_past_iso(5),
            batch_count=2,
        )
        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body = json.loads(resp['body'])
        assert body['status'] == 'assessed'
        ar = body['assessment_results']
        for key, val in ar.items():
            if key == 'needed_training':
                assert isinstance(val, list)
            else:
                assert val in ('PASS', 'FAIL'), f'{key}={val!r}'

    def test_assessment_response_merges_needed_training(self, ingest_setup):
        """When assessment scoring fires, needed_training must be inside
        assessment_results (matching GET shape), not at top-level."""
        handler_mod, table, s3 = ingest_setup
        sid = 'shape-2'

        initial_data = _sample_batch(80)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f'sensor-data/{sid}/assessment_batches.json',
            Body=json.dumps(initial_data),
            ContentType='application/json',
        )
        _put_session(
            table, sid,
            status='accumulating_assessment',
            device_id=DEVICE_ID,
            ingest_started_at=_past_iso(200),
            last_batch_at=_past_iso(5),
            batch_count=2,
        )
        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body = json.loads(resp['body'])
        assert body['status'] == 'assessed'
        assert 'needed_training' in body['assessment_results']
        assert 'needed_training' not in body

    def test_accumulating_response_shape(self, ingest_setup):
        """The accumulating response should include batch_count and session_id."""
        handler_mod, table, _s3 = ingest_setup
        sid = 'shape-acc'
        _put_session(table, sid, status='created', device_id=DEVICE_ID)

        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': _sample_batch(20)}
        ), None)
        body = json.loads(resp['body'])

        assert resp['statusCode'] == 200
        assert body['status'] == 'accumulating_assessment'
        assert 'batch_count' in body
        assert 'session_id' in body


class TestIngestValidation:
    def test_invalid_json_body_returns_400(self, ingest_setup):
        handler_mod, _table, _s3 = ingest_setup
        resp = handler_mod.handler({'body': 'not json'}, None)
        assert resp['statusCode'] == 400

    def test_string_field_returns_400_not_502(self, ingest_setup):
        """Pre-fix, a sample with `fsr1: "high"` caused an unhandled exception
        deep in assess_logic. The validator now catches this at the boundary."""
        handler_mod, table, _s3 = ingest_setup
        sid = 'val-1'
        _put_session(table, sid, status='created', device_id=DEVICE_ID)
        bad_sample = {
            'time': 0,
            'flex1': 40, 'flex2': 35,
            'fsr1': 'high', 'fsr2': 45,  # type error
            'emg': 300,
            'ax': 0, 'ay': 0, 'az': 16000,
            'gx': 0, 'gy': 0, 'gz': 0,
        }
        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': [bad_sample]}
        ), None)
        assert resp['statusCode'] == 400
        assert 'invalid_payload' in resp['body']

    def test_missing_keys_returns_400(self, ingest_setup):
        handler_mod, table, _s3 = ingest_setup
        sid = 'val-2'
        _put_session(table, sid, status='created', device_id=DEVICE_ID)
        resp = handler_mod.handler(_ingest_event(
            {'device_id': DEVICE_ID, 'data': [{'time': 0, 'flex1': 10}]}
        ), None)
        assert resp['statusCode'] == 400
