#!/bin/bash
# deploy.sh — full deploy from scratch
# Creates all AWS resources and prints the API base URL.
# Run: REGION=us-east-1 ./backend/infra/deploy.sh

set -e

REGION="${REGION:-eu-west-3}"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --region "$REGION")
BUCKET="hope-data-${ACCOUNT_ID}"
TABLE="hope-sessions"
ROLE_NAME="hope-lambda-role"
API_NAME="hope-api"
STAGE="prod"

# Resolve repo root (two levels up from this script)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LAMBDAS_DIR="$SCRIPT_DIR/../lambdas"

echo "==> HOPE deploy starting"
echo "    Region  : $REGION"
echo "    Account : $ACCOUNT_ID"
echo "    Bucket  : $BUCKET"
echo ""

# --- 1. IAM Role ---
echo "[1/7] Creating IAM role..."
TRUST='{
  "Version":"2012-10-17",
  "Statement":[{"Effect":"Allow","Principal":{"Service":"lambda.amazonaws.com"},"Action":"sts:AssumeRole"}]
}'

ROLE_ARN=$(aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document "$TRUST" \
  --query 'Role.Arn' --output text 2>/dev/null \
  || aws iam get-role --role-name "$ROLE_NAME" --query 'Role.Arn' --output text)

POLICY="{
  \"Version\":\"2012-10-17\",
  \"Statement\":[
    {\"Effect\":\"Allow\",\"Action\":[\"dynamodb:PutItem\",\"dynamodb:GetItem\",\"dynamodb:UpdateItem\",\"dynamodb:DeleteItem\",\"dynamodb:Scan\"],\"Resource\":\"arn:aws:dynamodb:${REGION}:${ACCOUNT_ID}:table/${TABLE}\"},
    {\"Effect\":\"Allow\",\"Action\":[\"s3:PutObject\",\"s3:GetObject\",\"s3:DeleteObject\",\"s3:ListBucket\"],\"Resource\":[\"arn:aws:s3:::${BUCKET}\",\"arn:aws:s3:::${BUCKET}/*\"]},
    {\"Effect\":\"Allow\",\"Action\":[\"logs:CreateLogGroup\",\"logs:CreateLogStream\",\"logs:PutLogEvents\"],\"Resource\":\"arn:aws:logs:*:*:*\"}
  ]
}"
aws iam put-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name "hope-lambda-policy" \
  --policy-document "$POLICY"
echo "    Role ARN: $ROLE_ARN"
sleep 5  # IAM propagation

# --- 2. DynamoDB ---
echo "[2/7] Creating DynamoDB table..."
aws dynamodb create-table \
  --table-name "$TABLE" \
  --attribute-definitions AttributeName=session_id,AttributeType=S \
  --key-schema AttributeName=session_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$REGION" 2>/dev/null || echo "    Table already exists."

# --- 3. S3 ---
echo "[3/7] Creating S3 bucket..."
if [ "$REGION" = "us-east-1" ]; then
  aws s3api create-bucket --bucket "$BUCKET" --region "$REGION" 2>/dev/null || echo "    Bucket already exists."
else
  aws s3api create-bucket --bucket "$BUCKET" --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION" 2>/dev/null || echo "    Bucket already exists."
fi
aws s3api put-public-access-block --bucket "$BUCKET" \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" \
  --region "$REGION"

# Add S3 CORS for presigned video uploads from Flutter app
aws s3api put-bucket-cors --bucket "$BUCKET" --cors-configuration '{
  "CORSRules":[{
    "AllowedOrigins":["*"],
    "AllowedMethods":["PUT","GET"],
    "AllowedHeaders":["*"],
    "MaxAgeSeconds":3000
  }]
}' --region "$REGION"

# --- 4. Package & deploy Lambdas ---
echo "[4/7] Deploying Lambda functions..."

