# Structural upgrade for Erdős 700(i)

> **Superseded status note.** This document records the intermediate state
> before the full digit-shadow, bounded-obstruction, cofactor-normalized,
> divisor-poset, historical, and explicit compiler theorems were promoted.
> Its negative statements about completion are retained as research history,
> not current status. See the
> [complete release record](../../docs/part-i-release/README.md).

## Status

The all-composite `CarrySafe` theorem in `ADVERSARIAL_AUDIT.md` is an exact
finite normal form, but it does not by itself eliminate the common multiplier
in each minimal-overweight obstruction.  The results below make two genuine
structural advances:

1. they replace every selected prime-power carry test by a carry test on the
   much smaller cofactor `n / p^a` (or that cofactor minus one); and
2. they give a complete, explicit two-base digit characterization for the
   squarefree three-prime stratum.

The second theorem is an iff classification of every squarefree prime triple,
not merely a sufficient family.  It also proves that neither testing only the
minimal overweight divisor itself nor testing only indices which divide `n`
can work in general.

No claim is made here that a closed factorization-only classification for all
composite `n` has been obtained.  In particular, no uniform bounded list of
multipliers is proved sufficient.

## Notation

For a prime `p`, let

```text
κ_p(x,y) = v_p(binomial(x,y))
```

for `0 <= y <= x`.  Equivalently, by Kummer's theorem, `κ_p(x,y)` is the
number of base-`p` carries in `y + (x-y)`.

Write

```text
x ⪯_p y
```

when every base-`p` digit of `x` is at most the corresponding digit of `y`.
Kummer (or Lucas) gives

```text
κ_p(y,x) = 0  iff  x ⪯_p y.                 (1)
```

If

```text
n = product_{p | n} p^(a_p),
```

put

```text
W_n(k) = product_{p | n} p^((a_p - κ_p(n,k))_+).
```

Then

```text
gcd(n, binomial(n,k)) = n / W_n(k),          (2)
W_n(k) | gcd(n,k).                           (3)
```

For composite `n`, the index `k=P(n)` is admissible and has
`W_n(P(n))=P(n)`.  Consequently

```text
f(n) = n/P(n)
iff
W_n(k) <= P(n) for every 2 <= k <= floor(n/2).   (4)
```

These facts are reproved in the audited worker report and are used below only
as lemmas.

## 1. Intrinsic form of the overweight antichain

Let `P=P(n)`.  A divisor `d | n` is divisibility-minimal subject to `d>P` if
and only if

```text
d > P
and
d/p <= P for every prime p | d.              (5)
```

Indeed, necessity follows by deleting one prime factor.  Conversely, every
proper divisor of `d` divides `d/p` for at least one prime `p | d`, so (5)
forces every proper divisor to be at most `P`.

Thus the obstruction cores are determined directly from the exponent vector
of `n`; no binomial coefficients or indices occur in their definition.  If
`p_min(d)` is the least prime factor of `d`, (5) also gives the narrow
multiplicative window

```text
P < d <= p_min(d) P.                          (6)
```

Only cores `d <= n/2` can be realized.  Since (3) implies that a realized core
divides `k`, every possible witness has the unique form

```text
k = d m,
1 <= m <= floor((n/d)/2).                    (7)
```

Hence the multiplier range is controlled by the complementary divisor
`n/d`, rather than by `n`.

## 2. Exact quotient-carry recurrence

### Theorem 1

Let

```text
n = p^a M,   p ∤ M,   0 < k < n,
s = v_p(k).
```

Then

```text
κ_p(n,k)
  = a-s + κ_p(M-1, floor(k/p^a))   if s < a,   (8)
  =       κ_p(M,   k/p^a)          if s >= a.  (9)
```

### Proof

If `s<a`, write

```text
k = p^a q + r,   0 < r < p^a.
```

In the subtraction of `k` from `n`, the lower `a` digits contribute exactly
`a-s` borrows.  They leave one borrow entering digit `a`.  Above digit `a`,
the subtraction is therefore the subtraction of `q` from `M-1`, whose borrow
count is `κ_p(M-1,q)`.  This proves (8).

If `s>=a`, write `k=p^a q`.  The lower `a` digits are all zero and contribute
no borrow.  Removing these common trailing zero digits leaves precisely the
subtraction of `q` from `M`, proving (9).  Kummer identifies borrow counts
with the displayed valuations. ∎

