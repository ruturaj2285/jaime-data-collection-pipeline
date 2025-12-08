#!/bin/bash
set -e

WORKFLOW_PATH="$1"   # e.g., step-function-workflow/dev/data-pipeline
ENVIRONMENT="$2"     # dev | stg | prod

if [ -z "$WORKFLOW_PATH" ] || [ -z "$ENVIRONMENT" ]; then
  echo "Usage: deploy_step_function.sh <workflow-path> <env>"
  exit 1
fi

# Extract state machine folder name
WF_NAME=$(basename "$WORKFLOW_PATH")
STATE_MACHINE_NAME="${WF_NAME}-${ENVIRONMENT}"

STATE_FILE="${WORKFLOW_PATH}/state-machine.json"

if [ ! -f "$STATE_FILE" ]; then
  echo "❌ ERROR: No state-machine.json found at: $STATE_FILE"
  exit 1
fi

echo "──────────────────────────────────────────────"
echo " Deploying Step Function: $STATE_MACHINE_NAME"
echo " From: $STATE_FILE"
echo " Environment: $ENVIRONMENT"
echo "──────────────────────────────────────────────"

# Validate JSON (optional but recommended)
if ! jq empty "$STATE_FILE" 2>/dev/null; then
  echo "❌ ERROR: Invalid JSON in $STATE_FILE"
  exit 1
fi

# Deploy to AWS Step Functions
aws stepfunctions update-state-machine \
  --state-machine-name "$STATE_MACHINE_NAME" \
  --definition "file://${STATE_FILE}"

echo "✔ Step Function update successful → $STATE_MACHINE_NAME"
echo "──────────────────────────────────────────────"
