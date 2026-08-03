# Complete divisor-poset characterization proof

Define `DivisorPosetSafe(n)` as follows. For every `d` in the finite divisor
set `n.divisors` with `P(n)<d` and `d/p<=P(n)` for every prime `p|d`, and every
`m` in `1..(n/d)/2`, require a prime `p|d` whose carry count is strictly larger
than the natural-subtraction budget `v_p(n)-v_p(d)`.

For `n>1`, membership `d∈n.divisors` is exactly `d|n` (with the automatically
satisfied condition `n≠0`) and also implies `d>0`. For such a divisor, natural
division gives the exact equivalence

```text
d*m <= n/2  iff  m <= (n/d)/2.
```

Indeed, divide the forward inequality by positive `d` and use
`(n/2)/d=n/(2d)=(n/d)/2`. Conversely, multiply `2m<=n/d` by `d` and use
`d(n/d)=n`.

If `DivisorPosetSafe(n)` holds and a boundary `d` is realized by `m`, then
`d∈n.divisors`; the cutoff equivalence puts the same positive `m` in the
cofactor interval. The required rejecting prime contradicts its realization
budget. Conversely, if `BoundarySafe(n)` holds and some divisor-poset pair has
no rejecting prime, negating the strict inequality gives every carry budget
for that same `m`. Divisor membership, `P<d`, the prime-deletion hypotheses,
and the cutoff equivalence make `d` a realized boundary, contradiction.

Thus `DivisorPosetSafe(n)↔BoundarySafe(n)` for every `n>1`. Composing with the
kernel-checked boundary-antichain theorem gives, for every composite `n>1`,

```text
f(n)=n/P(n) iff DivisorPosetSafe(n).
```

The public predicate contains none of the forbidden original objects.
