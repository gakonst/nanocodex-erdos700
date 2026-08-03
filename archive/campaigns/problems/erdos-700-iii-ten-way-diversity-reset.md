# Erdős 700(iii): ten-way representation diversity reset

## Immutable target

For composite `n`, define

```text
D_n(k)=n/gcd(n,binomial(n,k)),
D(n)=max_{2<=k<=n/2}D_n(k).
```

Prove or disprove:

```text
for every A>0 there is c_A>0 such that
D(n)>=c_A*(log n)^A
```

for every composite `n`.

The Carmichael bridge

```text
H_lambda: lambda(n)<=D(n)^3
```

is a sufficient route, not an assumption and not known equivalent.

## Why this reset exists

The current portfolio has generated real progress but has become concentrated
on one mixed-base Lucas-support tree. This campaign must launch exactly ten
independent child campaigns in one host-owned batch, one for each route below.
Do not merge routes into one generic campaign and do not launch cosmetic
variants.

Inference is the primary compute. Each child may use at most one small exact
job to falsify one named lemma or verify one compact certificate. Generic
census, large local simulation, and benchmark-style CPU work are forbidden.

## Mandatory recovery

Use compact artifacts only; never inspect `events.jsonl`, snapshots,
credentials, or telemetry. Recover:

- `math-1784940116-3770583`;
- `math-1784940116-3770584`;
- `math-1784940116-3770585`;
- `math-1784941744-3780886`;
- `math-1784941744-3780887`;
- `math-1784941744-3780888`;
- directly referenced predecessor reports and dead-end maps.

Important new facts to recheck before use:

1. Exact component block compression:

   ```text
   q=p^a || n, n=q*m, j=floor((k-1)/q)
   v_p(binomial(n-1,k-1))=v_p(binomial(m-1,j)).
   ```

2. The exact all-layer form:

   ```text
   v_p(D_n(k))=(a-carries_p(k,n-k))_+.
   ```

3. A sequential finite-prefix/Dirichlet counterexample construction is
   impossible: multiplying its prefix exclusion inequalities forces its
   accumulated modulus to exceed the final component.

4. Fixed-state one-dimensional mixed-base transducers cannot synchronize the
   arbitrary common integer `k`.

5. Literal size surrogates are false:

   ```text
   D(n)^3>=n                     false at n=7293;
   D_n(k)<=largest prime factor  false at n=1155;
   D_n(k)<=largest exact q_i     false at n=45.
   ```

6. For multiprime `n`, weighted full support is exactly

   ```text
   WS3 <=> lambda(n)<=M(n)^3,
   M(n)=max_k product_{q_i|D_n(k)}q_i.
   ```

   WS3 is stronger than `H_lambda` because partial layers may prove
   `H_lambda` even when WS3 fails.

7. The exact finite-adelic CRT row parametrization from
   `math-1784940116-3770584/worker-reports/agent-3-digit-crt-specialist.md`
   constructs every row supporting a prescribed proper carrier set, but the
   unresolved issue is forcing a load-heavy target into its admissible
   window.

8. In PC4, pair systems are reciprocal and pair emptiness is equivalent to
   the simultaneous solution set containing only the two endpoints.

## Killed representations

Do not use any of these without a theorem that explicitly survives its exact
falsifier:

- marginal-to-common-index inference;
- fixed rational stencils or fixed multipliers;
- multiplying witnesses from different rows;
- direct `t=1` pair capture;
- deletion monotonicity;
- abstract set cover, generic VC/Helly/container, or fractional-cover
  renaming;
- mean rational-cut energy;
- bounded-loss/no-reset transport;
- AQG or scaled-index quotient growth;
- cubic primorial support bounds;
- broad BG packets already killed by determinant obstructions;
- fixed finite-state mixed-base synchronization;
- sequential Dirichlet prefix freezing;
- a finite example or unproved prime constellation presented as an
  asymptotic family.

## Required ten child campaigns

### 1. Full-row exponential-moment campaign

Work with the complete normalized binomial row and the exact quantities
`D_n(k)`. Seek an identity or inequality giving a lower bound for

```text
sum_k D_n(k)^theta
```

or an equivalent exponential moment that forces one common coefficient to
carry large prime-power mass. Primewise LCD or separate marginal moments are
insufficient. Derive moments from exact row products, factorial valuations,
or multiplicative characters and test the first proposed inequality at
`7293`, `183744`, and `493955`.

### 2. Adelic geometry-of-numbers campaign

