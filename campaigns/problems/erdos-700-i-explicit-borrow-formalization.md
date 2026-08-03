# Erdős 700(i): explicit integer borrow-tableau formalization

Work only on Part (i). Starting from `proof/PartIWork/FactorTableau.lean`, formalize the explicit global selector/borrow system `G(n,B)` from the selected proposal.

Deliver a compiling Lean artifact with no `sorry`, `admit`, or local axioms. Define typed integer digits and Boolean borrow rows, prove the local borrow-row equivalence for subtraction in base `p`, and prove the finite support/variable-size bounds needed for the tableau. If the full global equivalence is too large, isolate the exact remaining theorem rather than weakening statements. Run `lake build PartIWork` and `scripts/verify-part-i.sh` in the Nix environment and retain all traces.

Be precise about integer typing, inclusive inequalities, prime-power selectors, and the fact that `B` is an integer. Do not claim the historical conjecture is solved unless the exact original quantifiers are discharged.
