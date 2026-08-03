# Adversarial audit: canonical bounded obstructions

## Result

**Accepted as an exact extensionally equal characterization.**  The proof was
also checked by Lean 4.27.0 with exactly
`[propext, Classical.choice, Quot.sound]`.

## Line-item checks

- **Quantifiers:** one common `m` is retained for all primes dividing `d`;
  negating the rejecting-prime existential correctly produces all carry-budget
  inequalities for that same pair `(d,m)`.
- **Endpoint:** both definitions use the inclusive inequality `d*m<=n/2`.
  The cases `n=78,d=39,m=1` and `n=8,d=4,m=1` are therefore not lost.
- **Nontrivial multiplier:** no `m=1` reduction is made; `n=136,d=34,m=2`
  remains in the bounded domain.
- **Repeated prime powers:** the divisor compression selects any prime factor
  and uses exact `d=(d/p)*p`; it makes no squarefree assumption.
- **Divisibility orientation:** from `p|d` and `d|n`, the proof uses `p|n`.
- **Numerical versus componentwise order:** the new bound is numerical
  `d<=P^2`; valuation comparisons remain componentwise over all prime factors.
- **Natural subtraction:** the budget is unchanged as
  `v_p(n)-v_p(d)` in `Nat`.  The contradiction uses only the total order
  equivalence between not being strictly below and being at least; no integer
  subtraction is substituted.
- **Positivity:** `n>1` makes `P>0`; `P<d` makes `d>0`; consequently
  `m<=d*m`.  Membership in `Icc 1 (n/2)` supplies `m>0` in the reverse
  direction.
- **Omitted-divisor mutation:** deleting `d|n` would invalidate both the
  largest-prime comparison `p<=P(n)` and the intended boundary predicate.  It
  is explicitly retained.
- **Independence:** the body of `BoundedObstructionSafe` contains no original
  minimum, gcd, binomial coefficient, prior boundary/realization predicate, or
  open upstream theorem.  The exact source audit records zero forbidden hits.
- **Finite character:** both coordinates range over explicit finite intervals:
  `P+1..P^2` and `1..n/2`; divisibility and the product bound further prune
  them.  This is a genuine divisor-coordinate compression, not a claim that
  the multiplier interval has been shortened.

No counterexample or missing hypothesis was found.
