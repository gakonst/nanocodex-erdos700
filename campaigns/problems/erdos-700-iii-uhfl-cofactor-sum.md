# Erdős 700(iii): UHFL via the adaptive cofactor-sum row

Work only on the direct upper-half first-layer lemma UHFL(A) frozen in
`runs/erdos700-iii-upper-half-first-layer-frontier-20260725/report.md`,
Sections 7--8. Recover the exact statement, implication ledger, and strongest
next prompt. Never inspect `events.jsonl`, session snapshots, credentials, or
telemetry.

The main underused input is Sections 29--33 of
`runs/math-1784972255-4031899/numbered-obstruction.md` and the matching report.
On the interval-prime-square stress family they construct the legal adaptive
row

    Sigma = sum_{q in P_X} Q/q,
    k_Sigma = Q Sigma,

with gcd(k_Sigma,N)=Q and exactly one p-adic unit of budget at every interval
prime. Its all-layer Lucas predicate is explicit. The previous campaign asked
this one row to support logarithmic mass on the much stronger X/L3 scale.
UHFL(A) asks only for the fixed number m=ceil(A) of first layers.

Prove or disprove the weakest exact theorem sufficient for UHFL:

1. first on balanced squares and comparable fixed-height blocks;
2. then for a dyadic block inside the upper-half residual set U;
3. finally with the exact right-closed block formula for general exponents.

Do not continue the full-depth p^2-support/MR question. A first layer
p|D_n(k) is the target. Do not use b=1 component-product or co-divisor rows:
the Maynard/geometric-shift family in `math-1784994375-4111087` kills those.

Launch workers on:
- exact first-layer predicate for k_Sigma and for higher cofactor-moment rows;
- a capacity theorem for variable first-failed phases, not one fixed phase;
- a finite family of global moment multipliers and a covering/pigeonhole
  theorem forcing m surviving primes on one literal row;
- adaptation from interval primes to a comparable block in U;
- hostile reconstruction on 7293, 183744, 493955, the 83407 quartet, the
  Maynard family, and balanced squares;
- an unconditional all-k counterfamily if the assertion is false.

Inference is primary. At most two tiny exact jobs may falsify named identities;
do not run a broad census. Return a complete UHFL proof, an unconditional
unbounded all-k counterfamily satisfying its antecedent, or the single
narrower phase-capacity lemma with a proved implication. No candidate.json or
Lean unless the original Part (iii) chain is complete.
