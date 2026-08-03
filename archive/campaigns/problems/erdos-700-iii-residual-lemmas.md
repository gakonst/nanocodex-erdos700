# Erdős 700(iii): residual-lemma concentration wave

## Allocation objective

Spend essentially all inference compute on the two exact residual obligations
below. This is a concentration wave after a 182-report portfolio audit, not a
request for another broad representation survey.

Launch exactly four first-wave child campaigns in one host-owned batch:

1. `HL6-proof`: prove the weakest high-load six-system implication.
2. `HL6-falsifier`: attack that exact implication with realizable arithmetic.
3. `CI-proof`: prove the same-index full/partial-layer lemma.
4. `CI-falsifier-repair`: attack that exact lemma and derive the weakest
   target-sufficient replacement if it fails.

After the first wave, synthesize one implication graph and spend every
follow-up on matched proof/falsification attacks against the single weakest
surviving quantified statement. Do not reopen a route merely because its
representation sounds different.

## Immutable target and now-audited bridge

For composite `n`, define

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n)   = max_{2 <= k <= floor(n/2)} D_n(k).
```

The target is

```text
for every A>0 there is c_A>0 such that
D(n) >= c_A (log n)^A
```

for every composite `n`.

The primary-source audit in
`math-1784942909-3786142/worker-reports/agent-10-primary-source-theorem-auditor.md`
confirms that the Erdős--Pomerance--Schmutz lower bound for `lambda(n)` has
the uniform eventual all-integer quantifier needed here. Consequently

```text
H_lambda: lambda(n) <= D(n)^3
```

implies the immutable target, including finite absorption. This implication
is no longer waiting on a literature-quantifier caveat. `H_lambda` itself is
still unproved for four or more exact prime-power components.

## Audited exact identities

For `q=p^a || n`, `n=q*m`, and
`j=floor((k-1)/q)`:

```text
v_p(binomial(n-1,k-1)) = v_p(binomial(m-1,j)),

v_p(D_n(k))
  = (v_p(k)-v_p(binomial(m-1,j)))_+
  = (a-carries_p(k,n-k))_+.
