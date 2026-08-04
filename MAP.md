# Erdős 700 research map

This is the short route through what worked, what failed, and what remains.
For the complete route-by-route ledger, use
[`map/all-attempts.md`](map/all-attempts.md). For the exhaustive Part (iii)
tree, use [`map/part-3.md`](map/part-3.md).

## Part (i): exact finite criterion; direct classification open

```text
Kummer carry counts
  → exact complementary carry weight W_n(k)
  → divisibility-minimal boundary obstructions
  → one synchronized factor tableau
  → explicit selector / prefix / digit / borrow system G(F,B)
  → exact modern and literal-1978 iff theorems
  → shared-multiplier elimination still missing
```

The Lean development replaces enumeration of possible rows by one compact
symbolic system with a shared multiplier and proves soundness and completeness
in both directions. That closes exact finite feasibility, but not the stricter
request for a direct factor-readable classification: feasibility of the shared
multiplier remains. The focused follow-up reduces that gap to a short-CRT
digit-cylinder elimination problem and records counterexamples to the obvious
shortcuts. See [`map/part-1.md`](map/part-1.md).

## Part (ii): complete here, without a priority claim

```text
Lucas theorem for omitted prime divisors
  → three pair-omission lemmas for nearby p < q < r
  → every legal row retains at least two primes
  → exact witness k = r gives f(pqr) = pq
  → PNT short-interval packing supplies infinitely many triples
```

An early Maynard-style route was replaced by a direct prime-number-theorem
packing argument, reducing dependencies and closing the proof unconditionally.
See [`map/part-2.md`](map/part-2.md).

## Part (iii): open

```text
binomial gcd target
  → exact retained prime-power depth D_n(k)
  → one-row weighted carry target
  → easy/high-component regimes removed
  → comparable low-height packet remains
  → same-row moving-base synchronization bottleneck
```

The campaign produced many exact reductions, partial theorems, and rigorous
counterexamples to proposed methods, but no proof for any fixed $A>1$ and no
counterexample to the original conjecture. Do not combine successes from
different rows: the same integer $k$ must retain the required depth across
prime bases. Start with [`map/part-3-bottleneck.md`](map/part-3-bottleneck.md),
then use [`map/part-3.md`](map/part-3.md) as the no-retry ledger.

## Evidence layers

- Checked final code: [`lean-part1/`](lean-part1/README.md) and
  [`lean-part2/`](lean-part2/README.md).
- Reader-facing mathematics: the three PDFs at repository root.
- Complete attempt history: [`map/`](map/README.md).
- Campaign prompts, run audits, harness code, old layouts, and retained source
  material: [`archive/`](archive/README.md).
