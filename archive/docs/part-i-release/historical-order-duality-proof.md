# Alternate proof through gcd/weight order duality

Let `B` be a positive divisor of `n`, let

    G(k) = gcd(n, binomial(n,k)),
    W(k) = residueCarryWeight(n,k),
    R = n/B.

For every admissible `k`, the exact-weight theorem gives `G(k)W(k)=n`.
Divisibility gives `RB=n`.  Since `R,B,W(k)>0`, multiplication preserves and
reflects strict order in the needed factors, hence

    G(k) < R  iff  B < W(k).                         (1)

The Lean proof of (1) uses only the two exact products.  For example, if
`G(k)<R` but `W(k)<=B`, then
`n=G(k)W(k)<=G(k)B<RB=n`, a contradiction.  The converse is symmetric.

The minimal-divisor boundary bridge says that a carry weight exceeds `B`
exactly when it contains a divisor `d` of `n` that is minimal above `B`.
Minimality is equivalent to

    B < d  and  d/p <= B for every prime p dividing d.

Moreover `W(k)` divides `k`; writing `k=d*m` gives one common positive
multiplier and preserves the endpoint `d*m<=n/2`.  The valuation formula for
`W(k)` says `d | W(k)` exactly when every frozen carry-budget inequality
holds.  Thus such a `k` exists exactly when a historical boundary divisor is
realized.  Combining this with (1) gives the new direct certificate

    HistoricalBoundarySafe_B(n)
      iff
    for every admissible k, R <= G(k).                (2)

Now take `B=Q(n)`.  If `n` is not a prime power, the exact `k=Q(n)` witness is
admissible and has `G(Q(n))=n/Q(n)`.  If `f(n)=n/Q(n)`, the defining minimum
property of `f` gives all lower bounds in (2), hence boundary safety.
Conversely, boundary safety gives all those lower bounds, while the `Q(n)`
witness attains equality, so the minimum is `n/Q(n)`.

If `n` is a composite prime power, `Q(n)=n`, so `n/Q(n)=1`, whereas the checked
prime-power formula gives `f(p^a)=p>1`.  Therefore equality fails, exactly as
the explicit `not IsPrimePow(n)` conjunct requires.

In `release-v4/solution.lean`, `Campaign.result` invokes this alternate theorem
and not the earlier packaged final equivalence.  Lean checks (1), the exact
obstruction existential, (2), and the complete theorem with exactly
`[propext, Classical.choice, Quot.sound]`.
