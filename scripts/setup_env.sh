#!/bin/bash
# Generate iOS DartDefines.xcconfig from env JSON file.
# Usage: ./scripts/setup_env.sh env/dev.json

set -euo pipefail

ENV_FILE="${1:?Usage: $0 <env-json-file>}"

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: $ENV_FILE not found" >&2
  exit 1
fi

OUTPUT="ios/Flutter/DartDefines.xcconfig"

echo "// Auto-generated from $ENV_FILE — do not edit" > "$OUTPUT"

# Extract each key-value from JSON and write as xcconfig entries
python3 -c "
import json, sys
with open('$ENV_FILE') as f:
    data = json.load(f)
for k, v in data.items():
    print(f'{k}={v}')
" >> "$OUTPUT"

echo "Generated $OUTPUT from $ENV_FILE"
