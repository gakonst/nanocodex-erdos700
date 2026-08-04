# Part (i): exact proof route and open direct-classification gap

## Endpoint

Part (i) has kernel-checked exact feasibility theorems for both source
formulations. The reader-facing proof is
[`../part-i-complete-solution.pdf`](../part-i-complete-solution.pdf), and the
independent formal project is [`../lean-part1/`](../lean-part1/README.md).
These results decide equality through an explicit finite system; they do not
yet give a reviewer-grade direct classification readable from the ordered
prime-power factors without solving that system.  The latter remains open at
the short-CRT elimination obligation stated below.

## Exact feasibility chain

1. Kummer converts $p$-adic valuations of binomial coefficients into base-$p$
   carry counts.
2. The complementary carry weight $W_n(k)$ satisfies an exact product identity
   with the row gcd and always divides $k$.
3. Any overweight row contains a divisibility-minimal divisor above the chosen
   baseline. This produces the boundary antichain.
4. Realizability of one boundary divisor is expressed by one shared multiplier
   satisfying all active prime-base carry budgets.
5. A factor tableau stores the divisor exponents and shared multiplier without
   scanning the original binomial rows.
6. The final compiler replaces the semantic tableau by explicit one-hot
   selectors, prefix products, base digits, Boolean borrows, and budget rows.
7. Lean proves both compiler directions, yielding the compact system
   $G(F,B)$ and the final equality iff its infeasibility.

## Routes that mattered but were not the endpoint

- Direct row enumeration exposed examples but did not characterize equality.
- Independent per-prime witnesses failed because all carry constraints must
  hold at the same row.
- BoundarySafe was an exact proof bridge, and the later synchronized compiler
  supplied a kernel-checked exact feasibility encoding.  Neither eliminates
  the shared multiplier to give the stricter direct classification.
- Full-shadow, bounded-obstruction, cofactor, and divisor-poset forms remain
  useful equivalent views, not separate gaps.

## Important distinctions

- The maintained problem uses the largest prime divisor $P(n)$.
- The 1978 paper uses the greatest exact prime-power component $Q(n)$.
- These differ already at $n=12$; the formal development proves both.
- The compact representation-size bound is not a polynomial-time feasibility
  claim.

## Deeper evidence

- [Public theorem and axiom surface](../lean-part1/PartIVerify.lean)
- [Human proof bridge](../lean-part1/PartIWork/boundary-antichain.md)
- [Complete release record](../archive/docs/part-i-release/README.md)
- [Every recovered Part (i) run](../archive/docs/part-i-run-coverage-audit.md)

## Recovered zero-sum route and stricter classification gap

The August 3 shared-session result has now been normalized and independently
checked.  It gives a correct token-refinement/quotient-spectrum reformulation,
closed classifications for the families $4q,6q,8q,9q$, and an infinite-prime
theorem for every fixed cofactor.  The general spectrum intersection still
quantifies over the same shared multiplier as `Realized`, so it does not by
itself answer the stricter request for a direct all-factorization taxonomy.
The focused follow-up isolated the remaining task as a factor-coupled
short-CRT digit-cylinder elimination theorem and retained counterexamples to
independent-prime, greedy, pairwise/Helly, and divisor-descent shortcuts.  It
did not close that theorem.  Concretely, the missing result is an explicit
well-founded evaluator, using only the ordered factorization and its digits
and performing no search over multipliers, CRT tuples, automaton states, or
solver assignments, proved equal to the least accepted CRT representative.

See the
[zero-sum classification audit](../archive/docs/part-i-direct-classification/research-report.md)
and its
[reproducible checker](../archive/docs/part-i-direct-classification/experiments/verify_shared_claims.py).
