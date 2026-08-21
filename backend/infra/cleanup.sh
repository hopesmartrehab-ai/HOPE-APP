#!/bin/bash
# cleanup.sh — wipe data between demos
# Keeps all infra alive (URL unchanged). Only deletes S3 objects + DynamoDB items.
# Cost after cleanup: $0

set -e

REGION="${REGION:-us-east-1}"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --region "$REGION")
BUCKET="hope-data-${ACCOUNT_ID}"
TABLE="hope-sessions"

echo "==> HOPE cleanup starting (region: $REGION)"
echo "    Bucket : $BUCKET"
echo "    Table  : $TABLE"
echo ""

# --- Empty S3 bucket ---
echo "[1/2] Emptying S3 bucket..."
OBJECT_COUNT=$(aws s3api list-objects-v2 --bucket "$BUCKET" --query 'KeyCount' --output text --region "$REGION" 2>/dev/null || echo "0")

if [ "$OBJECT_COUNT" = "0" ] || [ -z "$OBJECT_COUNT" ]; then
  echo "      Bucket already empty."
else
  aws s3 rm "s3://${BUCKET}" --recursive --region "$REGION"
  echo "      Deleted $OBJECT_COUNT objects."
fi

# --- Wipe DynamoDB table ---
echo "[2/2] Deleting all DynamoDB items..."
ITEMS=$(aws dynamodb scan \
  --table-name "$TABLE" \
  --projection-expression "session_id" \
  --query "Items[*].session_id.S" \
  --output text \
  --region "$REGION" 2>/dev/null || echo "")

if [ -z "$ITEMS" ]; then
  echo "      Table already empty."
else
  COUNT=0
  for ID in $ITEMS; do
    aws dynamodb delete-item \
      --table-name "$TABLE" \
      --key "{\"session_id\": {\"S\": \"$ID\"}}" \
      --region "$REGION"
    COUNT=$((COUNT + 1))
  done
  echo "      Deleted $COUNT sessions."
fi

echo ""
echo "==> Cleanup complete. Infrastructure is still live. URL unchanged."
echo "    Verify: curl \$(cat .api_url)/sessions"
