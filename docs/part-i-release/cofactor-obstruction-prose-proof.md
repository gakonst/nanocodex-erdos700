# Complete proof of the cofactor-normalized characterization

Let `P=P(n)`. Define `CofactorObstructionSafe(n)` to mean that for every integer

```text
P+1 <= d <= P^2,
d | n,
d/p <= P for every prime p | d,
```

and every `m` with `1 <= m <= floor((n/d)/2)`, there is a prime `p|d` for which

```text
v_p(n)-v_p(d) < residueCarryCount(n,d*m,p).
```

Natural subtraction is intended. This definition is exactly the one in
`CofactorObstruction.lean`; it mentions neither `f`, gcds, binomial
coefficients, `Boundary`, `Realized`, `BoundarySafe`, nor the upstream open
theorem.

## Lemma 1: boundary divisors are at most `P^2`

Let `d` be a boundary divisor. Since `P<d`, we have `d>1`; choose a prime
`p|d`. Because `d|n`, also `p|n`, and the definition of largest prime factor
gives `p<=P`. Boundary minimality gives `d/p<=P`. Exact divisibility gives
`d=(d/p)p`, hence `d<=P^2`.

## Lemma 2: exact cofactor normalization

If `d>0` and `d|n`, then

```text
d*m <= floor(n/2)  iff  m <= floor((n/d)/2).                 (1)
```

For the forward implication, divide the inequality by `d`. Its left side is
`m`. Associativity of natural division gives

```text
floor(floor(n/2)/d) = floor(n/(2d))
                     = floor(n/(d2))
                     = floor(floor(n/d)/2).
```

For the reverse implication, multiply `2m<=n/d` by `d` and use
`d(n/d)=n`, valid because `d|n`. This gives `2dm<=n`, which is equivalent to
`dm<=floor(n/2)`. Thus (1) includes equality and introduces no divisibility or
parity assumption beyond `d|n` and `d>0`.

## Lemma 3: equivalence with `BoundarySafe`

Assume `CofactorObstructionSafe(n)` and suppose a boundary divisor `d` were
realized by `m`. Lemma 1 places `d` in `[P+1,P^2]`. Positivity and Lemma 2 put
the same witness `m` in `[1,floor((n/d)/2)]`. The cofactor predicate therefore
supplies a prime `p|d` whose carry count is strictly greater than its budget,
contradicting the realization inequality for that same `p`. Hence no boundary
is realized.

Conversely, assume `BoundarySafe(n)`. Take any `d,m` in the cofactor
predicate's ranges satisfying its divisor and prime-deletion hypotheses. If
there were no rejecting prime, then for every prime `p|d` the carry count would
be at most `v_p(n)-v_p(d)` (the negation of strict inequality is the reverse
nonstrict inequality, also for truncated natural subtraction). The lower
divisor bound makes `P<d`; Lemma 2 converts the multiplier range into
`dm<=floor(n/2)`. Thus this same positive `m` realizes the boundary `d`, a
contradiction. Therefore a rejecting prime exists. No prime-dependent witness
is introduced: one common `m` is used throughout.

It follows that, for every `n>1`,

```text
CofactorObstructionSafe(n) iff BoundarySafe(n).              (2)
```

The already proved boundary-antichain theorem and (2) yield, for composite
`n>1`,

```text
f(n)=n/P(n) iff CofactorObstructionSafe(n).
```

This is unconditional. The Lean kernel checks all lemmas and the final theorem
in `formal-upgrade/CofactorObstruction.lean`.