Encode one common integer `k` in the real interval and simultaneous
`p`-adic digit/carry regions. Seek an adelic Minkowski, Blichfeldt,
transference, or product-formula theorem whose body is verified by the exact
Lucas/Kummer constraints. It must handle nonconvex digit downsets or replace
them by a proved inner approximation. State the exact volume/covolume
inequality and immediately attack it on the endpoint-only pair examples.

### 3. Smith-normal-form and exterior-algebra campaign

Use the integral Pascal row, normalized coefficient denominators, minors,
Fitting ideals, Smith forms, exterior powers, resultants, or determinantal
divisors to retain same-coordinate coherence that scalar LCD loses. Prove an
exact implication from the proposed invariant to a lower bound on one
`D_n(k)`. Generic determinant concentration is false; give the first
falsifier before pursuing a theorem.

### 4. Additive zero-sum campaign

Use the exact submultiset/zero-sum formulation of digit downsets from
`agent-2-least-representative-order-specialist.md`. Apply Davenport constants,
Olson/Kneser theory, weighted zero sums, or inverse additive combinatorics to
the *common equality* required by two or more bases. One-sided nonminimality
does not imply a common multiplier. Seek a theorem over a product group or a
coupled atom sequence that genuinely synchronizes the equal integer `t`.

### 5. Spectral carry-operator campaign

Represent the full all-layer carry score as a transfer operator, cocycle, or
tensor-network observable over the integer interval. A fixed one-dimensional
transducer is impossible, so use scale-dependent operators, a common
archimedean position, or a spectral trace over all `k`. Prove a lower bound on
the maximum total retained weight from a trace, norm, pressure, or large
deviation estimate. Avoid assuming independence of bases.

### 6. Block-compression quotient-descent campaign

Exploit the new exact identity

```text
v_p binomial(n-1,k-1)
 = v_p binomial(n/q-1,floor((k-1)/q)).
```

Build a descent on quotient blocks of the *index space*, not the false
monotonicity `D(n/q)<=D(n)`. Seek a multiscale tree in which each component
projects the common `k` to a quotient coordinate and prove that one root-to-
leaf path accumulates arbitrary logarithmic saving. State a precise descent
invariant and attack it at `D(90)<D(45)`.

### 7. Partial-layer amplification campaign

Discard full-support-only WS3 and work directly with

```text
v_p(D_n(k))=(a-c_p(n,k))_+.
```

Prove that failure to capture several full components forces sufficiently
many partial layers to survive at one row. Use carry-depth energy, layer cake,
or a weighted max-min theorem tied to the exact block compression. The
family where pair-free top support still leaves `2^(a-1)` must be treated as
positive evidence, not an exception.

### 8. Random arithmetic ensemble campaign

Analyze a mathematically realizable random model of prime or prime-power
components. Determine whether typical instances overwhelmingly satisfy a
strong common-row bound or instead suggest a counterfamily. Any transfer to
integers must use proved prime-distribution input and give deterministic
quantifiers; an independence heuristic is not a result. Use the random model
to isolate an explicit deterministic inverse theorem for exceptional `n`.

### 9. S-unit and Diophantine-rigidity campaign

Translate persistent all-index avoidance or all-six PC4 emptiness into
`S`-unit equations, height inequalities, Subspace-Theorem hypotheses,
linear forms in logarithms, or multiplicative-order constraints. State every
imported theorem precisely, including effectivity and dependence on the
varying bases. The goal is a quantitative impossibility theorem, not a vague
appeal to Diophantine approximation.

### 10. Analogue-and-transfer campaign

Solve a carefully chosen analogue—function-field binomial coefficients,
carry-free polynomial digits, or an exact randomized-base model—where the
common-index obstruction is still present. Identify the decisive mechanism
and prove an explicit transfer lemma back to integers, or rigorously show why
the analogue cannot transfer. An analogue solution alone is not progress on
the immutable target.

## Per-child requirements

Every child must:

1. name the exact dead end its representation escapes;
2. state one independently falsifiable quantified lemma;
3. prove the implication from that lemma to `H_lambda`, dense escape, or a
   genuine counterexample;
4. attack the lemma immediately with exact hostile examples;
5. return a proof, an unbounded counterfamily with an all-index certificate,
   or the first exact failed implication;
6. preserve a compact route map and source audit.

## Synthesis and completion

After the ten reports, compare them by the number and strength of remaining
lemmas, not prose confidence. Promote only routes that change the implication
graph. Use matched proof/falsification follow-ups on the same surviving
statement.

A complete result requires the original Part (iii) quantifiers, independent
audits, and a no-hole Lean formalization accepted by the host verifier. No
model consensus, auxiliary theorem, finite experiment, `candidate.json`, or
Lean proof of a weakened proposition counts as success.
