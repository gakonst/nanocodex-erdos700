# Historical-statement and characterization report

## Primary and maintained wording

The retained primary source is P. Erdős and G. Szekeres, *Some number
theoretic problems on binomial coefficients*, **Australian Mathematical
Society Gazette** 5 (1978), 97--99.  It asks for the composite `n` with
`f(n)=n/P(n)` while defining `P(n)` to be the greatest **prime power** that
divides `n`.  The retained PDF SHA-256 is
`da8bfddd328fa01605cba4c751a7bf9fe07c4fa31bd6cf519fd32c5707ed302b`.

The maintained Problem 700 page and pinned Formal Conjectures declaration use
the largest **prime divisor** instead.  At `n=12`,

\[
 (\gcd(12,\tbinom{12}{k}))_{k=2}^{6}=(6,4,3,12,12),
\]

so `f(12)=3`; the historical baseline is `Q(12)=4`, while the modern one is
`P(12)=3`.  The formulations are not extensionally equal.

## Exact mathematical results

1. **Modern frozen statement.**  `solution.lean` proves the displayed
   `BoundarySafe` iff with exactly the quantifiers and definitions in
   `problem.md`.
2. **Prime-power threshold strengthening.**  For every proper prime-power
   divisor `q=p^b` of `n`, the same argument proves
   `f(n)=n/q ↔ BoundarySafeAt n q`.
3. **Literal 1978 statement.**  With
   `Q(n)=max_{p|n} p^(v_p(n))`, the standalone historical theorem proves, for
   every composite `n>1`,

   ```text
   f(n)=n/Q(n) ↔ ¬ IsPrimePow n ∧ BoundarySafeAt n (Q n).
   ```

   The conjunct is necessary: if `n=p^a` is composite then `Q(n)=n`, while
   `f(n)=p>1=n/Q(n)`.  If `n` is not a prime power, `Q(n)` is a proper
   prime-power divisor and the strengthened theorem applies.

The right-hand predicates are independent of `f`, gcds, binomial
coefficients, and the upstream open Part-(i) declaration.  They are finite
digit/divisor conditions; `Realized` quantifies over the bounded interval
`1≤m≤n/(2d)` and imposes simultaneous base-prime carry inequalities.

## Does this count as “characterize”?

Mathematically, yes in the exact decision-theoretic sense: the iff is
unconditional, independent of the original minimum, handles arbitrary
factorizations and repeated prime powers, and supplies a finite test.  The
prime-power threshold theorem and explicit `Q(n)=n` exception remove the
earlier historical-statement ambiguity.

A stronger closed form eliminating the bounded multiplier search would be
desirable, but it is not required for extensional characterization and no
uniform factorization-only thinning was proved.  `structural-upgrade.md`
gives an exact Shadow--CRT normal form rather than pretending such a thinning
exists.

The subsequent compiled `FullShadowSafe` theorem makes that normal form a
public finite digit/factorization predicate.  An adversary proved that its
common period is larger than the entire admissible multiplier interval for
boundary divisors, so it improves explicitness but not the search bound.  This
closes the formal alternative-characterization route while preserving the
qualification above.

## Separate release and novelty judgments

The exact terms compile with the audited standard axiom set.  That fact does
not by itself establish novelty, journal acceptance, or the host verifier
gate.  The maintained page's `OPEN` label is not treated as novelty evidence,
and the required policy-separated novelty audit has not yet occurred.

Therefore the mathematical content supports an exact modern and historical
characterization, while a **publication-release claim remains withheld**
until the host gate and independent novelty review are available.