deploy_lambda() {
  local NAME=$1
  local DIR="$LAMBDAS_DIR/$NAME"
  local ZIP="/tmp/${NAME}.zip"

  cd "$DIR"
  zip -q "$ZIP" *.py
  cd - > /dev/null

  if aws lambda get-function --function-name "$NAME" --region "$REGION" > /dev/null 2>&1; then
    aws lambda update-function-code \
      --function-name "$NAME" \
      --zip-file "fileb://$ZIP" \
      --region "$REGION" > /dev/null
    echo "    Updated: $NAME"
  else
    aws lambda create-function \
      --function-name "$NAME" \
      --runtime python3.12 \
      --role "$ROLE_ARN" \
      --handler handler.handler \
      --zip-file "fileb://$ZIP" \
      --timeout 30 \
      --memory-size 256 \
      --region "$REGION" > /dev/null
    echo "    Created: $NAME"
  fi

  # Wait for Lambda to be ready (Active + no pending update)
  echo "    Waiting for $NAME to stabilize..."
  for i in $(seq 1 24); do
    STATE=$(aws lambda get-function-configuration --function-name "$NAME" --region "$REGION" --query 'State' --output text 2>/dev/null || echo "Pending")
    LAST_UPDATE=$(aws lambda get-function-configuration --function-name "$NAME" --region "$REGION" --query 'LastUpdateStatus' --output text 2>/dev/null || echo "InProgress")
    if [ "$STATE" = "Active" ] && [ "$LAST_UPDATE" != "InProgress" ]; then break; fi
    sleep 5
  done

  # Set environment variable for bucket + table + S3 region
  aws lambda update-function-configuration \
    --function-name "$NAME" \
    --environment "Variables={HOPE_BUCKET=${BUCKET},TABLE=${TABLE},HOPE_S3_REGION=${REGION}}" \
    --region "$REGION" > /dev/null
}

deploy_lambda "hope_session_api"
deploy_lambda "hope_ingest"

# --- 5. API Gateway ---
echo "[5/7] Creating API Gateway..."
API_ID=$(aws apigateway get-rest-apis \
  --query "items[?name=='${API_NAME}'].id" \
  --output text --region "$REGION")

if [ -z "$API_ID" ] || [ "$API_ID" = "None" ]; then
  API_ID=$(aws apigateway create-rest-api \
    --name "$API_NAME" \
    --query 'id' --output text --region "$REGION")
  echo "    Created API: $API_ID"
else
  echo "    Reusing existing API: $API_ID"
fi

ROOT_ID=$(aws apigateway get-resources \
  --rest-api-id "$API_ID" \
  --query 'items[?path==`/`].id' \
  --output text --region "$REGION")

# Helper: get or create a resource
get_or_create_resource() {
  local PARENT_ID=$1
  local PATH_PART=$2
  local EXISTING
  EXISTING=$(aws apigateway get-resources \
    --rest-api-id "$API_ID" \
    --query "items[?pathPart=='${PATH_PART}' && parentId=='${PARENT_ID}'].id" \
    --output text --region "$REGION")
  if [ -z "$EXISTING" ] || [ "$EXISTING" = "None" ]; then
    aws apigateway create-resource \
      --rest-api-id "$API_ID" \
      --parent-id "$PARENT_ID" \
      --path-part "$PATH_PART" \
      --query 'id' --output text --region "$REGION"
  else
    echo "$EXISTING"
  fi
}

