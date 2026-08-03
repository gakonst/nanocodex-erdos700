# Erdős Problem 700(i): exact 1978 greatest-prime-power formulation

## Source correction and immutable target

The retained primary source, Erdős--Szekeres (1978), says:

```text
P(n) is the greatest prime power which divides n.
```

This differs from the modern Formal Conjectures definition, which uses the
largest prime divisor. The difference is mathematical, not notational:

```text
n = 12
f(12) = 3
greatest exact prime-power component = 4
largest prime divisor = 3
```

Thus `f(12)=12/4`, while `f(12) != 12/3`.

Recover all reports and exact jobs from:

```text
runs/math-1784850943-109101/
runs/math-1784859934-190817/
```

Never inspect an `events.jsonl`.

Read all sources under `proof/PartIWork/`, especially the exact-weight,
largest-prime, and boundary-antichain bridges. Reuse checked generic machinery
where its hypotheses genuinely apply, but do not present the modern theorem
as the historical theorem.

## Required historical definition

Define the greatest exact prime-power component

```text
Q(n) = max { p^(factorization(n,p)) : p is prime and p | n }.
```

For `n>1` this is a positive divisor of `n`. It equals `n` exactly when `n`
is a prime power.

For a baseline `Q(n)`, define:

```text
HistoricalBoundary n d :=
  d | n
  and Q(n) < d
  and d/p <= Q(n) for every prime p | d.

HistoricalRealized n d :=
  there is m>0 with d*m <= n/2 and, for every prime p | d,
  residueCarryCount n (d*m) p
    <= factorization(n,p) - factorization(d,p).

HistoricalBoundarySafe n :=
  no HistoricalBoundary divisor is HistoricalRealized.
```

The exact target for every composite `n>1` is:

```text
f(n) = n / Q(n)
  iff
not IsPrimePow(n) and HistoricalBoundarySafe(n).
```

An extensionally equal formulation is permitted. It must explicitly handle
prime powers rather than hiding them in a side condition.

## Load-bearing witness

For a non-prime-power `n`, prove that `Q(n)` is admissible and

```text
gcd(n, binomial(n,Q(n))) = n / Q(n),
residueCarryWeight n Q(n) = Q(n).
```

If `Q(n)=p^a` and `n=Q(n)*m`, exactness means `p` does not divide `m`.
The proof must establish that `p` does not divide
`binomial(n,Q(n))`, while `n/Q(n)` divides that binomial coefficient.
Lucas/Kummer, exact factorization, or an equivalent checked argument may be
used.

For `n=p^a`, use the checked formula `f(p^a)=p` to prove that the historical
equality fails because `n/Q(n)=1`.

## Independent worker portfolio

Launch all roles independently before synthesis.

1. **Primary-source and specification auditor.** Pin the precise 1978
   definition, compare it to Formal Conjectures, and write the exact Lean
   proposition including prime-power exceptions.
2. **Prime-power-component witness specialist.** Prove the displayed
   `k=Q(n)` gcd/weight identities on paper, auditing exactness,
   admissibility, repeated powers, Lucas digits, and the half interval.
3. **Lean API specialist.** Find the shortest Mathlib-supported proof of the
   witness. Compile focused probes before proposing the final declaration.
4. **Parameterized-boundary architect.** Generalize the existing
   carry-safe/boundary proof from the largest-prime baseline to any positive
   divisor with an admissible exact witness. Specialize it to `Q(n)`.
5. **Counterexample and regression auditor.** Compare the historical and
   modern predicates, target repeated prime powers, and scan every composite
   `n<=1000` by direct binomial gcd evaluation against the historical
   predicate.
6. **Blind release referee.** Reconstruct both directions without trusting
   the intended proof; reject any theorem that proves only the modern
   largest-prime variant or silently assumes squarefreeness.

Use retained follow-ups on the hardest Lean witness lemma and on an adversary
attempting to falsify the complete theorem.

## Mandatory cases

- `n=12`: historical equality true, modern largest-prime equality false.
- `n=8`: `Q(8)=8`, `f(8)=2`, so historical equality false.
- `n=18`: exercise `Q(18)=9`, a repeated-power component with a nontrivial
  coprime cofactor.
- `n=30`: both baselines equal `5`; preserve the existing equality case.
- `n=78`: preserve the included endpoint obstruction.
- `n=136`: preserve the necessity of a nontrivial multiplier.

Finite computation is regression evidence only.

## Formal release gate

Produce a dedicated Lean root and verification script. The promoted theorem
must:

- compile under the pinned toolchain;
- have no `sorry`, `admit`, local axiom, unsafe bypass, or invocation of the
  upstream open theorem;
- depend only on the audited standard axioms
  `[propext, Classical.choice, Quot.sound]`;
- be exercised by GitHub Actions;
- retain raw compile and axiom logs.

Required final verdict:

```text
HISTORICAL PART (i) FORMALLY VERIFIED
```

or `REFUTED` with the smallest incorrect lemma. Do not substitute the modern
variant or an unformalized prose argument.
