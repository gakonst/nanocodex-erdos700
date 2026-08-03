#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 i|iii" >&2
  exit 2
fi

part=$1
workspace=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
cd "$workspace"

binary=${NANOCODEX_LOOP_BINARY:-"$workspace/target/release/research-loop"}
campaign_binary=${NANOCODEX_CAMPAIGN_BINARY:-"$workspace/target/release/nanocodex-erdos"}
env_file=${NANOCODEX_ENV_FILE:-/home/ubuntu/github/gakonst/nanocodex/.env}
max_rounds=${NANOCODEX_LOOP_MAX_ROUNDS:-12}
max_campaigns=${NANOCODEX_LOOP_MAX_CAMPAIGNS:-48}
parallel_campaigns=${NANOCODEX_LOOP_PARALLEL_CAMPAIGNS:-4}
loop_timeout=${NANOCODEX_LOOP_TIMEOUT_SECONDS:-604800}

for required in "$binary" "$campaign_binary" "$env_file"; do
  if [[ ! -f "$required" ]]; then
    echo "required loop input is missing: $required" >&2
    exit 1
  fi
done

common=(
  --env-file "$env_file"
  --workspace "$workspace"
  --campaign-binary "$campaign_binary"
  --max-rounds "$max_rounds"
  --max-campaigns "$max_campaigns"
  --max-parallel-campaigns "$parallel_campaigns"
  --loop-timeout-seconds "$loop_timeout"
  --fast-mode
)

case "$part" in
  i)
    exec "$binary" "${common[@]}" \
      --objective campaigns/problems/erdos-700-i-global-projection-only.md \
      --objective campaigns/problems/erdos-700-i-refinement-tree-reset.md \
      --success-command "./harness/check-part-i-complete.sh"
    ;;
  iii)
    exec "$binary" "${common[@]}" \
      --objective campaigns/problems/erdos-700-iii.md \
      --objective campaigns/problems/erdos-700-iii-representation-reset.md \
      --verifier verifiers/lean-formal-conjecture.py
    ;;
  *)
    echo "unknown part: $part (expected i or iii)" >&2
    exit 2
    ;;
esac
