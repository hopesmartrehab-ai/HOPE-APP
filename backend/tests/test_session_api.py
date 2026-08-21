"""Level 2 tests — hope_session_api handler (mocked AWS)."""
import json
import os
import sys
import importlib.util
import pytest
import boto3
from moto import mock_aws

HANDLER_PATH = os.path.join(os.path.dirname(__file__), '../lambdas/hope_session_api/handler.py')
TABLE_NAME = 'hope-sessions'
BUCKET_NAME = 'hope-data-test'


def set_aws_env():
    os.environ['AWS_DEFAULT_REGION'] = 'us-east-1'
    os.environ['AWS_ACCESS_KEY_ID'] = 'test'
    os.environ['AWS_SECRET_ACCESS_KEY'] = 'test'
    os.environ['HOPE_BUCKET'] = BUCKET_NAME


def load_handler():
    spec = importlib.util.spec_from_file_location('hope_session_api_handler', HANDLER_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


@pytest.fixture
def aws_setup():
    with mock_aws():
        set_aws_env()
        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.create_table(
            TableName=TABLE_NAME,
            KeySchema=[{'AttributeName': 'session_id', 'KeyType': 'HASH'}],
            AttributeDefinitions=[{'AttributeName': 'session_id', 'AttributeType': 'S'}],
            BillingMode='PAY_PER_REQUEST'
        )
        s3 = boto3.client('s3', region_name='us-east-1')
        s3.create_bucket(Bucket=BUCKET_NAME)
        yield load_handler()


def apigw_event(method, resource, path_params=None, body=None):
    return {
        'httpMethod': method,
        'resource': resource,
        'pathParameters': path_params or {},
        'body': json.dumps(body) if body is not None else None
    }


class TestCreateSession:
    def test_post_sessions_returns_201(self, aws_setup):
        resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        assert resp['statusCode'] == 201

    def test_post_sessions_returns_session_id(self, aws_setup):
        resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        body = json.loads(resp['body'])
        assert 'session_id' in body
        assert len(body['session_id']) > 0

    def test_post_sessions_returns_created_at(self, aws_setup):
        resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        body = json.loads(resp['body'])
        assert 'created_at' in body

    def test_post_sessions_status_is_created(self, aws_setup):
        resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        body = json.loads(resp['body'])
        assert body['status'] == 'created'

    def test_cors_header_present(self, aws_setup):
        resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        assert resp['headers']['Access-Control-Allow-Origin'] == '*'


class TestGetSession:
    def test_get_existing_session_returns_200(self, aws_setup):
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                             path_params={'session_id': session_id}), None)
        assert resp['statusCode'] == 200

    def test_get_session_returns_correct_id(self, aws_setup):
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                             path_params={'session_id': session_id}), None)
        body = json.loads(resp['body'])
        assert body['session_id'] == session_id

    def test_get_missing_session_returns_404(self, aws_setup):
        resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                             path_params={'session_id': 'nonexistent-id'}), None)
        assert resp['statusCode'] == 404

    def test_get_missing_session_error_body(self, aws_setup):
        resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                             path_params={'session_id': 'nonexistent-id'}), None)
        body = json.loads(resp['body'])
        assert 'error' in body


class TestListSessions:
    def test_get_sessions_returns_200(self, aws_setup):
        resp = aws_setup.handler(apigw_event('GET', '/sessions'), None)
        assert resp['statusCode'] == 200

    def test_get_sessions_returns_list(self, aws_setup):
        resp = aws_setup.handler(apigw_event('GET', '/sessions'), None)
        body = json.loads(resp['body'])
        assert 'sessions' in body
        assert isinstance(body['sessions'], list)

    def test_get_sessions_includes_created_sessions(self, aws_setup):
        aws_setup.handler(apigw_event('POST', '/sessions'), None)
        aws_setup.handler(apigw_event('POST', '/sessions'), None)

        resp = aws_setup.handler(apigw_event('GET', '/sessions'), None)
        body = json.loads(resp['body'])
        assert len(body['sessions']) == 2


