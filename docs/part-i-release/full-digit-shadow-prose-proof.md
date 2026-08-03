# Finite digit-shadow characterization

## Statement

For a prime `p`, put

\[
 S_p(n,k)=\#\{,i:1\le i\le\lfloor\log_p n\rfloor,
                 \ n\bmod p^i<k\bmod p^i,\}.
\]

For a divisor candidate `d`, put

\[
 Q_n(d)=\prod_{p\mid d}p^{\lfloor\log_p n\rfloor}.
\]

`FiniteShadowOccurs(n,d)` means that one integer `r` satisfies

\[
 1\le r\le Q_n(d),\qquad dr\le\lfloor n/2\rfloor,
\]

and, simultaneously for every prime `p|d`,

\[
 S_p(n,dr)\le v_p(n)-v_p(d).
\]

`FullShadowBoundary(n,d)` is the conjunction

\[
 d\mid n,\qquad P(n)<d,\qquad
 d/p\le P(n)\quad\hbox{for every prime }p\mid d.
\]

Finally, `FullShadowSafe(n)` says that no full-shadow boundary divisor has
`FiniteShadowOccurs`.  These public definitions mention neither `f`, gcd,
binomial coefficients, `Realized`, nor `BoundarySafe`.

The compiled theorem is

\[
 f(n)=n/P(n)\quad\Longleftrightarrow\quad
 \operatorname{FullShadowSafe}(n)
\]

for every composite `n>1`.

## Carry/digit lemma

Let `0<q` and `k<=n`.  Set

\[
 a=k\bmod q,\quad b=(n-k)\bmod q,\quad s=a+b.
\]

Then `a,b<q` and, because `k+(n-k)=n`,

\[
 n\bmod q=s\bmod q.
\]

If `s<q`, there is no carry and `s mod q=s>=a`.  If `q<=s`, then
`s<2q`, so `s mod q=s-q<a`, the last inequality following from `b<q`.
Consequently

\[
 q\le k\bmod q+(n-k)\bmod q
 \quad\Longleftrightarrow\quad
 n\bmod q<k\bmod q.                 \tag{1}
\]

Taking `q=p^i` and counting the indices in the Kummer range gives

\[
 \operatorname{residueCarryCount}(n,k,p)=S_p(n,k). \tag{2}
\]

The upper endpoint is exactly `floor(log_p n)`.  If `p>n`, the range is
empty, as it should be.

## Simultaneous period lemma

Fix `p|d` and let `h=floor(log_p n)`.  For each `i<=h`,

\[
 p^i\mid p^h\mid Q_n(d).
\]

Thus `m congruent r (mod Q_n(d))` implies
`m congruent r (mod p^i)`, and multiplication by the same `d` gives

\[
 dm\bmod p^i=dr\bmod p^i.
\]

Every comparison defining `S_p` is therefore unchanged.  Since the single
modulus `Q_n(d)` contains the required power for every prime divisor of `d`,
the same `r` works for all primes; no invalid exchange of `forall p` and
`exists r` occurs.

## Finite-shadow equivalence

Assume `n>0` and `d|n`.  Then `d>0`.  Also `Q_n(d)>0`, since it is a finite
product of positive prime powers.

If `FiniteShadowOccurs(n,d)` has witness `r`, then `dr<=n/2<=n`.
Equation (2) converts every digit-shadow inequality into the defining carry
budget of `Realized`, with the same positive `r` and the same inclusive
endpoint.  Hence `Realized(n,d)`.

Conversely, let `m>0` realize `d` and define the least-positive residue

\[
 r=((m-1)\bmod Q_n(d))+1.
\]

Then

\[
 1\le r\le Q_n(d),\qquad r\equiv m\pmod{Q_n(d)},
 \qquad r\le m.
\]

The last inequality is elementary because `(m-1) mod Q <= m-1`.
Therefore `dr<=dm<=n/2`.  The simultaneous period lemma preserves every
`S_p`, and (2) converts the original carry budgets to the desired digit
budgets.  Thus

\[
 \operatorname{FiniteShadowOccurs}(n,d)
 \quad\Longleftrightarrow\quad
 \operatorname{Realized}(n,d).       \tag{3}
\]

`FullShadowBoundary` is definitionally the original `Boundary`.  Applying
(3) to each such divisor proves

\[
 \operatorname{FullShadowSafe}(n)
 \quad\Longleftrightarrow\quad
 \operatorname{BoundarySafe}(n).     \tag{4}
\]

Composing (4) with the already proved boundary-antichain theorem yields the
displayed characterization.

## Edge cases and limitation

- The product can be the empty product `1`, never `0`.
- The hypothesis `n>0` and `d|n` excludes `d=0`.
- Repeated powers are retained in `d`, in `dr`, and in
  `v_p(n)-v_p(d)`; listing each prime once in `Q_n(d)` is sufficient because
  its factor already contains the largest needed modulus `p^h`.
- Natural subtraction is harmless on boundary divisors because `d|n` implies
  `v_p(d)<=v_p(n)`.
- The inequality `dr<=n/2` is non-strict and retains `k=n/2`.

The period normal form must not be advertised as a smaller universal search.
Indeed, for any `p|d`, `p^floor(log_p n)>n/p>=n/d`, so
`Q_n(d)>n/d`, whereas every admissible witness has `m<=n/(2d)<n/d`.
Thus the least-positive residue is already `m` on the relevant interval.
The theorem strengthens explicitness and public independence, not the
asymptotic multiplier bound.

## Formal certificate

`FullDigitShadow.lean`, SHA-256
`398fdbccd8a27e798416ff41d5f8889da816c04887b7f127c8f7e685d85f11a6`,
compiles with Lean 4.27.0.  The three promoted declarations print exactly
`[propext, Classical.choice, Quot.sound]`.
