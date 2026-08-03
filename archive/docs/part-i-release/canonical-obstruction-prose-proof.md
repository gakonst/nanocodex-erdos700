# Canonical bounded-obstruction characterization

Write `P=P(n)`.  For `n>1`, define `BoundedObstructionSafe(n)` to mean:
for every integer

\[
 P+1\le d\le P^2,
\]

if `d|n` and `d/p<=P` for each prime `p|d`, then for every integer
`1<=m<=n/2` satisfying `dm<=n/2`, there is a prime `p|d` such that

\[
 v_p(n)-v_p(d)<C_p(n,dm),
\]

where subtraction is natural-number subtraction and
`C_p(n,k)=residueCarryCount n k p`.  This is a finite predicate involving
only divisibility, prime factors, valuations, residue carries, inequalities,
and bounded quantifiers.

## Divisor compression lemma

If `d` is a boundary divisor, then `d<=P^2`.

Indeed, `P<d`, so `d>1`; choose a prime `p|d`.  Since `d|n`, also `p|n`, and
the definition of the largest prime factor gives `p<=P`.  Boundary minimality
gives `d/p<=P`.  Exact divisibility yields

\[
 d=(d/p)p\le P^2.
\]

This argument permits repeated prime factors and does not assume that `d` is
squarefree.

## Equivalence with boundary safety

Assume first `BoundedObstructionSafe(n)`, and let `d` be a boundary divisor.
The lower bound `P+1<=d` follows from `P<d`, and the compression lemma supplies
`d<=P^2`.  Suppose for contradiction that `d` is realized by `m`.  Then
`m>0`, `dm<=n/2`, and for every prime `p|d`,

\[
 C_p(n,dm)\le v_p(n)-v_p(d).
\]

Because `d>0`, `m<=dm<=n/2`; hence `m` lies in the finite multiplier interval
used by the new predicate.  That predicate produces a prime `p|d` for which
the strict reverse inequality holds, a contradiction.  Thus no boundary
divisor is realized.

Conversely, assume boundary safety and fix `d,m` satisfying all clauses of the
bounded predicate.  If no rejecting prime existed, totality of the natural
order would give, for every prime `p|d`,

\[
 C_p(n,dm)\le v_p(n)-v_p(d).
\]

The lower interval endpoint gives `P<d`; together with `d|n` and the
prime-deletion inequalities, this makes `d` a boundary divisor.  The lower
multiplier endpoint gives `m>0`, and the assumed product bound plus the carry
inequalities makes `d` realized by this same `m`.  This contradicts boundary
safety.  Therefore a rejecting prime exists for every candidate pair, proving
`BoundedObstructionSafe(n)`.

We have proved, unconditionally for every `n>1`,

\[
 BoundedObstructionSafe(n)\iff BoundarySafe(n).
\]

Combining this with the already proved carry-antichain theorem gives, for every
composite `n>1`,

\[
 f(n)=n/P(n)\iff BoundedObstructionSafe(n).
\]

The Lean declarations
`boundary_le_largestPrime_sq`,
`boundedObstructionSafe_iff_boundarySafe`, and
`f_eq_div_iff_boundedObstructionSafe` formalize these three steps.
