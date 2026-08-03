# Independent statement-alignment audit

## Modern immutable target

- **Domain:** `n : ℕ`, `1 < n`, and `¬ n.Prime` are exactly composite
  integers greater than one.
- **Index set:** the public minimum and formal predicate use
  $1<k\le n/2$ with natural floor division. The set is nonempty because the
  largest prime divisor $P(n)$ satisfies $1<P(n)\le n/2$ for composite $n$.
- **Endpoint:** all inequalities are inclusive. In particular,
  $(78,39,1)$ realizes at $k=n/2$.
- **Baseline:** `Erdos700.P n` is the largest prime divisor and the theorem's
  quotient is natural division. Since $P(n)\mid n$, it is exact division.
- **Boundary order:** $P(n)<d$ and $d/p\le P(n)$ are numerical inequalities,
  not componentwise exponent comparisons.
- **Realization:** one positive $m$ must work for every prime $p\mid d$;
  the budget is
  $\kappa_p(n,dm)\le v_p(n)-v_p(d)$ under the explicit hypothesis $d\mid n$.
  No signed subtraction or swapped quantifier is used.
- **Independence:** `Boundary`, `Realized`, and `BoundarySafe` contain no
  occurrence of $f$, gcd, binomial coefficients, or
  `Erdos700.erdos_700.parts.i`.

The exact Lean type printed by the verifier matches these quantifiers and
hypotheses. The prose proof separately closes positivity, divisibility
orientation, finite-minimum nonemptiness, and natural-subtraction issues.

## Public and Formal Conjectures definitions

The modern public wording and pinned Formal Conjectures source use largest
prime factor. The formal `sInf` presentation denotes the same finite minimum:
the admissible set is nonempty as above, every member is a natural number,
and a finite nonempty set's `sInf` is its minimum. The theorem does not add a
factorization-class restriction or replace equality by a density/asymptotic
claim.

## Historical mismatch

The 1978 paper instead defines $P(n)$ as the greatest prime-power divisor.
The separator $n=12$ proves this is not a terminological variation. Therefore
the frozen candidate is aligned with the immutable **modern** target but not
with the literal 1978 baseline. This mismatch is explicitly preserved in the
verdict rather than silently weakening or relabeling the theorem.