```

For multiprime `n`, `D(n) >= q` for every exact component `q`.
Therefore `D(n) >> log n` unconditionally. Any failure at exponent `A>1`
must have arbitrarily many balanced exact components; for each fixed `r`, the
`r` largest components are `>> log n`.

Never infer a common row from primewise maxima, marginals, lcm data, separate
witnesses, or independent-base models.

## Residual obligation HL6

Let

```text
n = q_1 q_2 q_3 q_4,
q_i = p_i^a_i,
q_1 <= q_2 <= q_3 <= q_4 = P.
```

For an edge `i<j`, put `M_ij=n/(q_i q_j)`. The edge captures both exact
components precisely when there is one common integer

```text
1 <= t <= floor(M_ij/2)
```

such that

```text
q_j*t <=_{p_i} q_j*M_ij,
q_i*t <=_{p_j} q_i*M_ij,
```

where `<=_p` is base-`p` digitwise domination.

The weakest missing implication is:

```text
HL6:
if all six edge systems are endpoint-only, then lambda(n) <= P^3.
```

Equivalently, `lambda(n)>P^3` forces at least one captured edge. Do not replace
HL6 by a stronger private-atom or per-edge statement unless the stronger
statement is independently proved.

Facts that must be used or explicitly escaped:

- Under `lambda(n)>P^3`, each corrected private load

  ```text
  rho_i = lambda(n) /
          lcm_{h != i}(lambda(q_h))
  ```

  is greater than one, the `rho_i` are pairwise coprime, and
  `product rho_i > P^2`.
- Private atoms need not occur in the prescribed cross-orders and can cancel
  in product orders. A local atom-to-depth bridge is false.
- Minimal prefix certificates for six empty systems give the strict product
  lower bound `product_i p_i^E_i > n^3`.
- Purely vertex-local upper caps are false at `(23,29,47,59)`.
- The orientation reduction leaves star and triangle templates. A surviving
  route must prove that an over-depth wedge forces the opposite edge to
  succeed, or eliminate the remaining sparse templates using the actual
  canonical predecessor witnesses.
- `n=770` has all six pair intersections endpoint-only but does not satisfy
  high load. Thus high load, not generic four-component incidence, must do
  the work.

`HL6-proof` must prove HL6 through a genuinely global relation among all six
systems. `HL6-falsifier` must seek either one exact high-load quartet with all
six systems empty or a symbolic unbounded family. A finite exact quartet
refutes HL6, but it refutes `H_lambda` only after the all-layer value `D(n)` is
audited; distinguish these conclusions.

## Residual obligation CI

For general multiprime `n`, write

```text
W = log lambda(n),
q_i = p_i^a_i,
d_i(k) = v_{p_i}(D_n(k)).
```

The exact common-index target sufficient for `H_lambda` is

```text
CI:
if W > 3 log(max_i q_i), then there is one admissible k with
sum_i d_i(k) log p_i >= W/3.
```

Equivalently, prove `D_n(k)^3 >= lambda(n)` for one actual row. Partial layers
are essential: full-support WS3 is strictly stronger than `H_lambda`.

`CI-proof` must work with the same integer `k` throughout and should exploit
block compression, layer cake, reflection, or a genuinely joint carry
operator only after proving its observable is exactly
`sum_i d_i(k) log p_i`.

`CI-falsifier-repair` must attack CI itself or the smallest stated sufficient
lemma, not a cosmetic strengthening. If CI is false, determine whether
`H_lambda` is false or whether another exponent/row statement still yields
the immutable arbitrary-polylog target. Any counterfamily must give an
all-index Kummer/Lucas certificate, including every partial valuation.

## Killed routes

Do not spend new worker calls on the following unless a new lemma explicitly
escapes the retained falsifier:

- fractional cover/DFC, abstract set cover, VC/Helly, or marginal density;
- random-permutation transfer from matched one-prime profiles;
- adelic volume/Blichfeldt for nonconvex digit unions;
- denominator-only Smith/exterior invariants;
- whole-row AM--GM or fixed exponential-moment inequalities;
- standard Davenport/Olson/Kneser without preservation of the common `t`;
- separate-base spectral products or fixed finite-state transducers;
- lossless quotient descent or deletion monotonicity;
- standard fixed-data S-unit/Subspace theorems with moving bases;
- fixed multipliers, `t=1`, rational stencils, or sequential Dirichlet
  prefix freezing;
- primitive-divisor constructions whose order atoms alone supply the claimed
  Carmichael growth;
- finite census without a named universal lemma and a predeclared kill rule.

## Required recovery

Read compact artifacts only. Never inspect `events.jsonl`, session snapshots,
credentials, or telemetry. Recover at least:

- `math-1784940116-3770585`;
- `math-1784941744-3780886`;
- `math-1784941744-3780887`;
- `math-1784942909-3786142`;
- `math-1784942909-3786146`;
- `math-1784942909-3786148`;
- `math-1784942909-3786149`;
- `math-1784942909-3786150`;
- directly cited compact reports from those campaigns.

Treat every report as a claim requiring recheck. Prefer theorem construction
and adversarial proof repair over computation. Each child may run at most two
small exact jobs, only to decide a named lemma with a checkpoint and kill
rule.

## Completion discipline

Each child must return:

1. an exact quantified statement;
2. its proved implication to `H_lambda`, the immutable target, or a genuine
   counterexample;
3. a self-attack using all relevant hostile examples;
4. either a complete proof, a realizable counterexample, or the first failed
   inference and the strictly weaker remaining lemma.

Do not emit `candidate.json` for an auxiliary result. Lean begins only after
the complete mathematics for the original target or a fully sufficient
bridge is ready. No `sorry`, `admit`, new axioms, model consensus, or finite
experiment counts as completion.
