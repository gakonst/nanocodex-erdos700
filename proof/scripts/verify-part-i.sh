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
  factorTableauFeasible_iff_exists_boundary_realized
  boundarySafeAt_iff_factorTableauSafe
)

# Lean may wrap a long axiom list across several output lines.  Normalize
# whitespace before checking the audited dependency set.
normalized_audit_output="$(tr '\n' ' ' < "$audit_output" | tr -s ' ')"

for theorem in "${promoted_theorems[@]}"; do
  expected="'Erdos700PartI.${theorem}' depends on axioms: [propext, Classical.choice, Quot.sound]"
  if ! grep -Fq "$expected" <<<"$normalized_audit_output"; then
    echo "The Part (i) theorem ${theorem} did not have the audited dependency set." >&2
    exit 1
  fi
done

explicit_tableau_theorems=(
  borrowRow_iff_outgoing
  borrowRow_iff_resultDigit
  card_var_exact
  card_var_le
)

for theorem in "${explicit_tableau_theorems[@]}"; do
  expected="'Erdos700PartI.ExplicitTableau.${theorem}' depends on axioms: [propext, Classical.choice, Quot.sound]"
  if ! grep -Fq "$expected" <<<"$normalized_audit_output"; then
    echo "The explicit Part (i) theorem ${theorem} did not have the audited dependency set." >&2
    exit 1
  fi
done

explicit_g_theorems=(
  G_to_factorTableauFeasible
  factorTableauFeasible_to_G
  explicitG_iff_factorTableauFeasible
)

for theorem in "${explicit_g_theorems[@]}"; do
  expected="'Erdos700PartI.ExplicitG.${theorem}' depends on axioms: [propext, Classical.choice, Quot.sound]"
  if ! grep -Fq "$expected" <<<"$normalized_audit_output"; then
    echo "The explicit Part (i) theorem ${theorem} did not have the audited dependency set." >&2
    exit 1
  fi
done

python3 scripts/audit-part-i.py

echo "Part (i) verification passed."
