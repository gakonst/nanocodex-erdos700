# Verification state

- Mathematical status: complete candidate proof.
- Independent derivations: two workers in run
  `math-1784829651-1913239` independently found the same three-prime/Maynard
  route.
- Primary-source check: Maynard, Proposition 4.2, Proposition 4.3, and the
  deduction on page 391 support the fixed-admissible-set quantifier and the
  `m + 1` conclusion. The proof uses `m = 2`.
- Targeted exact check: 818 eligible prime triples satisfying the lemma's
  hypotheses were tested through all three possible omitted-prime pairs and
  63,576 bounded `t` cases; no counterexample was found.
  Reproduce with
  `python3 campaigns/candidates/erdos-700-maynard/falsify_structural_lemma.py`;
  the expected byte-for-byte result is retained in `falsifier-output.json`.
- Independent boundary falsifier in the structural-audit campaign: 2,311
  eligible prime triples and 4,041,587 relevant pair-multiplier cases, with no
  counterexample. Its exact job is retained in
  `math-1784832829-1919953/exact-jobs/job-1.json` on `dev-georgios`.
- Independent structural audit: running in `math-1784832829-1919953`.
- Independent Maynard/source audit: running in `math-1784832830-1919956`.
- Formalization: not yet complete. A full Lean proof would require either a
  formalized Maynard theorem or a clearly separated imported theorem; no such
  assumption may be smuggled into the verifier.

This evidence does not yet justify the labels “accepted” or “formally
verified.”
