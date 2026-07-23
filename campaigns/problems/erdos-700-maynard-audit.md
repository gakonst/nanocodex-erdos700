# Erdős 700(ii): Maynard application and novelty audit

This is a focused source and theorem-application audit. The complete candidate
is retained at:

`runs/math-1784829651-1913239/worker-reports/agent-3-unconditional-number-theorist.md`

The candidate proposes choosing a fixed admissible tuple

`H = { W*2^i : 0 <= i < K }`,

where `K = K(3)` comes from Maynard's small-gaps theorem and
`W` is the product of primes at most `K`. Infinitely many translates allegedly
contain three primes `p < q < r`; the exponential offsets ensure
`r-q > q-p`, while fixed offsets and unbounded translates eventually ensure
`p > 4(r-p)^3`.

## Required work

1. Locate and retain the primary Maynard paper and exact theorem statement.
   Verify the quantifiers needed here: a single fixed admissible `K`-tuple,
   infinitely many translates, and at least three primes among its entries.
2. Prove carefully that the proposed `H` is admissible for every prime,
   including primes at most `K`, primes dividing `W`, and primes larger than
   `K`. Check duplicate residues and the role of the offset starting at `i=0`.
3. Prove that any three prime entries selected from one translate satisfy
   `r-q > q-p`. Check nonconsecutive selected indices.
4. Prove the obtained triples and products are genuinely infinite and
   unbounded, rather than finitely many prime triples repeated across
   translates.
5. Verify that the fixed-gap construction eventually satisfies every size
   hypothesis of the structural lemma.
6. Search broadly for prior literature applying Maynard/Maynard–Tao prime
   clusters to Erdős Problem 700, this binomial-gcd function, or the same
   three-prime lemma. Distinguish “not found” from “novel”.
7. Launch independent workers for theorem quantifiers, admissibility,
   gap algebra, and novelty/source search. No model consensus counts as a
   source.

## Output contract

Write inside the assigned run directory:

- `maynard-audit.md`: exact theorem mapping and verdict;
- `sources.md`: primary citations, stable URLs, and quoted theorem identifiers;
- `novelty-audit.md`: searches performed and closest prior work;
- `repaired-analytic-step.md`: publication-grade argument if valid;
- `report.md`: final status and exact remaining gap.

This campaign must not audit the Lucas/base-digit structural lemma except to
state its required hypotheses. Do not claim a solution unless both independent
halves have subsequently been integrated and checked.
