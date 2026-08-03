# Part (ii): complete-proof route

## Endpoint

The repository contains a complete unconditional proof that infinitely many
composite $n$ satisfy $f(n)^2>n$. The reader-facing proof is
[`../part-ii-infinite-family.pdf`](../part-ii-infinite-family.pdf), and the
independent formal project is [`../lean-part2/`](../lean-part2/README.md).
No novelty or priority claim is made.

## Winning chain

1. Choose nearby primes $p<q<r$ with controlled asymmetric gaps.
2. Lucas's theorem translates failure of a prime to divide
   ${pqr\choose k}$ into rigid base-prime digit inequalities.
3. Three structural lemmas rule out simultaneously omitting each pair among
   $p,q,r$ for every legal row $2\le k\le pqr/2$.
4. Therefore every legal gcd retains at least two primes and is at least $pq$.
5. At $k=r$, Lucas gives the matching value, so $f(pqr)=pq$.
6. Since $pq>r$, one has $pq>\sqrt{pqr}$.
7. Prime-number-theorem counts in short boxes, combined with an asymmetric-gap
   packing lemma, produce arbitrarily large valid triples.

## Route changes and lessons

- The first construction considered a Maynard-style nearby-prime input.
- A direct PNT packing argument was enough and gave a cleaner unconditional
  dependency chain.
- Marginal statements about one omitted prime were insufficient; the proof
  needed all three pair-omission cases.
- The explicit row $k=r$ is essential for equality, not merely the lower bound.

## Deeper evidence

- [Final theorem](../lean-part2/Solution.lean)
- [Public theorem and axiom surface](../lean-part2/Verify.lean)
- [Complete mathematical proof](../lean-part2/docs/proof.md)
- [Statement-alignment audit](../lean-part2/docs/statement-audit.md)
- [Recovered candidate history](../archive/campaigns/candidates/)
