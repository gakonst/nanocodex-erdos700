# Erdős 700(iii): cyclotomic primitive-divisor adversary

## Purpose

Stress-test the Carmichael route with a genuinely simultaneous construction.
The new finite-prefix theorem rules out the natural sequential Dirichlet
template. Do not retry it.

For

```text
D_n(k)=n/gcd(n,binomial(n,k)),
D(n)=max_{2<=k<=n/2}D_n(k),
```

seek an unconditional unbounded family with

```text
lambda(n)>D(n)^3.
```

Such a family refutes `H_lambda`, not automatically Erdős 700(iii); preserve
that distinction.

## Mandatory recovery

Recover:

- `math-1784940116-3770583`, especially the finite-prefix Dirichlet no-go;
- the exact PC4 artifacts in `math-1784940116-3770585`;
- the weighted-support artifacts in `math-1784940116-3770584`.

Never inspect `events.jsonl`, snapshots, credentials, or telemetry.

## New architecture

Investigate simultaneous cyclic constructions using primitive prime divisors.
For example, choose components whose underlying primes are primitive divisors
of values `A_i^m_i-1`, so `m_i | p_i-1` supplies large, provably occurring
Carmichael factors without prescribing an unproved simultaneous prime tuple.
Use Zsigmondy-type theorems only with every exception and coprimality
hypothesis checked.

The construction must simultaneously control actual Lucas/Kummer supports.
Explore whether cyclic multiplicative-order relations can force all relevant
least digit-submask representatives beyond the half range, or whether those
same relations inevitably create an adaptive capturing multiplier.

Required independent workers:

1. primitive-divisor family designer and infinitude auditor;
2. private Carmichael-atom accountant;
3. exact all-index Lucas support analyst;
4. quantitative partial-valuation/Kummer analyst;
5. cyclic-order contradiction prover;
6. adversarial reviewer separating auxiliary failure from `H_lambda`;
7. blind alternative simultaneous construction.

A valid positive construction requires an explicit unbounded family, an exact
formula/lower bound for `lambda(n)`, and an upper bound on `D_n(k)` for every
admissible `k`, including partial prime-power layers. An unproved prime
constellation, selected-index evidence, abstract support system, or finite
example is failure.

A valid negative result is a quantified no-go theorem showing that the
primitive-divisor/cyclotomic architecture necessarily produces enough
simultaneous support to satisfy `lambda(n)<=D(n)^3`.

Inference is the primary compute. Use at most one tiny exact job for a named
falsifier or certificate. Do not run a generic search, start Lean, or emit
`candidate.json` before complete mathematics exists.
