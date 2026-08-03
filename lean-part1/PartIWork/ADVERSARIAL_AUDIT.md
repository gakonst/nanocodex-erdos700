# Adversarial audit of the carry characterization

> **Superseded status note.** This audit predates the prime-power threshold,
> original 1978 specialization, full-shadow theorem, bounded/cofactor/divisor
> obstruction forms, and explicit factor-tableau compiler. Its objections
> drove those upgrades, but its conclusion that Part (i) was not yet solved is
> no longer current. See the
> [complete release record](../../archive/docs/part-i-release/README.md) and
> [`PartIVerify.lean`](../PartIVerify.lean).

Audited artifact:
`runs/math-1784843263-47597/worker-reports/agent-1-padic-proof-architect.md`
on the remote campaign host.

## Verdict at the time of this intermediate audit

The p-adic identities and the stated equivalence with `CarrySafe` are
mathematically correct. I found no boundary or repeated-prime-power error.
Independent exact checks agreed with the formulas for every composite
`n ≤ 500`, and `CarrySafe(n) ↔ f(n) = n / P(n)` for every composite
`n ≤ 1000`.

However, `CarrySafe` should currently be presented as an **exact Kummer
normal form and finite obstruction reduction**, not as a completed historical
characterization of the equality cases. It meets the literal independence
test—its definition contains neither `f` nor a binomial coefficient—but its
proof is obtained by substituting Kummer's formula into the original
all-indices condition and repackaging each bad index by a minimal divisor.
It still quantifies over all multiples `k = dm` capable of being an
obstruction and performs the residue tests equivalent to computing the
relevant binomial valuations. It does not yet identify a recognizable class
of factorizations or eliminate the index search. Under the campaign's
“mathematically informative, not merely a decision procedure” requirement,
this is a strong reduction but not yet enough to claim Erdős 700(i).

## Formula audit

### Residue/borrow form of Kummer

For `q = p^j`, writing `n = Aq + r` and `k = Bq + s` gives

```text
floor(n/q) - floor(k/q) - floor((n-k)/q) = 1  iff  s > r.
```

Thus

```text
v_p(binomial(n,k))
  = #{j ≥ 1 : k mod p^j > n mod p^j}.
```

If `p^a ∥ n`, the terms with `j ≤ a` contribute exactly
`a - min(a, v_p(k))`; the remaining terms are exactly `h_p(n,k)`.
Terms with `p^j > n` vanish because `0 < k < n < p^j`. Therefore

```text
v_p(binomial(n,k))
  = a - min(a, v_p(k)) + h_p(n,k)
```

is correct, including when `v_p(k) ≥ a`.

It follows without exchanging numerical and componentwise minima that

```text
n / gcd(n, binomial(n,k))
  = W_n(k)
  = product_{p|n} p^(min(a_p,v_p(k)) - h_p(n,k))_+.
```

The criterion

```text
d | W_n(k)
iff
d | k and
h_p(n,k) ≤ min(a_p,v_p(k)) - v_p(d) for every p | d
```

is also exact. The explicit `d | k` condition is redundant once all displayed
inequalities hold, but it is harmless and useful in the later parametrization
`k = dm`.

### The `k = P` witness, including `P^a ∥ n`

The witness proof survives arbitrary exponent `a ≥ 1`. For every `j > a`
with `P^j ≤ n`,

```text
n mod P^j = P^a * (unit mod P^(j-a))
```

is a positive multiple of `P^a`, while `P mod P^j = P`. Hence no upper borrow
occurs. (If `n = P^a`, there are simply no such upper layers.) Consequently

```text
s_P(n,P) = min(a,1) = 1,
s_q(n,P) = 0 for q ≠ P,
W_n(P) = P.
```

Also, compositeness gives `n/P ≥ 2`, so `1 < P ≤ n/2`; the witness is always
in the defining range. This proves only that `max W_n(k) ≥ P`, as required.
It does not falsely assert equality for higher prime powers: for example, when
`n = p^a` and `a > 2`, other indices have weight greater than `p`.

### Passing from `f` to the maximum weight

For the finite nonempty set `K_n = {k : 2 ≤ k ≤ floor(n/2)}`, every `W_n(k)`
is a positive divisor of `n`, and

```text
gcd(n, binomial(n,k)) = n / W_n(k).
```

Therefore

```text
f(n) = n / max_{k in K_n} W_n(k).
```

This uses ordinary numerical order and is valid. Together with `W_n(P) = P`,
it yields

```text
f(n) = n/P iff W_n(k) ≤ P for every k in K_n.
```

### Minimal-divisor antichain

If some `W_n(k) > P`, choose a divisibility-minimal divisor `d | W_n(k)`
with `d > P`. Since `W_n(k) | n`, this `d` lies in `M(n)`, and
`W_n(k) | gcd(n,k)` gives `d | k`. Conversely, a failure of `CarrySafe`
produces `k = dm` in `K_n` and the exact divisibility criterion gives
`d | W_n(k)`, hence `W_n(k) ≥ d > P`.

The bounds are correct in both directions:

```text
1 ≤ m ≤ floor(n/(2d))
iff
k = dm ≥ d > P ≥ 2 and 2k ≤ n.
```

Thus the antichain argument has no hidden divisibility-versus-numerical-order
gap.

## What remains for a claim of part (i)

The next theorem must add structural content beyond this normal form—for
example, characterize which minimal threshold divisors can be realized by a
carry-safe multiple using conditions on the factorization/digit geometry, or
reduce each such realization question to a bounded set independent of the
full interval of candidate indices. Until that additional elimination or
classification is proved, the safe claim is:

> Erdős 700(i) has been reduced exactly to a finite family of explicit
> prime-power residue obstructions.

It is not yet safe to claim:

> The composite equality cases in Erdős 700(i) have been characterized in the
> intended historical sense.