class TestQuestionnaire:
    def test_put_questionnaire_returns_200(self, aws_setup):
        # Uses the wrapped {"answers": ...} form for backwards compatibility coverage.
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        resp = aws_setup.handler(apigw_event(
            'PUT', '/sessions/{session_id}/questionnaire',
            path_params={'session_id': session_id},
            body={'answers': {'sleep_hours': 7.5, 'headache': False}}
        ), None)
        assert resp['statusCode'] == 200

    def test_put_questionnaire_status_becomes_questionnaire_done(self, aws_setup):
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        aws_setup.handler(apigw_event(
            'PUT', '/sessions/{session_id}/questionnaire',
            path_params={'session_id': session_id},
            body={'answers': {'sleep_hours': 7.5}}
        ), None)

        get_resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                                 path_params={'session_id': session_id}), None)
        body = json.loads(get_resp['body'])
        assert body['status'] == 'questionnaire_done'

    def test_put_questionnaire_does_not_regress_status_from_assessed(self, aws_setup):
        """Guard against the old bug where PUT /questionnaire overwrote
        status='assessed' with 'questionnaire_done', which confused the /ingest
        router and caused exercise data to be re-assessed.

        After assessment, submitting the questionnaire must NOT move status
        backwards — it should only write the questionnaire data and keep status
        at 'assessed' (or wherever it already is).
        """
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        # Simulate the assessment already having happened: set status directly.
        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.Table(TABLE_NAME).update_item(
            Key={'session_id': session_id},
            UpdateExpression='SET #s = :s, assessment_results = :ar',
            ExpressionAttributeNames={'#s': 'status'},
            ExpressionAttributeValues={
                ':s': 'assessed',
                ':ar': {'Reach': 'PASS', 'Grasp': 'FAIL', 'Manipulation': 'FAIL', 'Release': 'FAIL',
                        'needed_training': ['Grasp', 'Manipulation', 'Release']},
            },
        )

        resp = aws_setup.handler(apigw_event(
            'PUT', '/sessions/{session_id}/questionnaire',
            path_params={'session_id': session_id},
            body={'sleep_hours': 7.5, 'headache': False},
        ), None)
        assert resp['statusCode'] == 200
        # Response should reflect the *current* status (still 'assessed'), not regress.
        assert json.loads(resp['body'])['status'] == 'assessed'

        get_resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                                 path_params={'session_id': session_id}), None)
        body = json.loads(get_resp['body'])
        assert body['status'] == 'assessed'
        assert body['questionnaire'] == {'sleep_hours': 7.5, 'headache': False}
        # Crucially — assessment_results must still be there, untouched.
        assert body['assessment_results']['Reach'] == 'PASS'

    def test_put_questionnaire_accepts_raw_shape_from_app(self, aws_setup):
        # The Flutter app sends the 10-question daily check-in at the top level,
        # not wrapped in {"answers": ...}. The backend supports both shapes via
        # `body.get('answers', body)` — this test pins the raw shape.
        # Schema comes from flutter_app/lib/screens/patient/questionnaire_screen.dart:18-39.
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        raw_body = {
            'sleep_hours': 7.5,
            'body_temperature': 37.0,
            'blood_sugar': 100,
            'blood_pressure': {'systolic': 120, 'diastolic': 80},
            'headache': False,
            'dizzy': False,
            'fatigue': True,
            'arm_pain': 3,
            'hand_movement': True,
            'falls_injuries': False,
        }
        resp = aws_setup.handler(apigw_event(
            'PUT', '/sessions/{session_id}/questionnaire',
            path_params={'session_id': session_id},
            body=raw_body,
        ), None)
        assert resp['statusCode'] == 200

        get_resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                                 path_params={'session_id': session_id}), None)
        got = json.loads(get_resp['body'])
        assert got['status'] == 'questionnaire_done'
        assert got['questionnaire'] == raw_body


class TestVideoUploadUrl:
    def test_post_video_upload_url_returns_200(self, aws_setup):
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        resp = aws_setup.handler(apigw_event(
            'POST', '/sessions/{session_id}/video-upload-url',
            path_params={'session_id': session_id}
        ), None)
        assert resp['statusCode'] == 200

    def test_post_video_upload_url_returns_upload_url(self, aws_setup):
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        resp = aws_setup.handler(apigw_event(
            'POST', '/sessions/{session_id}/video-upload-url',
            path_params={'session_id': session_id}
        ), None)
        body = json.loads(resp['body'])
        assert 'upload_url' in body
        assert len(body['upload_url']) > 0