# Helper: add method + lambda integration + CORS
add_method() {
  local RESOURCE_ID=$1
  local HTTP_METHOD=$2
  local LAMBDA_NAME=$3
  local LAMBDA_ARN="arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:${LAMBDA_NAME}"
  local URI="arn:aws:apigateway:${REGION}:lambda:path/2015-03-31/functions/${LAMBDA_ARN}/invocations"

  aws apigateway put-method \
    --rest-api-id "$API_ID" \
    --resource-id "$RESOURCE_ID" \
    --http-method "$HTTP_METHOD" \
    --authorization-type NONE \
    --region "$REGION" > /dev/null 2>&1 || true

  aws apigateway put-integration \
    --rest-api-id "$API_ID" \
    --resource-id "$RESOURCE_ID" \
    --http-method "$HTTP_METHOD" \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri "$URI" \
    --region "$REGION" > /dev/null

  # Grant API Gateway permission to invoke the Lambda
  aws lambda add-permission \
    --function-name "$LAMBDA_NAME" \
    --statement-id "apigw-${RESOURCE_ID}-${HTTP_METHOD}" \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:${REGION}:${ACCOUNT_ID}:${API_ID}/*/${HTTP_METHOD}/*" \
    --region "$REGION" > /dev/null 2>&1 || true

  # OPTIONS method for CORS
  aws apigateway put-method \
    --rest-api-id "$API_ID" \
    --resource-id "$RESOURCE_ID" \
    --http-method OPTIONS \
    --authorization-type NONE \
    --region "$REGION" > /dev/null 2>&1 || true

  aws apigateway put-integration \
    --rest-api-id "$API_ID" \
    --resource-id "$RESOURCE_ID" \
    --http-method OPTIONS \
    --type MOCK \
    --request-templates '{"application/json":"{\"statusCode\":200}"}' \
    --region "$REGION" > /dev/null 2>&1 || true
}

echo "[6/7] Wiring routes..."

# /sessions
SESSIONS_ID=$(get_or_create_resource "$ROOT_ID" "sessions")
add_method "$SESSIONS_ID" "POST" "hope_session_api"
add_method "$SESSIONS_ID" "GET"  "hope_session_api"

# /sessions/{session_id}
SESSION_ID_RES=$(get_or_create_resource "$SESSIONS_ID" "{session_id}")
add_method "$SESSION_ID_RES" "GET"    "hope_session_api"
add_method "$SESSION_ID_RES" "DELETE" "hope_session_api"

# /sessions/{session_id}/questionnaire
QUEST_ID=$(get_or_create_resource "$SESSION_ID_RES" "questionnaire")
add_method "$QUEST_ID" "PUT" "hope_session_api"

# /sessions/{session_id}/video-upload-url
VIDEO_ID=$(get_or_create_resource "$SESSION_ID_RES" "video-upload-url")
add_method "$VIDEO_ID" "POST" "hope_session_api"

# /sessions/{session_id}/device
DEVICE_RES=$(get_or_create_resource "$SESSION_ID_RES" "device")
add_method "$DEVICE_RES" "PUT" "hope_session_api"

# /sessions/{session_id}/redo-assessment
REDO_RES=$(get_or_create_resource "$SESSION_ID_RES" "redo-assessment")
add_method "$REDO_RES" "POST" "hope_session_api"

# /ingest — the single endpoint the ESP32 glove POSTs all sensor data to
INGEST_ID=$(get_or_create_resource "$ROOT_ID" "ingest")
add_method "$INGEST_ID" "POST" "hope_ingest"

# --- 6. Deploy to prod stage ---
echo "[7/7] Deploying to '$STAGE' stage..."
aws apigateway create-deployment \
  --rest-api-id "$API_ID" \
  --stage-name "$STAGE" \
  --region "$REGION" > /dev/null

BASE_URL="https://${API_ID}.execute-api.${REGION}.amazonaws.com/${STAGE}"

# Save URL for other scripts to use
echo "$BASE_URL" > "$SCRIPT_DIR/.api_url"

echo ""
echo "==> Deploy complete!"
echo ""
echo "    API Base URL:"
echo "    $BASE_URL"
echo ""
echo "    Update these files with the URL above:"
echo "    1. flutter_app/lib/config.dart  →  AppConfig.apiBaseUrl"
echo "    2. firmware/hope_glove/hope_glove.ino →  INGEST_URL (append /ingest), then reflash ESP32"
echo ""
echo "    Verifying deploy..."
CODE=$(curl -sS -o /tmp/hope_deploy_check.txt -w '%{http_code}' "$BASE_URL/sessions" --max-time 30 || echo "000")
if [ "$CODE" = "200" ]; then
  echo "    OK — GET $BASE_URL/sessions returned 200."
else
  echo "    WARN — GET $BASE_URL/sessions returned HTTP $CODE (first Lambda cold-start can take up to 15s; retry in a moment)."
  echo "    Response: $(head -c 200 /tmp/hope_deploy_check.txt)"
fi
rm -f /tmp/hope_deploy_check.txt
