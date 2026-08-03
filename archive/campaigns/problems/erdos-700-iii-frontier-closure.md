# Erdős 700(iii): frontier-closing proof/counterexample campaign

## Research posture

You are a closing research mathematician, not a brainstorming assistant.
Substantial partial work already exists. Do not rederive elementary
reductions, rename the conjecture, or return another list of possible
approaches.

Obtain one of:

1. a complete unconditional proof of Erdős 700(iii);
2. a complete unconditional counterexample family with an all-index bound;
3. one genuinely weaker, independently falsifiable theorem that you prove
   fully and that closes the problem when combined with the audited facts
   below.

If a proposed bridge is false, find its exact failure quickly, record the
counterexample, change representation, and continue. Do not stop at the first
failed approach.

## Immutable target

For composite `n > 1`, define

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n)   = max_{2 <= k <= n/2} D_n(k).
```

Prove or disprove:

```text
for every real A > 0 there exists c_A > 0 such that
D(n) >= c_A (log n)^A
```

for every composite `n`. Preserve the quantifier order and exact prime-power
components.

Equivalently, close the dense-escape statement:

> For every `epsilon > 0` there exists `C_epsilon` such that, whenever
> `x >= 2`, `n` is composite, `n | lcm(1,...,x)`, and
> `log n > C_epsilon x^epsilon`, there exists
> `2 <= k <= n/2` with `D_n(k) > x`.

A result for infinitely many `n`, almost all `n`, squarefree `n` only, or a
selected family does not suffice.

## Mandatory recovery

Use `inspect_research_artifacts`; never read any `events.jsonl`. Recover and
hash-inventory at least these artifacts from
`math-1784909933-3467057`:

- `first-wave-synthesis.md`
- `implication-graph.md`
- `ledger.md`
- all ten reports in `worker-reports/`
- `implication-audit.md`
- `recovery-inventory.md`

Recover directly relevant predecessor artifacts only when the synthesis points
to them. Treat every candidate, rather than proved/audited result, as open
until independently checked.

## Audited starting facts

### Exact components

If `q=p^a || n` and `n` has another prime divisor, then `q` is an admissible
index and `D_n(q)=q`. Consequently every exact component is at most `D(n)` and

```text
n | lcm(1,...,D(n)).
```

Prime powers are already handled.

### Repeated-component regime

For

```text
N_h(n) = product over v_p(n) >= h of p^(v_p(n)),
```

the recovered, independently audited bound is

```text
D(n) >= (log N_h(n) / (13h))^h.
```

Thus the unresolved regime reduces to dense, mostly squarefree `n` with many
small exact components. Do not reprove powerful-number or bounded-`omega`
cases.

### Exact unitary-grid score

For a proper unitary packet

```text
Q = product_i q_i,       q_i=p_i^(a_i) || n,
R = n/Q,                 E_i=Q/q_i,
```

and `1 <= t < R`,

```text
v_{p_i}(D_n(Qt))
  = [a_i - v_{p_i}(binomial(E_i R,E_i t))]_+.
```

Define

```text
V_Q(t)
  = sum_i [a_i-v_{p_i}(binomial(E_i R,E_i t))]_+ log p_i.
```

If `V_Q(t)>log x`, symmetry supplies an admissible `Qt<=n/2` with
`D_n(Qt)>x`. The problem is to produce one common `t`; large marginal counts
at different indices do not suffice.

### Disjoint boundary extraction

Let `B_x(n)` be the divisibility-minimal divisors `d|n` with `d>x`. Every
`d in B_x(n)` satisfies `d<=x^2`.

If `M` is an inclusion-maximal pairwise-coprime subfamily and `Q_M` is the
product of exact components whose primes occur in `M`, then

```text
n/Q_M <= x
```

and

```text
|M| >=
  (log n/log x - 1) /
  floor(2 log x/log 2).
