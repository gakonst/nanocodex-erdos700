#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

export PATH="${HOME}/.elan/bin:${PATH}"

placeholder_pattern='(^|[^[:alnum:]_])(sorry|admit|axiom)([^[:alnum:]_]|$)'
placeholder_output="$(
  find PartIWork PartIWork.lean PartIVerify.lean -type f -name '*.lean' \
    -exec grep -nHE "$placeholder_pattern" {} + || true
)"
if [[ -n "$placeholder_output" ]]; then
  printf '%s\n' "$placeholder_output"
  echo "Part (i) contains a proof placeholder or local axiom." >&2
  exit 1
fi

if [[ "${ERDOS700_PART_I_SKIP_BUILD:-0}" != "1" ]]; then
  lake update
  lake exe cache get
  lake build PartIWork
fi

audit_output="$(mktemp)"
trap 'rm -f "$audit_output"' EXIT
lake env lean PartIVerify.lean 2>&1 | tee "$audit_output"

if grep -q 'sorryAx' "$audit_output"; then
  echo "A promoted Part (i) theorem depends on sorryAx." >&2
  exit 1
fi

promoted_theorems=(
  residueCarryWeight_dvd_of_admissible
  minimalOverweightDivisor_iff_boundary
  lt_residueCarryWeight_iff_exists_boundary
  dvd_residueCarryWeight_iff_carryInequalities
  realized_iff_exists_dvd_residueCarryWeight
  residueCarrySafe_iff_boundarySafe
  f_eq_div_iff_boundarySafe
)

for theorem in "${promoted_theorems[@]}"; do
  expected="'Erdos700PartI.${theorem}' depends on axioms: [propext, Classical.choice, Quot.sound]"
  if ! grep -Fq "$expected" "$audit_output"; then
    echo "The Part (i) theorem ${theorem} did not have the audited dependency set." >&2
    exit 1
  fi
done

python3 scripts/audit-part-i.py

echo "Part (i) verification passed."
