#!/usr/bin/env bash
set -euo pipefail

workspace=${NANOCODEX_ERDOS_WORKSPACE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}
env_file=${NANOCODEX_ERDOS_ENV_FILE:-$workspace/../nanocodex/.env}
binary=${NANOCODEX_ERDOS_BINARY:-$workspace/target/release/nanocodex-erdos}
problem_file=$workspace/campaigns/ramsey-r3-10-problem.md
verifier=$workspace/verifiers/ramsey-r3-10.py

test -x "$binary"
test -r "$env_file"
test -r "$problem_file"
test -x "$verifier"
"$verifier" --self-test

problem=$(<"$problem_file")
exec "$binary" \
  --env-file "$env_file" \
  --workspace "$workspace" \
  --web-policy full-research \
  --max-worker-calls 64 \
  --max-retained-workers 16 \
  --max-concurrent-workers 8 \
  --worker-timeout-seconds 0 \
  --worker-closure-after-seconds 10800 \
  --max-batch-size 8 \
  --max-exact-jobs 256 \
  --max-concurrent-exact-jobs 16 \
  --max-exact-artifact-bytes 4294967296 \
  --max-exact-jobs-per-worker 12 \
  --verifier "$verifier" \
  --verifier-timeout-seconds 1800 \
  --closure-after-seconds 32400 \
  --max-lead-turns 8 \
  --campaign-timeout-seconds 43200 \
  "$problem"