```

Thus density supplies polynomially many pairwise-coprime boundary members
whose component weight covers all but `log x` of `log n`.

Coverage alone is insufficient: for `(n,x)=(2310,15)`, a pairwise-coprime
boundary family covers every component while no boundary divisor divides any
`D_n(k)`. A positive proof must exploit the asymptotically large collective
family, not coverage or pairwise compatibility.

### Fractional cover

For `A_{k,p,h}=1` when `p^h|D_n(k)`, the exact fractional layer-cover number
`tau(n)` satisfies

```text
log n <= tau(n) log D(n),
tau(n) <= omega(n).
```

A subpower estimate for `tau(n)` or `omega(n)` is equivalent in strength to
dense escape. Renaming the target as such an estimate is not progress. Any
useful dual certificate must be explicitly constructed from additional
arithmetic structure.

### Conditional counterexample gate

For unbounded `X`, seek constants `lambda,sigma,c>0` and data

```text
H >= c X^sigma/log X,
sqrt(X) < p_1,...,p_H <= X,
Q = product_i p_i,
A_i = Q/p_i,
L >= lambda H,
1 <= R <= X,
```

such that, with `alpha_i in {1,2}` and only `O(1)` labels equal to `2`,

```text
A_i R = alpha_i (mod p_i^L)        for every i.       (BG)
```

If BG exists, `n=QR` yields, by the retained exact Lucas/CRT transfer,

```text
D_n(k) <= X^B
```

for every `2<=k<=n/2`, with `B` depending only on `lambda` and the number of
`2` labels. The lower bound on `H` then gives a genuine counterexample to
dense escape after replacing `x` by `X^B`.

The least representative is exactly

```text
R_0 = Q^L * fractional_part(
        sum_i alpha_i w_i / p_i^L
      ),
