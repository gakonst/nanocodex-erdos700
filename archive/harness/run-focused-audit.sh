#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: run-focused-audit.sh PROBLEM_FILE" >&2
  exit 2
fi

problem_file=$1
workspace=$(pwd -P)
binary="$workspace/target/release/nanocodex-erdos"
env_file=${NANOCODEX_ENV_FILE:-/home/ubuntu/github/gakonst/nanocodex/.env}

for required in "$problem_file" "$binary" "$env_file"; do
  if [[ ! -f "$required" ]]; then
    echo "required audit input is missing: $required" >&2
    exit 1
  fi
done

problem=$(<"$problem_file")

exec "$binary" \
  --env-file "$env_file" \
  --workspace "$workspace" \
  --prompt-cache-key nanocodex-erdos-700-focused-audit-v1 \
  --web-policy full-research \
  --max-worker-calls 30 \
  --max-retained-workers 10 \
  --max-concurrent-workers 6 \
  --worker-timeout-seconds 0 \
  --worker-closure-after-seconds 3600 \
  --max-batch-size 8 \
  --max-exact-jobs 6 \
  --max-concurrent-exact-jobs 2 \
  --max-exact-artifact-bytes 536870912 \
  --max-exact-jobs-per-worker 1 \
  --closure-after-seconds 10800 \
  --max-lead-turns 6 \
  --campaign-timeout-seconds 43200 \
  "$problem"
