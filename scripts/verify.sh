#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

export PATH="${HOME}/.elan/bin:${PATH}"

if rg --line-number --glob '*.lean' --glob '!.lake/**' \
  '\b(sorry|admit|axiom)\b' .; then
  echo "Proof placeholder or local axiom found in project sources." >&2
  exit 1
fi

lake update
lake exe cache get
lake build Erdos700PNT

audit_output="$(mktemp)"
trap 'rm -f "$audit_output"' EXIT
lake env lean Verify.lean 2>&1 | tee "$audit_output"

if rg --quiet 'sorryAx' "$audit_output"; then
  echo "The final theorem depends on sorryAx." >&2
  exit 1
fi

expected="'Erdos700PNT.erdos_700_ii' depends on axioms: \\[propext, Classical.choice, Quot.sound\\]"
if ! rg --quiet "$expected" "$audit_output"; then
  echo "The final theorem's dependency set did not match the audited set." >&2
  exit 1
fi

echo "Verification passed."
