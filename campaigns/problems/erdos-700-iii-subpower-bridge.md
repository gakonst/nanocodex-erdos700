# Erdős 700(iii): subpower Carmichael bridge

## Purpose

Run this campaign alongside the fixed-cube `H_lambda` campaign. The fixed
exponent

```text
lambda(n) <= D(n)^3
```

may be much stronger than Part (iii) needs. Seek a slowly growing exponent,
or an equivalent bounded collection of actual rows, while preserving enough
growth to imply every fixed power of `log n`.

This is not permission to state an unspecified `lambda(n)^{o(1)}` bound. Every
rate and quantifier must be explicit.

## Immutable target

For composite `n`, define

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n)   = max_{2 <= k <= floor(n/2)} D_n(k).
```

Prove or disprove:

```text
forall A>0, exists c_A>0, forall composite n:
D(n) >= c_A (log n)^A.
```

All logarithms are natural.

## Audited external input

The primary-source audit in
`math-1784942909-3786142/worker-reports/agent-10-primary-source-theorem-auditor.md`
confirms that for every fixed

```text
0 < c < 1/log 2
```

there is `N_c` such that

```text
lambda(n) > (log n)^(c log log log n)
```

for every integer `n >= N_c`.

This is source input. The deductions below must be rechecked independently.

## Concrete sufficient bridge

For sufficiently large `n`, set

```text
L3(n) = log log log n,
g(n)  = L3(n) / log L3(n).
```

The primary weakened target is:

```text
SP:
there are absolute C>0 and N_0 such that every composite n>=N_0 satisfies
lambda(n) <= D(n)^(C g(n)).
```

Indeed, SP and the EPS lower bound imply

```text
log D(n)
  >= log lambda(n) / (C g(n))
  >  (c/C) log L3(n) log log n,
```

and therefore

```text
D(n) > (log n)^((c/C) log L3(n)).
```

The exponent tends to infinity. For each fixed `A`, choose a threshold where
`(c/C) log L3(n) >= A`, then absorb the finitely many smaller composites into
`c_A>0` using `D(n)>=1`.

More generally, a proved bound

```text
lambda(n) <= D(n)^h(n)
```

is sufficient whenever `h(n)=o(L3(n))`, with all uniformity made explicit.
Conversely, a claim such as `D(n)>=lambda(n)^o(1)` is not sufficient unless
the decay rate is quantified so that the product with `L3(n)` tends to
infinity.

## Exact multi-row formulation

Recover and recheck the exact lcm identity for multiprime `n`:

```text
lambda(n)
  = lcm_{2 <= k <= floor(n/2)} lambda(D_n(k)).
```

If actual admissible rows `k_1,...,k_r` satisfy

```text
lambda(n) | product_{j=1}^r lambda(D_n(k_j)),
```

then, because `lambda(m)<=m`,

```text
lambda(n)
  <= product_j D_n(k_j)
  <= D(n)^r.
```

Thus SP follows from the explicit row-compression statement:

```text
MR:
the maximal prime-power atoms of lambda(n) can be covered by
r <= C L3(n)/log L3(n)
actual admissible rows.
```

Atom coverage must mean divisibility by the corresponding
`lambda(D_n(k_j))`, not merely that one exact component is fully present.
Full-component Lucas support is sufficient for its owned atoms, but partial
prime-power layers may provide additional coverage.

MR is a sufficient route, not an assumed equivalence. A direct proof of SP
without MR is allowed.

## Required four-route first wave

Launch exactly four independent child campaigns in one host-owned batch:

### 1. Multi-row arithmetic compression

Prove MR using actual Lucas/Kummer row structure. Start from the exact lcm
identity and maximal-atom ownership. Seek an arithmetic greedy, grouping, or
hierarchical construction that covers many remaining atoms per row and uses
at most `O(L3/log L3)` rows. Abstract set cover, fractional cover, marginal
density, or selecting a different index for each layer without a compression
argument is not progress.

### 2. Weak common-index load

Instead of the fixed fraction `1/3`, prove one actual admissible row satisfies

```text
log D_n(k)
  >= (log L3(n)/(C L3(n))) log lambda(n).