### Corollary 2: exact feasibility of a core

Let `d | n`, let `p^b || d`, and put `k=dm`.  Since `b<=a`, Theorem 1 gives

```text
p^b | W_n(dm)
iff
κ_p(M-1, floor(dm/p^a)) <= b+v_p(m)-b = v_p(m)
    when b+v_p(m) < a,                         (10)
```

and

```text
p^b | W_n(dm)
iff
κ_p(M, dm/p^a) <= a-b
    when b+v_p(m) >= a.                        (11)
```

Thus `d | W_n(dm)` is equivalent to (10) or (11), as applicable, for every
prime-power `p^b || d`.

This is strictly shorter than carrying in `n`: the variable part of the test
lives in `M=n/p^a` or `M-1`.  It also separates the only two roles of `m`:
its `p`-adic valuation supplies an explicit carry budget in (10), while its
quotient modulo `p^a` supplies the shortened carry word.

### Corollary 3: the exact `m=1` screen

For `p^b || d`, the `p`-part of `d` is omitted at `k=d` exactly when

```text
floor(d/p^a) ⪯_p M-1   if b<a,                 (12)
d/p^a        ⪯_p M     if b=a.                 (13)
```

Therefore `d` itself is a witness exactly when (12)--(13) hold at every
prime dividing `d`.  In particular, if

```text
d <= n/2
and
d < p^(a_p) for every p | d,                   (14)
```

then `d | W_n(d)` and equality in Erdős 700(i) fails.

For (14), every quotient in (12) is zero, so every digit-containment condition
is automatic.

## 3. Complete classification of squarefree prime triples

The quotient recurrence becomes especially transparent when all exponent
towers have height one.

### Theorem 4 (two-base digit criterion)

Let `p<q<r` be primes and `n=pqr`.  Then

```text
f(pqr) = pq
```

if and only if the following condition holds:

> For every unordered pair `{a,b} ⊂ {p,q,r}` with `ab>r`, write
> `c=pqr/(ab)`.  There is no integer
>
> ```text
> 1 <= m <= floor(c/2)
> ```
>
> satisfying both
>
> ```text
> b m ⪯_a b c,
> a m ⪯_b a c.                                (15)
> ```

This predicate uses only the factorization and simultaneous digit containment
in the two bases selected by the pair.

### Proof

Because `n` is squarefree, (1)--(2) say that `W_n(k)` is exactly the product
of those primes `t | n` for which

```text
k ⪯_t n.                                      (16)
```

Suppose `W_n(k)>r`.  Any subset of `{p,q,r}` whose product exceeds `r`
contains a pair `{a,b}` with `ab>r`: a subset containing `r` and another
prime has this property, while the only subset not containing `r` is
`{p,q}`.  Thus `a` and `b` both occur in `W_n(k)`.

By (3), `ab | k`; write `k=abm`.  The bound `k<=pqr/2` is exactly
`m<=floor(c/2)`.  Multiplication by the base shifts a digit word one place,
so (16) at `a` is equivalent to

```text
bm ⪯_a bc.
```

The same argument at `b` gives the second condition in (15).

Conversely, if (15) holds for some pair and multiplier, set `k=abm`.
The multiplier bound makes `k` admissible, and the two containments show that
both `a` and `b` occur in `W_n(k)`.  Hence

```text
W_n(k) >= ab > r.
```

Equation (4) now proves both directions. ∎

### Shape of the obstruction list

There are at most three pair tests:

```text
{p,r},  with 1 <= m <= floor(q/2);
{q,r},  with 1 <= m <= floor(p/2);
{p,q},  with 1 <= m <= floor(r/2), only when pq>r.
```

This is the exact squarefree-triple repair requested by the campaign prompt.
It retains the common multiplier because the examples below prove that the
multiplier is real structure, not an artifact of the proof.

## 4. Exact examples and counterexamples to tempting simplifications

### The mandatory obstruction `n=78`

Take

```text
(p,q,r) = (2,3,13).
```

For the pair `{3,13}`, the remaining prime is `c=2`, so only `m=1` is
possible.  The two tests are

