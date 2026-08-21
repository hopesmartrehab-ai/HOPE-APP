#!/bin/bash
# audit.sh — read-only inventory of HOPE resources.
# Detects orphans (anything named `hope*` that isn't in the canonical set
# defined by deploy.sh) and reports cost for the last 7 days.
#
# Exit code: 0 if clean, 1 if orphans found.
#
# Usage:
#   ./backend/infra/audit.sh           # audit default region only (us-east-1)
#   ALL_REGIONS=1 ./backend/infra/audit.sh   # also scan other common regions

set -u

PRIMARY_REGION="${REGION:-us-east-1}"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null) || {
  echo "ERROR: AWS credentials not configured."
  exit 2
}
BUCKET="hope-data-${ACCOUNT_ID}"
TABLE="hope-sessions"
API_NAME="hope-api"
ROLE_NAME="hope-lambda-role"

# Canonical set (must match deploy.sh)
EXPECTED_LAMBDAS="hope_ingest hope_session_api"
EXPECTED_PATHS="/ /sessions /sessions/{session_id} /sessions/{session_id}/questionnaire /sessions/{session_id}/video-upload-url /sessions/{session_id}/device /ingest"

ORPHANS=0
HR="────────────────────────────────────────────────────────────"

echo "HOPE infra audit — account $ACCOUNT_ID, primary region $PRIMARY_REGION"
echo "$HR"

# ---------- 1. Lambdas in primary region ----------
echo "[1] Lambda functions in $PRIMARY_REGION"
LAMBDAS=$(aws lambda list-functions --region "$PRIMARY_REGION" \
  --query 'Functions[?contains(FunctionName,`hope`)].FunctionName' --output text 2>/dev/null | tr '\t' ' ')
for fn in $LAMBDAS; do
  if echo " $EXPECTED_LAMBDAS " | grep -q " $fn "; then
    echo "    OK    $fn"
  else
    echo "    ORPHAN $fn — delete: aws lambda delete-function --function-name $fn --region $PRIMARY_REGION"
    ORPHANS=$((ORPHANS+1))
  fi
done
for expected in $EXPECTED_LAMBDAS; do
  echo " $LAMBDAS " | grep -q " $expected " || {
    echo "    MISSING $expected — redeploy needed"
    ORPHANS=$((ORPHANS+1))
  }
done

# ---------- 2. API Gateway routes ----------
echo ""
echo "[2] API Gateway '$API_NAME' routes"
API_ID=$(aws apigateway get-rest-apis --region "$PRIMARY_REGION" \
  --query "items[?name=='${API_NAME}'].id" --output text 2>/dev/null)
if [ -z "$API_ID" ] || [ "$API_ID" = "None" ]; then
  echo "    MISSING  API '$API_NAME' does not exist"
  ORPHANS=$((ORPHANS+1))
else
  echo "    API ID: $API_ID"
  PATHS=$(aws apigateway get-resources --rest-api-id "$API_ID" --region "$PRIMARY_REGION" \
    --query 'items[].path' --output text 2>/dev/null)
  for p in $PATHS; do
    if echo " $EXPECTED_PATHS " | grep -q " $p "; then
      echo "    OK     $p"
    else
      echo "    ORPHAN $p — not in canonical set"
      ORPHANS=$((ORPHANS+1))
    fi
  done
fi

# ---------- 3. DynamoDB ----------
echo ""
echo "[3] DynamoDB tables"
TABLES=$(aws dynamodb list-tables --region "$PRIMARY_REGION" \
  --query 'TableNames[?contains(@,`hope`)]' --output text 2>/dev/null)
for t in $TABLES; do
  if [ "$t" = "$TABLE" ]; then
    COUNT=$(aws dynamodb scan --table-name "$t" --region "$PRIMARY_REGION" --select COUNT --query 'Count' --output text 2>/dev/null)
    echo "    OK    $t ($COUNT items)"
  else
    echo "    ORPHAN $t"
    ORPHANS=$((ORPHANS+1))
  fi
done

# ---------- 4. S3 ----------
echo ""
echo "[4] S3 buckets"
BUCKETS=$(aws s3api list-buckets --query 'Buckets[?contains(Name,`hope`)].Name' --output text 2>/dev/null)
for b in $BUCKETS; do
  LOC=$(aws s3api get-bucket-location --bucket "$b" --query 'LocationConstraint' --output text 2>/dev/null)
  [ "$LOC" = "None" ] && LOC="us-east-1"
  OBJS=$(aws s3 ls "s3://$b" --recursive --region "$LOC" --summarize 2>/dev/null \
    | awk '/Total Objects:/ {print $3}')
  { [ -z "$OBJS" ]; } && OBJS=0
  if [ "$b" = "$BUCKET" ]; then
    echo "    OK    $b (region=$LOC, $OBJS objects)"
    [ "$LOC" != "$PRIMARY_REGION" ] && echo "          NOTE: bucket not in primary region — see INFRA.md"
  else
    echo "    ORPHAN $b"
    ORPHANS=$((ORPHANS+1))
  fi