class TestListSessionsRobustness:
    def test_list_does_not_crash_on_row_missing_created_at(self, aws_setup):
        """Pre-fix, a single row without `created_at` caused GET /sessions to
        return 502 because the handler did `s['created_at']` directly. The
        defensive `.get('created_at', '')` keeps the endpoint responsive even
        if a malformed row sneaks in."""
        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.Table(TABLE_NAME).put_item(Item={'session_id': 'no-timestamp', 'status': 'created'})
        # And a well-formed one to make sure good rows still come through.
        aws_setup.handler(apigw_event('POST', '/sessions'), None)

        resp = aws_setup.handler(apigw_event('GET', '/sessions'), None)
        assert resp['statusCode'] == 200
        body = json.loads(resp['body'])
        assert len(body['sessions']) == 2

    def test_list_includes_exercise_name(self, aws_setup):
        """The dashboard needs to know which exercise category each session
        belongs to. The list response surfaces exercise_name from
        exercise_results.exercise."""
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']
        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        from decimal import Decimal
        ddb.Table(TABLE_NAME).update_item(
            Key={'session_id': session_id},
            UpdateExpression='SET exercise_results = :er',
            ExpressionAttributeValues={
                ':er': {'exercise': 'Reach', 'overall_percent': Decimal('72.5')},
            },
        )
        resp = aws_setup.handler(apigw_event('GET', '/sessions'), None)
        target = next(
            s for s in json.loads(resp['body'])['sessions']
            if s['session_id'] == session_id
        )
        assert target['exercise_name'] == 'Reach'
        assert target['exercise_overall_percent'] == 72.5

    def test_list_includes_has_video_flag(self, aws_setup):
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']
        # Touch video_s3_key directly to simulate a session that has uploaded a video.
        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.Table(TABLE_NAME).update_item(
            Key={'session_id': session_id},
            UpdateExpression='SET video_s3_key = :k',
            ExpressionAttributeValues={':k': f'videos/{session_id}/video.mp4'},
        )
        resp = aws_setup.handler(apigw_event('GET', '/sessions'), None)
        body = json.loads(resp['body'])
        target = next(s for s in body['sessions'] if s['session_id'] == session_id)
        assert target['has_video'] is True


class TestSessionExistenceChecks:
    def test_link_device_on_missing_session_returns_404(self, aws_setup):
        resp = aws_setup.handler(apigw_event(
            'PUT', '/sessions/{session_id}/device',
            path_params={'session_id': 'made-up-id'},
            body={'device_id': 'hope-glove-01'},
        ), None)
        assert resp['statusCode'] == 404

    def test_video_upload_url_on_missing_session_returns_404(self, aws_setup):
        resp = aws_setup.handler(apigw_event(
            'POST', '/sessions/{session_id}/video-upload-url',
            path_params={'session_id': 'made-up-id'},
        ), None)
        assert resp['statusCode'] == 404


class TestDeleteSession:
    def test_delete_existing_session_returns_200(self, aws_setup):
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']
        resp = aws_setup.handler(apigw_event(
            'DELETE', '/sessions/{session_id}',
            path_params={'session_id': session_id},
        ), None)
        assert resp['statusCode'] == 200

    def test_delete_removes_session(self, aws_setup):
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']
        aws_setup.handler(apigw_event(
            'DELETE', '/sessions/{session_id}',
            path_params={'session_id': session_id},
        ), None)
        get_resp = aws_setup.handler(apigw_event(
            'GET', '/sessions/{session_id}',
            path_params={'session_id': session_id},
        ), None)
        assert get_resp['statusCode'] == 404

    def test_delete_missing_session_returns_404(self, aws_setup):
        resp = aws_setup.handler(apigw_event(
            'DELETE', '/sessions/{session_id}',
            path_params={'session_id': 'no-such-id'},
        ), None)
        assert resp['statusCode'] == 404