```text
13 = 111_3 ⪯_3 222_3 = 26,
 3 =   3_13 ⪯_13  6_13 = 6.
```

Thus `k=3*13=39` omits both `3` and `13`, and

```text
W_78(39)=39,
gcd(78,binomial(78,39))=2<6=78/13.
```

This recovers the required regression without evaluating the binomial
coefficient.

### A repeated-prime multiplier obstruction: `n=136`

Here

```text
n=2^3*17,  P=17,
```

and (5) gives the single active core `d=34`.  Its multiplier range is
`m=1,2`.

At `m=1`, the `17` condition has zero carries, but the shortened binary test is

```text
κ_2(17-1, floor(34/8)) = κ_2(16,4) = 2 > 0,
```

so `34 ∤ W_136(34)`; in fact `W_136(34)=17`.

At `m=2`, the binary valuation of `m` supplies one carry of budget:

```text
κ_2(16, floor(68/8)) = κ_2(16,8) = 1 <= v_2(2).
```

The base-`17` test is `κ_17(8,4)=0`.  Hence

```text
34 | W_136(68).
```

Directly, the carry counts are two in base `2` and zero in base `17`, so
`W_136(68)=2*17=34>17`.  This rigorously disproves any rule which tests only
`m=1`.

### A squarefree non-divisor obstruction: `n=195`

Let

```text
n=3*5*13,  P=13.
```

The pair `d=3*5=15` is minimally overweight.  At `m=1`, its base-`3`
condition fails:

```text
5 = 12_3  not⪯_3  2102_3 = 65
```

because the `3^1` digit is `1>0`.

At `m=2`, both conditions hold:

```text
10 = 0101_3 ⪯_3 2102_3 = 65,
 6 =  011_5  ⪯_5  124_5 = 39.
```

Therefore `k=30` omits `3` and `5`,

```text
W_195(30)=15>13,
gcd(195,binomial(195,30))=13<15=195/13.
```

Moreover, checking only indices which divide `n` also misses this failure.
The only divisor indices which could contain an overweight pair are
`15`, `39`, and `65`:

* `15` fails the base-`3` condition just displayed.
* For the pair `{3,13}`, `13=0111_3` is not digitwise contained in
  `65=2102_3`.
* For the pair `{5,13}`, `5=5_13` is not digitwise contained in
  `15=12_13`.

All remaining proper divisors omit at most one prime, so their weight is at
most `13`.  Thus every admissible divisor index is harmless, while the
non-divisor index `30` is an obstruction.

### Recovery of `n=30`

For `(p,q,r)=(2,3,5)`, all three pair products exceed `5`.

* For `{2,3}`, the possible multipliers are `1,2`.  The base-`3` tests fail:
  `2` is not contained in `10=101_3`, and `4=11_3` is not contained in
  `10=101_3`.
* For `{2,5}`, only `m=1` is possible, and `2` is not contained in
  `6=11_5`.
* For `{3,5}`, only `m=1` is possible, and `5=12_3` is not contained in
  `10=101_3`.

Theorem 4 therefore gives `f(30)=30/5=6`.

## 5. What the remaining all-composite lemma really is

Theorem 1 shows that the unresolved part is not evaluation of large binomial
coefficients.  For every intrinsic core (5), it is the following coupled
feasibility problem:

```text
find one common m in 1..floor((n/d)/2)
such that, for every p^b || d,
the shortened carry inequality (10) or (11) holds.       (17)
```

The examples prove three limitations on any attempted simplification:

1. `m=1` is not sufficient (`n=136`, and already squarefree `n=195`);
2. indices dividing `n` are not sufficient (`n=195`);
3. the primewise conditions cannot be solved independently, because the same
   `m` must satisfy digit constraints in different bases (Theorem 4).

Accordingly, the audited carry predicate is legitimately an exact
cross-base-feasibility normal form.  Theorem 4 demonstrates that this coupling
survives even in the first nontrivial squarefree stratum.  These observations
do **not** prove that no more closed all-composite classification exists.  A
complete solution of part (i) still needs either:

* a theorem deciding (17) from the factorization without scanning all its
  multipliers; or
* a proof that an explicitly specified finite automaton/digit-feasibility
  object, rather than the raw multiplier interval, is the intended structural
  classification.

The strongest completed stratum at present is Theorem 4.
