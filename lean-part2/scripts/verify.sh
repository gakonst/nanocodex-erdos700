#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

export PATH="${HOME}/.elan/bin:${PATH}"

placeholder_pattern='(^|[^[:alnum:]_])(sorry|admit|axiom)([^[:alnum:]_]|$)'
placeholder_output="$(
  find . -path './.lake' -prune -o -type f -name '*.lean' \
    -exec grep -nHE "$placeholder_pattern" {} + || true
)"
if [[ -n "$placeholder_output" ]]; then
  printf '%s\n' "$placeholder_output"
  echo "Proof placeholder or local axiom found in project sources." >&2
  exit 1
fi

if [[ "${ERDOS700_SKIP_BUILD:-0}" != "1" ]]; then
  lake update
  lake exe cache get
  lake build Erdos700PNT
fi

audit_output="$(mktemp)"
trap 'rm -f "$audit_output"' EXIT
lake env lean Verify.lean 2>&1 | tee "$audit_output"

if grep -q 'sorryAx' "$audit_output"; then
  echo "The final theorem depends on sorryAx." >&2
  exit 1
fi

expected="'Erdos700PNT.erdos_700_ii' depends on axioms: [propext, Classical.choice, Quot.sound]"
if ! grep -Fq "$expected" "$audit_output"; then
  echo "The final theorem's dependency set did not match the audited set." >&2
  exit 1
fi

echo "Verification passed."
