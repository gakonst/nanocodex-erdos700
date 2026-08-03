# Part (i): complete-solution route

## Endpoint

Part (i) is complete for both source formulations. The reader-facing proof is
[`../part-i-complete-solution.pdf`](../part-i-complete-solution.pdf), and the
independent formal project is [`../lean-part1/`](../lean-part1/README.md).

## Winning chain

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
- BoundarySafe was an exact proof bridge, but the later synchronized compiler
  supplied the full structural breakthrough.
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