done

# ---------- 5. IAM role ----------
echo ""
echo "[5] IAM role"
ROLES=$(aws iam list-roles --query 'Roles[?contains(RoleName,`hope`)].RoleName' --output text 2>/dev/null)
for r in $ROLES; do
  if [ "$r" = "$ROLE_NAME" ]; then
    echo "    OK    $r"
  else
    echo "    ORPHAN $r"
    ORPHANS=$((ORPHANS+1))
  fi
done

# ---------- 6. CloudWatch log groups ----------
echo ""
echo "[6] CloudWatch log groups (/aws/lambda/hope*)"
LGS=$(aws logs describe-log-groups --region "$PRIMARY_REGION" \
  --log-group-name-prefix /aws/lambda/hope --query 'logGroups[].logGroupName' --output text 2>/dev/null)
for lg in $LGS; do
  FN=${lg##*/}
  if echo " $EXPECTED_LAMBDAS " | grep -q " $FN "; then
    echo "    OK    $lg"
  else
    echo "    ORPHAN $lg — delete: aws logs delete-log-group --log-group-name $lg --region $PRIMARY_REGION"
    ORPHANS=$((ORPHANS+1))
  fi
done

# ---------- 7. Other regions (opt-in) ----------
if [ "${ALL_REGIONS:-0}" = "1" ]; then
  echo ""
  echo "[7] Scanning other regions for stray HOPE resources"
  for r in us-east-2 us-west-1 us-west-2 eu-west-1 eu-central-1 ap-southeast-1 ap-northeast-1; do
    STRAY_FNS=$(aws lambda list-functions --region $r --query 'Functions[?contains(FunctionName,`hope`)].FunctionName' --output text 2>/dev/null)
    STRAY_APIS=$(aws apigateway get-rest-apis --region $r --query 'items[?contains(name,`hope`)].name' --output text 2>/dev/null)
    STRAY_TABLES=$(aws dynamodb list-tables --region $r --query 'TableNames[?contains(@,`hope`)]' --output text 2>/dev/null)
    if [ -n "$STRAY_FNS$STRAY_APIS$STRAY_TABLES" ]; then
      echo "    ORPHAN in $r:  lambdas=[$STRAY_FNS] apis=[$STRAY_APIS] tables=[$STRAY_TABLES]"
      ORPHANS=$((ORPHANS+1))
    fi
  done
else
  echo ""
  echo "[7] Other regions: skipped (set ALL_REGIONS=1 to scan)"
fi

# ---------- 8. Cost last 7 days ----------
echo ""
echo "[8] Cost last 7 days (USD, non-zero services)"
START=$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d '-7 days' +%Y-%m-%d)
END=$(date +%Y-%m-%d)
TOTAL=$(aws ce get-cost-and-usage \
  --time-period Start=$START,End=$END \
  --granularity MONTHLY \
  --metrics UnblendedCost \
  --query 'ResultsByTime[0].Total.UnblendedCost.Amount' \
  --output text 2>/dev/null)
aws ce get-cost-and-usage \
  --time-period Start=$START,End=$END \
  --granularity MONTHLY \
  --metrics UnblendedCost \
  --group-by Type=DIMENSION,Key=SERVICE \
  --output json 2>/dev/null \
  | python3 -c "import sys,json
d=json.load(sys.stdin)['ResultsByTime'][0]['Groups']
rows=[(g['Keys'][0], float(g['Metrics']['UnblendedCost']['Amount'])) for g in d]
rows=[r for r in rows if r[1]>0]
if not rows: print('    (all services \$0)')
for name,amt in sorted(rows,key=lambda r:-r[1]):
    print(f'    {name:<40} \${amt:.6f}')"
echo "    ------------------------------------------------"
printf "    %-40s \$%.6f\n" "TOTAL ($START → $END)" "$TOTAL"

# ---------- Summary ----------
echo ""
echo "$HR"
if [ "$ORPHANS" -eq 0 ]; then
  echo "RESULT: clean. No orphans."
  exit 0
else
  echo "RESULT: $ORPHANS orphan(s) found — see ORPHAN lines above."
  exit 1
fi
