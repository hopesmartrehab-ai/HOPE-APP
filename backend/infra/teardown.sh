#!/bin/bash
# teardown.sh — destroy everything
# WARNING: The next deploy.sh will generate a new API Gateway URL.
#          You must update INGEST_URL in firmware/hope_glove/hope_glove.ino
#          and flutter_app/lib/config.dart, then reflash the ESP32.
#
# For between-demo cleanup without destroying infra, use cleanup.sh instead.

set -e

REGION="${REGION:-eu-west-3}"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --region "$REGION")
BUCKET="hope-data-${ACCOUNT_ID}"
TABLE="hope-sessions"
ROLE_NAME="hope-lambda-role"
API_NAME="hope-api"

echo "==> HOPE teardown"
echo ""
echo "    WARNING: This deletes everything. The API URL will change on next deploy."
echo "    For between-demo cleanup only, run cleanup.sh instead."
echo ""
read -p "    Type 'destroy' to confirm: " CONFIRM
if [ "$CONFIRM" != "destroy" ]; then
  echo "    Aborted."
  exit 0
fi
echo ""

# --- 1. Empty + delete S3 bucket ---
echo "[1/5] Deleting S3 bucket..."
aws s3 rm "s3://${BUCKET}" --recursive --region "$REGION" 2>/dev/null || true
aws s3api delete-bucket --bucket "$BUCKET" --region "$REGION" 2>/dev/null \
  && echo "    Deleted." || echo "    Bucket not found (skipping)."

# --- 2. Delete DynamoDB table ---
echo "[2/5] Deleting DynamoDB table..."
aws dynamodb delete-table --table-name "$TABLE" --region "$REGION" > /dev/null 2>/dev/null \
  && echo "    Deleted." || echo "    Table not found (skipping)."

# --- 3. Delete Lambda functions ---
# Includes old pre-refactor names (hope_assess, hope_exercise) as a safety net
# for accounts that still have them from a legacy deploy.
echo "[3/5] Deleting Lambda functions..."
for FN in hope_session_api hope_ingest hope_assess hope_exercise; do
  aws lambda delete-function --function-name "$FN" --region "$REGION" 2>/dev/null \
    && echo "    Deleted: $FN" || echo "    Not found: $FN (skipping)"
done

# Delete CloudWatch log groups (Lambda doesn't clean them up automatically — they
# persist and slowly accumulate charges if left behind across teardown cycles).
echo "    Deleting CloudWatch log groups..."
LGS=$(aws logs describe-log-groups --region "$REGION" \
  --log-group-name-prefix /aws/lambda/hope \
  --query 'logGroups[].logGroupName' --output text 2>/dev/null)
for LG in $LGS; do
  aws logs delete-log-group --log-group-name "$LG" --region "$REGION" 2>/dev/null \
    && echo "    Deleted: $LG" || true
done

# --- 4. Delete API Gateway ---
echo "[4/5] Deleting API Gateway..."
API_ID=$(aws apigateway get-rest-apis \
  --query "items[?name=='${API_NAME}'].id" \
  --output text --region "$REGION" 2>/dev/null || echo "")

if [ -n "$API_ID" ] && [ "$API_ID" != "None" ]; then
  aws apigateway delete-rest-api --rest-api-id "$API_ID" --region "$REGION"
  echo "    Deleted API: $API_ID"
else
  echo "    API not found (skipping)."
fi

# --- 5. Delete IAM role ---
echo "[5/5] Deleting IAM role..."
aws iam delete-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name "hope-lambda-policy" 2>/dev/null || true
aws iam delete-role --role-name "$ROLE_NAME" 2>/dev/null \
  && echo "    Deleted." || echo "    Role not found (skipping)."

# Remove saved URL file
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
rm -f "$SCRIPT_DIR/.api_url"

echo ""
echo "==> Teardown complete."
echo ""
echo "    Sanity check — any remaining HOPE resources in $REGION:"
REMAINING_FNS=$(aws lambda list-functions --region "$REGION" --query 'Functions[?contains(FunctionName,`hope`)].FunctionName' --output text 2>/dev/null)
REMAINING_APIS=$(aws apigateway get-rest-apis --region "$REGION" --query 'items[?contains(name,`hope`)].name' --output text 2>/dev/null)
REMAINING_TABLES=$(aws dynamodb list-tables --region "$REGION" --query 'TableNames[?contains(@,`hope`)]' --output text 2>/dev/null)
REMAINING_BUCKETS=$(aws s3api list-buckets --query 'Buckets[?contains(Name,`hope`)].Name' --output text 2>/dev/null)
if [ -z "$REMAINING_FNS$REMAINING_APIS$REMAINING_TABLES$REMAINING_BUCKETS" ]; then
  echo "    (none — clean)"
else
  echo "    Lambdas: $REMAINING_FNS"
  echo "    APIs:    $REMAINING_APIS"
  echo "    Tables:  $REMAINING_TABLES"
  echo "    Buckets: $REMAINING_BUCKETS  (may be in a non-default region — check with audit.sh)"
fi
echo ""
echo "    After running deploy.sh next time:"
echo "    1. flutter_app/lib/config.dart  →  update AppConfig.apiBaseUrl"
echo "    2. firmware/hope_glove/hope_glove.ino →  update INGEST_URL (append /ingest), then reflash"