```

where

```text
w_i A_i^(L+1) = 1 (mod p_i^L).
```

Hence BG is an extreme small-fractional-part problem with structured
coefficients. It is impossible when all `p_i` lie in a fixed extremely narrow
top band near `X`; a construction must use real multiplicative spread.
Existence or impossibility in a broad band remains open.

## Representations already killed

Do not use these without a new theorem explicitly surviving the retained
obstruction:

- fixed endpoints, midpoint, or a predetermined finite rational stencil;
- polynomial rational-affine packets of fixed selected dimension;
- multiplier one or divisor-only witnesses;
- multiplying witnesses obtained at different indices;
- deriving joint intersection from marginal density;
- unsigned covariance or bounded-density sequential bias;
- mean rational-cut energy (`n=420` is an exact obstruction);
- bounded-loss transport, monotone repair, or no-reset recursion;
- fixed-depth Lucas equidistribution or a changing-modulus large sieve based
  only on such marginals;
- container volume without the least positive representative;
- an initial polynomial multiplier interval for a fixed packet;
- a counterexample construction without an all-`k` certificate.

Finite computation may falsify one named lemma. It cannot prove the asymptotic
target.

## Required ten-worker batch

Launch exactly ten clean workers concurrently in one host-owned batch. Give
each worker this shared frontier plus only its role card and the exact artifact
paths it needs.

### Positive collective route: four workers

1. **Boundary-to-full-depth closer.** Derive a full-depth common-index theorem
   from the polynomially large pairwise-coprime boundary family. Work with
   actual residue positions, least representatives, or exponential moments,
   never just marginals or container volume.

2. **Failure-to-structure extractor.** Assume every `D_n(k)<=x`. Prove that
   this forces either a BG-type proportional-depth configuration or
   `log n=O_epsilon(x^epsilon)`. The extracted statement must be strictly more
   structural than the dense-escape conclusion and proved from the exact
   Lucas/Kummer constraints.

3. **Full-depth moment/compression prover.** Prove an all-index compression or
   high-moment theorem for the exact scores `V_Q(t)`, choosing `Q`
   data-dependently from the disjoint boundary family. It must survive the
   binary-shadow, long-reset, affine-packet, and `n=420` obstructions.

4. **Arithmetic dual-certificate builder.** Construct an explicit feasible
   fractional cover or dual certificate from boundary/full-depth arithmetic
   that gives a subpower bound without merely assuming one. Audit the result
   against `tau(30)=3`.

### BG construction route: three workers

5. **Broad-band BG constructor.** Construct BG with a genuinely spread prime
   packet and prove the extreme small-fractional-part estimate.

6. **Structured-fractional-part specialist.** Analyze the exact inverses
   `w_i` and seek algebraic, recurrence, determinant-cancellation, or
   geometry-of-numbers structure yielding `R<=X`. Any construction must
   satisfy every congruence simultaneously at proportional depth.

7. **BG all-index counterexample closer.** Independently seek BG and, if
   successful, reprove the complete all-`k` transfer including cofactor prime
   powers, half-range, constants, and quantifiers. Do not rely on the retained
   transfer without auditing it.

### BG impossibility route: two workers

8. **Global determinant obstruction.** Extend the retained Hankel/spread
   determinant argument from a narrow top band to arbitrary
   `sqrt(X)<p_i<=X`, or isolate and prove the weakest spread condition that
   excludes every polynomial-size packet.

9. **Diophantine impossibility specialist.** Prove the quantified negation of
   BG using heights, product formula, Vandermonde/Hankel determinants,
   subspace-theorem machinery, or an elementary product inequality. State
   every imported theorem precisely. Explain whether the result feeds a
   positive proof or only kills the negative route.

### Independent closer: one worker

10. **Blind global closer and quantifier referee.** Ignore the favored
    representations except for the audited exact identities. Seek a shorter
    complete proof or genuine counterexample. Independently audit any claimed
    closure from the other roles against the original quantifier order.

Each first-wave report must give a proved theorem, a realizable unbounded
counterfamily with an all-index certificate, or the first exact false
implication with proof-quality evidence.

## Mandatory research loop

For every route:

1. State one explicit quantified lemma.
2. Show line by line why it would close the target or yield a genuine
   counterexample.
3. Attempt to falsify it before investing in a proof, using
   `30,35,42,60,72,132,210,252,420,858,1001,2310`, interval-primorial/lcm
   families, `n=q(q+1)`, the binary-shadow construction, finite-depth CRT
   programming, and the long-reset/rational-affine constructions.
4. If it survives, prove it with every dependence and constant explicit.
5. If it fails, identify the first false implication, strengthen hypotheses
   only with structure forced by the common integer `n`, and continue.
6. Audit a completed argument backwards from the original quantifiers.
7. Only after a complete candidate exists, perform novelty search and begin
   Lean formalization.

Exact jobs are allowed only to test a named claim or verify a completed
candidate. Model inference is the primary compute.

## Adaptive synthesis

After the first ten reports:

1. Build one implication graph with proved, falsified, and open nodes.
2. Collapse renamed equivalents.
3. Pair the strongest positive result against a fresh falsifier.
4. Pair the strongest BG construction against both impossibility workers.
5. Use at least six retained follow-ups on the smallest surviving quantified
   gaps, split evenly between proof and adversarial audit.
6. If a representation fails, pivot materially; do not enlarge a killed
   finite packet or numerical census.

## Deliverables and completion gate

Every report must contain:

1. `STATUS`: `PROVED`, `DISPROVED`, or `PARTIAL`.
2. `MAIN THEOREM`: exact quantified statement.
3. `PROOF`: self-contained derivation.
4. `TARGET TRANSFER`: line-by-line implication to Erdős 700(iii), or the
   all-index counterexample transfer.
5. `ADVERSARIAL AUDIT`: strongest attempted falsification.
6. `DEPENDENCIES`: every external theorem used.
7. `FORMALIZATION PLAN`: exact Lean lemmas required.
8. If partial: the single first unproved implication, without a speculative
   roadmap.

A complete candidate additionally requires `candidate.json`,
`research-note.md`, `source-audit.md`, and `solution.lean` proving the exact
Formal Conjectures proposition with no `sorry`, `admit`, local axioms, unsafe
bypasses, or import of the result. Compile it, audit axioms, freeze it, and
pass the host verifier.

We have enough partial results. Push through to a complete unconditional proof
or counterexample.
