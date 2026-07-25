#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: run-inference-campaign.sh PROBLEM_FILE" >&2
  exit 2
fi

problem_file=$1
workspace=$(pwd -P)
binary="$workspace/target/release/nanocodex-erdos"
verifier="$workspace/verifiers/lean-formal-conjecture.py"
env_file=${NANOCODEX_ENV_FILE:-/home/ubuntu/github/gakonst/nanocodex/.env}
web_policy=${NANOCODEX_WEB_POLICY:-full-research}
fast_mode=${NANOCODEX_FAST_MODE:-false}
max_worker_calls=${NANOCODEX_MAX_WORKER_CALLS:-36}
max_retained_workers=${NANOCODEX_MAX_RETAINED_WORKERS:-12}
max_concurrent_workers=${NANOCODEX_MAX_CONCURRENT_WORKERS:-6}
max_batch_size=${NANOCODEX_MAX_BATCH_SIZE:-8}
max_exact_jobs=${NANOCODEX_MAX_EXACT_JOBS:-6}
max_concurrent_exact_jobs=${NANOCODEX_MAX_CONCURRENT_EXACT_JOBS:-2}
max_exact_artifact_bytes=${NANOCODEX_MAX_EXACT_ARTIFACT_BYTES:-1073741824}
max_exact_jobs_per_worker=${NANOCODEX_MAX_EXACT_JOBS_PER_WORKER:-1}
worker_closure_after_seconds=${NANOCODEX_WORKER_CLOSURE_AFTER_SECONDS:-3600}
verifier_timeout_seconds=${NANOCODEX_VERIFIER_TIMEOUT_SECONDS:-1200}
closure_after_seconds=${NANOCODEX_CLOSURE_AFTER_SECONDS:-10800}
max_lead_turns=${NANOCODEX_MAX_LEAD_TURNS:-6}
campaign_timeout_seconds=${NANOCODEX_CAMPAIGN_TIMEOUT_SECONDS:-43200}

for required in "$problem_file" "$binary" "$verifier" "$env_file"; do
  if [[ ! -f "$required" ]]; then
    echo "required campaign input is missing: $required" >&2
    exit 1
  fi
done

problem=$(<"$problem_file")

args=(
  --env-file "$env_file" \
  --workspace "$workspace" \
  --prompt-cache-key nanocodex-erdos-inference-first-v1 \
  --web-policy "$web_policy" \
  --max-worker-calls "$max_worker_calls" \
  --max-retained-workers "$max_retained_workers" \
  --max-concurrent-workers "$max_concurrent_workers" \
  --worker-timeout-seconds 0 \
  --worker-closure-after-seconds "$worker_closure_after_seconds" \
  --max-batch-size "$max_batch_size" \
  --max-exact-jobs "$max_exact_jobs" \
  --max-concurrent-exact-jobs "$max_concurrent_exact_jobs" \
  --max-exact-artifact-bytes "$max_exact_artifact_bytes" \
  --max-exact-jobs-per-worker "$max_exact_jobs_per_worker" \
  --verifier "$verifier" \
  --verifier-timeout-seconds "$verifier_timeout_seconds" \
  --closure-after-seconds "$closure_after_seconds" \
  --max-lead-turns "$max_lead_turns" \
  --campaign-timeout-seconds "$campaign_timeout_seconds" \
)

if [[ "$fast_mode" == "true" ]]; then
  args+=(--fast-mode)
fi

exec "$binary" "${args[@]}" "$problem"
