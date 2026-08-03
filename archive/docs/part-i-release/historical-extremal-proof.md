# Extremal admissible-carry proof

For fixed `n`, define

    M(n) = max { residueCarryWeight(n,k) : 2 <= k <= n/2 }.

The Lean definition uses a `Finset.range (n+1)` supremum and assigns weight
zero outside the admissible interval.  This makes the maximum total and avoids
choosing a maximizing index.

The generic exact-weight theorem says that, once an admissible witness has
weight `B`,

    f(n) = n/B  iff  every admissible weight is at most B.

For the historical baseline `B=Q(n)` and a non-prime-power `n`, the checked
index `k=Q(n)` is admissible and has weight exactly `Q(n)`.  Consequently

    f(n)=n/Q(n)  iff  M(n)=Q(n).

The parameterized boundary bridge independently gives

    M(n)=Q(n)  iff  HistoricalBoundarySafe(n).

The final theorem composes these equivalences.  In its forward direction it
first excludes composite prime powers using the proved formula `f(p^a)=p`
and `Q(p^a)=p^a`; the reverse direction takes the explicit non-prime-power
conjunct.  Thus prime powers are not hidden in a side condition.

The promoted proof body invokes neither the earlier packaged historical
theorem nor the v4 strict-order-duality theorem.  The reusable exact-weight,
boundary, and `Q(n)` witness lemmas remain dependencies and are included in
the same auditable source.
