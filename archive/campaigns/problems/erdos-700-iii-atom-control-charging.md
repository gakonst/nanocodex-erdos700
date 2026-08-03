# Erdős 700(iii): atom-control charging bridge

## Exact objective

For composite `n`, define

```text
D_n(k)=n/gcd(n,binomial(n,k)),
D(n)=max_{2<=k<=n/2}D_n(k).
```

Prove the sufficient Carmichael bridge

```text
H_lambda: lambda(n) <= D(n)^3.
```

Do not relaunch AQG, cubic primorial support, abstract fractional cover, LC3,
generic DFC, or a finite census.

## Mandatory recovery

Recover compact artifacts from:

- `math-1784940116-3770583`, especially
  `worker-reports/agent-3-dirichlet-construction-designer.md`;
- `math-1784940116-3770584`;
- `math-1784940116-3770585`;
- the directly referenced predecessor reports.

Never inspect `events.jsonl`, snapshots, credentials, or telemetry.

The new no-go theorem says that a sequential construction cannot keep
supports of size at most `s` by freezing finitely many old-base prefixes and
then choosing a final prime `p_r=1 mod M` with `p_r>M`. Multiplying the prefix
exclusion inequalities forces `M>p_r`.

## New representation

Write `n=product q_i`, `q_i=p_i^a_i`. Split maximal prime-power atoms of
`lambda(n)` into:

1. **vertical atoms**, the powers of `p_i` contributed by
   `lambda(p_i^a_i)`;
2. **horizontal atoms**, prime powers dividing `p_i-1`.

Build a directed weighted control graph. An edge `i -> j` records that a
power `p_i^L` used to control or exclude base-`p_i` support divides
`lambda(q_j)`, typically because `p_j=1 mod p_i^L`. The lcm counts a shared
atom only once, while `lambda(q_j)<q_j<=D(n)`.

Prove a precise **control-or-capture theorem**:

> Either the maximal Carmichael atoms are paid for by at most three actual
> components, giving `lambda(n)<=D(n)^3`, or insufficient control depth
> remains and one admissible index has enough simultaneous full and partial
> prime-power mass to make `D_n(k)^3>=lambda(n)`.

This prose is a research target, not an assumed lemma. Replace it with the
weakest exact quantified statement that implies `H_lambda`.

## Required worker portfolio

Launch independent inference workers on:

1. extracting canonical finite prefix-depth certificates from failure of an
   actual Lucas support;
2. multiplying those depth certificates without assuming a sequential
   construction;
3. charging control powers `p_i^L` into maximal atoms of `lambda(q_j)`;
4. separating vertical atoms using quantitative Kummer carry depth;
5. separating horizontal atoms using divisibility in `p_j-1`;
6. proving a three-sink or three-bin theorem for the directed control graph;
7. constructing an arithmetic counterexample to the proposed charging
   theorem;
8. blind reconstruction and quantifier audit.

Each worker must attack one explicit lemma from both directions. Abstract
incidence graphs are insufficient: every edge and support must arise from
actual prime powers and digit/carry conditions. A falsifier must be an
unbounded arithmetic mechanism or a smallest exact failure that forces the
lead to weaken the lemma.

Inference is the primary compute. Use at most one tiny exact job, only to
falsify a named lemma or check a compact certificate. Do not run a broad
enumeration.

Return a proof of `H_lambda`, a genuine counterfamily, or the first exact
unproved charging lemma together with all proved implications and falsifiers.
Do not start Lean or emit `candidate.json` before the full original Part
(iii) chain is complete.
