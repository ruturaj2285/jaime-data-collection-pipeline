#!/bin/bash
set -e

LAMBDA_DIR=$1      # e.g., functions/report-job
ENVIRONMENT=$2     # dev | stg | prod

if [ -z "$LAMBDA_DIR" ] || [ -z "$ENVIRONMENT" ]; then
  echo "Usage: deploy_lambda.sh <lambda-folder> <env>"
  exit 1
fi

# Extract function name from folder
FUNC_NAME=$(basename "$LAMBDA_DIR")
LAMBDA_NAME="${FUNC_NAME}-${ENVIRONMENT}"

echo "──────────────────────────────────────────────"
echo " Deploying Lambda: $LAMBDA_NAME"
echo " Folder: $LAMBDA_DIR"
echo " Environment: $ENVIRONMENT"
echo "──────────────────────────────────────────────"

# Build ZIP package
ZIP_FILE="${FUNC_NAME}.zip"

echo "Packaging code..."
cd "$LAMBDA_DIR"
zip -r "../$ZIP_FILE" . >/dev/null
cd - >/dev/null

# Update Lambda function code
echo "Updating Lambda code..."
aws lambda update-function-code \
  --function-name "$LAMBDA_NAME" \
  --zip-file "fileb://${ZIP_FILE}" >/dev/null

echo "Code upload complete!"

# OPTIONAL: Update Lambda configuration
# echo "Updating Lambda configuration..."
# aws lambda update-function-configuration \
#   --function-name "$LAMBDA_NAME" \
#   --environment "Variables={ENVIRONMENT=${ENVIRONMENT}}"

# Cleanup
rm "$ZIP_FILE"

echo "✔ Lambda deployment successful → $LAMBDA_NAME"
echo "──────────────────────────────────────────────"