class TestRedoAssessment:
    def test_redo_clears_assessment_results(self, aws_setup):
        """After a user taps "redo assessment", the next /ingest batch should be
        treated as a fresh assessment. The router keys on assessment_results
        presence, so removing the attribute is the canonical reset."""
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.Table(TABLE_NAME).update_item(
            Key={'session_id': session_id},
            UpdateExpression='SET assessment_results = :ar, #s = :s',
            ExpressionAttributeNames={'#s': 'status'},
            ExpressionAttributeValues={
                ':ar': {'Reach': 'PASS', 'needed_training': []},
                ':s': 'assessed',
            },
        )

        resp = aws_setup.handler(apigw_event(
            'POST', '/sessions/{session_id}/redo-assessment',
            path_params={'session_id': session_id},
        ), None)
        assert resp['statusCode'] == 200

        get_resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                                 path_params={'session_id': session_id}), None)
        body = json.loads(get_resp['body'])
        assert body['assessment_results'] is None
        assert body['status'] == 'created'

    def test_redo_clears_accumulation_fields(self, aws_setup):
        """After redo, ingest_started_at, last_batch_at, and batch_count should
        be cleared so the next ingest batch starts a fresh accumulation window."""
        from datetime import datetime, timezone, timedelta

        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        now = datetime.now(timezone.utc)
        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.Table(TABLE_NAME).update_item(
            Key={'session_id': session_id},
            UpdateExpression=(
                'SET assessment_results = :ar, #s = :s, '
                'ingest_started_at = :ist, last_batch_at = :lba, batch_count = :bc'
            ),
            ExpressionAttributeNames={'#s': 'status'},
            ExpressionAttributeValues={
                ':ar': {'Reach': 'PASS', 'needed_training': []},
                ':s': 'assessed',
                ':ist': (now - timedelta(seconds=200)).isoformat(),
                ':lba': (now - timedelta(seconds=5)).isoformat(),
                ':bc': 5,
            },
        )

        resp = aws_setup.handler(apigw_event(
            'POST', '/sessions/{session_id}/redo-assessment',
            path_params={'session_id': session_id},
        ), None)
        assert resp['statusCode'] == 200

        # Verify accumulation fields are cleared.
        item = ddb.Table(TABLE_NAME).get_item(
            Key={'session_id': session_id}, ConsistentRead=True
        ).get('Item', {})
        assert item['status'] == 'created'
        assert item.get('assessment_results') is None or 'assessment_results' not in item
        assert item.get('ingest_started_at') is None or 'ingest_started_at' not in item
        assert item.get('last_batch_at') is None or 'last_batch_at' not in item
        assert item.get('batch_count') is None or 'batch_count' not in item

    def test_redo_on_missing_session_returns_404(self, aws_setup):
        resp = aws_setup.handler(apigw_event(
            'POST', '/sessions/{session_id}/redo-assessment',
            path_params={'session_id': 'no-such-id'},
        ), None)
        assert resp['statusCode'] == 404


class TestNonJsonBody:
    def test_post_sessions_with_garbage_body_returns_400(self, aws_setup):
        """Pre-fix, sending a non-JSON body to POST /sessions caused a 502
        because handler() did json.loads() unguarded. Now it should 400."""
        event = {
            'httpMethod': 'POST',
            'resource': '/sessions',
            'pathParameters': {},
            'body': 'this is not json',
        }
        resp = aws_setup.handler(event, None)
        assert resp['statusCode'] == 400