```

Work directly with

```text
v_p(D_n(k)) = (a-carries_p(k,n-k))_+
```

and the same integer `k`. Use partial layers, block compression, reflection,
or a joint carry statistic only after proving exact statement alignment.

### 3. Recursive batching with controlled losses

Attempt a multiscale theorem that partitions the maximal Carmichael atoms
into at most `O(L3/log L3)` arithmetic batches, each batch witnessed by one
real row. Losses may grow slowly with `n`, unlike the failed three-row and
lossless descent claims. Every reuse or branching charge must be counted.
Do not use deletion monotonicity: `D(90)<D(45)`.

### 4. Falsifier and threshold optimizer

Attack SP and MR directly. Seek a realizable unbounded family for which

```text
log lambda(n) / log D(n)
```

is comparable to `L3(n)` or larger, with an all-index Kummer/Lucas
certificate. If no family survives, determine the weakest explicit exponent
`h(n)=o(L3(n))` supported by a proved structural theorem. A finite example
may falsify a universal intermediate lemma but cannot disprove the
asymptotic target.

## Audited starting facts

Recheck before use:

- `D(n) >> log n` unconditionally.
- `H_lambda` holds for at most three exact prime-power components.
- Any failure at exponent `A>1` has arbitrarily many balanced exact
  components; every fixed number of largest components is `>> log n`.
- For `q=p^a || n`, `n=q*m`, and
  `j=floor((k-1)/q)`:

  ```text
  v_p(binomial(n-1,k-1)) = v_p(binomial(m-1,j)),
  v_p(D_n(k)) = (v_p(k)-v_p(binomial(m-1,j)))_+.
  ```

- Full-support WS3 is stronger than the desired result because partial
  layers may suffice.
- The fixed-cube four-component HL6 campaign is running separately. Its
  failures are evidence about local proof mechanisms, not evidence against
  a slowly growing multi-row exponent.

## Killed routes and required escape

Do not repeat:

- fractional cover/DFC or abstract hypergraph cover;
- multiplication of marginal or separate-index witnesses;
- generic random-permutation transfer;
- adelic volume for nonconvex digit regions;
- denominator-only Smith/exterior invariants;
- whole-row AM--GM or fixed low exponential moments;
- fixed multipliers, `t=1`, rational stencils, or finite-state transducers;
- lossless quotient descent, exponent lowering, or deletion monotonicity;
- standard zero-sum/S-unit theorems that do not preserve the same integer;
- a finite census presented as asymptotic evidence.

A new multi-row theorem escapes the killed three-row/fractional-cover routes
only if it proves the stated arithmetic `O(L3/log L3)` bound with actual row
indices and exact atom divisibility.

## Recovery

Read compact artifacts only; never inspect `events.jsonl`, session snapshots,
credentials, or telemetry. Recover:

- `math-1784940116-3770584`;
- `math-1784941744-3780886`;
- `math-1784942909-3786142`;
- `math-1784942909-3786146`;
- `math-1784942909-3786148`;
- `math-1784942909-3786149`;
- `math-1784942909-3786150`;
- the focused residual runs under `math-1784947385-*` when compact reports
  become available.

## Adaptive synthesis

After the four first-wave reports:

1. Audit the SP implication and all rate comparisons independently.
2. Compare routes by the smallest proved exponent `h(n)`, not by prose.
3. Select one weakest surviving arithmetic lemma.
4. Launch matched proof/falsification follow-ups against exactly that lemma.
5. If a complete SP proof appears, hand it immediately to independent
   statement and source auditors, then formalize the complete implication to
   Part (iii).

No `candidate.json` or Lean formalization for an auxiliary conjecture. No
`sorry`, `admit`, new axioms, model consensus, or finite computation counts
as completion.
