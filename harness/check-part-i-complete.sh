#!/usr/bin/env bash

set -euo pipefail

workspace=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
cd "$workspace"

theorem=explicitG_iff_factorTableauFeasible

rg -q "^theorem ${theorem}\\b" proof/PartIWork
rg -q "#check Erdos700PartI\\..*${theorem}\\b" proof/PartIVerify.lean
rg -q "#print axioms Erdos700PartI\\..*${theorem}\\b" proof/PartIVerify.lean
rg -q "${theorem}" proof/scripts/verify-part-i.sh

nix --extra-experimental-features "nix-command flakes" \
  develop ./proof --command bash -lc \
  "cd proof && lake build PartIWork && ERDOS700_PART_I_SKIP_BUILD=1 ./scripts/verify-part-i.sh"