class TestGetSessionAccumulationFields:
    """Verify that GET /sessions/{id} returns the new accumulation fields
    added as part of the batch-accumulation feature."""

    def test_get_session_includes_accumulation_fields_when_accumulating(self, aws_setup):
        """A session in the accumulating_assessment status should return
        ingest_started_at, last_batch_at, batch_count, accumulation_phase,
        and seconds_required in the GET response."""
        from datetime import datetime, timezone, timedelta

        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        now = datetime.now(timezone.utc)
        started = (now - timedelta(seconds=90)).isoformat()
        last_batch = (now - timedelta(seconds=5)).isoformat()

        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.Table(TABLE_NAME).update_item(
            Key={'session_id': session_id},
            UpdateExpression=(
                'SET #s = :s, ingest_started_at = :ist, '
                'last_batch_at = :lba, batch_count = :bc'
            ),
            ExpressionAttributeNames={'#s': 'status'},
            ExpressionAttributeValues={
                ':s': 'accumulating_assessment',
                ':ist': started,
                ':lba': last_batch,
                ':bc': 3,
            },
        )

        resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                             path_params={'session_id': session_id}), None)
        assert resp['statusCode'] == 200
        body = json.loads(resp['body'])

        assert body['status'] == 'accumulating_assessment'
        assert body['ingest_started_at'] == started
        assert body['last_batch_at'] == last_batch
        assert body['batch_count'] == 3
        assert body['accumulation_phase'] == 'assessment'
        assert body['seconds_required'] == 180

    def test_get_session_includes_exercise_accumulation_fields(self, aws_setup):
        """A session in accumulating_exercise should report phase=exercise
        and seconds_required=300."""
        from datetime import datetime, timezone, timedelta

        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        now = datetime.now(timezone.utc)
        started = (now - timedelta(seconds=120)).isoformat()
        last_batch = (now - timedelta(seconds=8)).isoformat()

        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.Table(TABLE_NAME).update_item(
            Key={'session_id': session_id},
            UpdateExpression=(
                'SET #s = :s, ingest_started_at = :ist, '
                'last_batch_at = :lba, batch_count = :bc, '
                'assessment_results = :ar'
            ),
            ExpressionAttributeNames={'#s': 'status'},
            ExpressionAttributeValues={
                ':s': 'accumulating_exercise',
                ':ist': started,
                ':lba': last_batch,
                ':bc': 5,
                ':ar': {
                    'Reach': 'FAIL', 'Grasp': 'PASS',
                    'Manipulation': 'FAIL', 'Release': 'FAIL',
                    'needed_training': ['Reach', 'Manipulation', 'Release'],
                },
            },
        )

        resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                             path_params={'session_id': session_id}), None)
        assert resp['statusCode'] == 200
        body = json.loads(resp['body'])

        assert body['status'] == 'accumulating_exercise'
        assert body['ingest_started_at'] == started
        assert body['last_batch_at'] == last_batch
        assert body['batch_count'] == 5
        assert body['accumulation_phase'] == 'exercise'
        assert body['seconds_required'] == 300

    def test_get_session_accumulation_fields_null_when_not_accumulating(self, aws_setup):
        """A session that has never accumulated (status=created) should return
        null for the accumulation-related fields."""
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                             path_params={'session_id': session_id}), None)
        assert resp['statusCode'] == 200
        body = json.loads(resp['body'])

        assert body.get('ingest_started_at') is None
        assert body.get('last_batch_at') is None
        assert body.get('batch_count') is None
        assert body.get('accumulation_phase') is None
        assert body.get('seconds_required') is None

    def test_get_session_accumulation_fields_null_after_scoring(self, aws_setup):
        """After assessment scoring completes (status=assessed), the accumulation
        phase fields should reflect no active accumulation."""
        create_resp = aws_setup.handler(apigw_event('POST', '/sessions'), None)
        session_id = json.loads(create_resp['body'])['session_id']

        ddb = boto3.resource('dynamodb', region_name='us-east-1')
        ddb.Table(TABLE_NAME).update_item(
            Key={'session_id': session_id},
            UpdateExpression='SET #s = :s, assessment_results = :ar',
            ExpressionAttributeNames={'#s': 'status'},
            ExpressionAttributeValues={
                ':s': 'assessed',
                ':ar': {
                    'Reach': 'PASS', 'Grasp': 'FAIL',
                    'Manipulation': 'FAIL', 'Release': 'FAIL',
                    'needed_training': ['Grasp', 'Manipulation', 'Release'],
                },
            },
        )

        resp = aws_setup.handler(apigw_event('GET', '/sessions/{session_id}',
                                             path_params={'session_id': session_id}), None)
        body = json.loads(resp['body'])

        assert body['status'] == 'assessed'
        assert body.get('accumulation_phase') is None
        assert body.get('seconds_required') is None


class TestUnknownRoute:
    def test_unknown_route_returns_404(self, aws_setup):
        resp = aws_setup.handler(apigw_event('PATCH', '/sessions'), None)
        assert resp['statusCode'] == 404
