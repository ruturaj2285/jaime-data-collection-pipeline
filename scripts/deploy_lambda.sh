#!/bin/bash
set -e

LAMBDA_DIR="$1"
ENVIRONMENT="$2"

if [ -z "$LAMBDA_DIR" ] || [ -z "$ENVIRONMENT" ]; then
  echo "Usage: deploy_lambda.sh <lambda-folder> <env>"
  exit 1
fi

# Extract function name
FUNC_NAME=$(basename "$LAMBDA_DIR")
LAMBDA_NAME="${FUNC_NAME}-${ENVIRONMENT}"

echo "──────────────────────────────────────────────"
echo " Deploying Lambda: $LAMBDA_NAME"
echo " Folder: $LAMBDA_DIR"
echo " Environment: $ENVIRONMENT"
echo "──────────────────────────────────────────────"

ZIP_FILE="${FUNC_NAME}.zip"

echo "📦 Packaging code..."
cd "$LAMBDA_DIR"
zip -r "../$ZIP_FILE" . >/dev/null
cd - >/dev/null

echo "⬆️ Updating Lambda code in AWS..."
aws lambda update-function-code \
  --function-name "$LAMBDA_NAME" \
  --zip-file "fileb://${ZIP_FILE}" >/dev/null

echo "🧹 Cleaning up..."
rm "$ZIP_FILE"

echo "✔ Lambda deployment successful → $LAMBDA_NAME"
echo "──────────────────────────────────────────────"
