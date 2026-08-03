# Prime-power threshold theorem and historical specialization

## Theorem A (arbitrary proper prime-power threshold)

Let \(n>0\), let \(p\) be prime, and let \(b>0\).  Put
\(q=p^b\), and suppose \(q\mid n\) and \(q<n\).  Define

\[
 \operatorname{BoundaryAt}(n,q,d)
 \Longleftrightarrow
 d\mid n,\quad q<d,\quad
 \frac d r\le q\quad\hbox{for every prime }r\mid d,
\]

and let `BoundarySafeAt(n,q)` say that no such divisor is `Realized` (with
exactly the carry-budget definition in `problem.md`).  Then

\[
 \boxed{f(n)=\frac nq\quad\Longleftrightarrow\quad
        \operatorname{BoundarySafeAt}(n,q).}
\]

### 1. The index \(q\) is admissible

Write \(n=cq\).  Positivity gives \(c>0\), and \(q<n\) excludes \(c=1\),
so \(c\ge2\).  Thus \(q\le n/2\).  Also \(q>1\), because \(p\) is prime
and \(b>0\).  Hence \(1<q\le n/2\).

### 2. Exact attainment at the index \(q\)

The binomial identity

\[
 \binom{cq}{q}=c\binom{cq-1}{q-1}                                      \tag{1}
\]

follows from \(q\binom{cq}{q}=cq\binom{cq-1}{q-1}\).  In base \(p\),
the lowest \(b\) digits of both \(cq-1\) and \(q-1=p^b-1\) are all
\(p-1\).  Repeated Lucas reduction therefore gives

\[
 \binom{cq-1}{q-1}\equiv1\pmod p.                                      \tag{2}
\]

Consequently this last binomial coefficient is coprime to \(p^b=q\).
Using (1),

\[
 \gcd\!\left(cq,\binom{cq}{q}\right)
 =\gcd(cq,cA)=c\gcd(q,A)=c=\frac nq,                                  \tag{3}
\]

where \(A=\binom{cq-1}{q-1}\).  This argument permits \(p\mid c\); no
unstated exact-valuation hypothesis is used.

### 3. Complementary carry weights

For an admissible \(k\), put

\[
 W_n(k)=\prod_{r\mid n}r^{v_r(n)\mathbin{\dotminus}
                                  v_r\binom nk}.
\]

Kummer identifies the second valuation with `residueCarryCount n k r`.
Primewise valuation gives

\[
 \gcd\!\left(n,\binom nk\right)W_n(k)=n.                               \tag{4}
\]

The recurrence \(n\binom{n-1}{k-1}=k\binom nk\) gives \(W_n(k)\mid k\).
Applying (4) to (3), and cancelling the positive factor \(n/q\), yields

\[
 W_n(q)=q.                                                              \tag{5}
\]

Thus the finite minimum is exactly \(n/q\) iff every admissible weight is
numerically at most \(q\).  One implication multiplies
\(n/q\le\gcd(n,\binom nk)\) by \(W_n(k)\); the converse uses (4), and (5)
supplies equality at an admissible index.  This is numerical order, not
componentwise exponent order.

### 4. Boundary antichain and realization

For every divisor \(W\mid n\),

\[
 q<W\quad\Longleftrightarrow\quad
 \exists d\mid W\;\operatorname{BoundaryAt}(n,q,d).                    \tag{6}
\]

For the forward direction, choose the least divisor of \(W\) exceeding
\(q\).  Dividing it by any prime divisor produces a smaller divisor and
hence one at most \(q\).  The converse is immediate.

If \(d\mid n\), then primewise natural-subtraction arithmetic gives

\[
 d\mid W_n(k)
 \Longleftrightarrow
 \forall r\mid d,
 \operatorname{residueCarryCount}(n,k,r)
       \le v_r(n)-v_r(d).                                               \tag{7}
\]

Since \(W_n(k)\mid k\), a divisor \(d\mid W_n(k)\) also divides \(k\),
so the same admissible index has the form \(k=dm\) with \(m>0\).  Conversely
the budgets in `Realized(n,d)` imply (7) at \(k=dm\).  The condition
\(dm\le n/2\) is inclusive.  Therefore a boundary divisor divides an
admissible weight iff it is realized.  Combining this with (6) proves
Theorem A.

## Corollary B (the immutable modern theorem)

For composite \(n>1\), take \(p=P(n)\) and \(b=1\).  Then \(p\mid n\),
and compositeness makes \(p<n\).  `BoundaryAt(n,p)` and
`BoundarySafeAt(n,p)` unfold to the frozen `Boundary` and `BoundarySafe`.
Theorem A is therefore exactly

\[
 f(n)=n/P(n)\quad\Longleftrightarrow\quad\operatorname{BoundarySafe}(n).
\]

## Corollary C (literal 1978 greatest-prime-power version)

Let

\[
 Q(n)=\max_{p\mid n}p^{v_p(n)}.
\]

This is the greatest prime power dividing \(n\).  If \(n\) is not itself a
prime power, an attaining component \(Q(n)=p^{v_p(n)}\) is a proper divisor,
so Theorem A applies.  If \(n=p^a\) is composite, then \(Q(n)=n\), while the
standard prime-power evaluation gives \(f(n)=p>1=n/Q(n)\); equality is
impossible.  Hence for every composite \(n>1\),

\[
 \boxed{f(n)=\frac{n}{Q(n)}
 \quad\Longleftrightarrow\quad
 \neg\operatorname{IsPrimePow}(n)\ \land\
 \operatorname{BoundarySafeAt}(n,Q(n)).}
\]

This includes the prime-power exception explicitly rather than silently
applying a proper-divisor theorem outside its domain.

## Formal evidence

`PrimePowerThreshold.lean` proves Theorem A over the local audited Part-I
modules.  The standalone file `solution-full-historical-v4.lean` proves both
Corollaries B and C against the pinned Formal Conjectures/Mathlib dependency
set.  The retained compile logs report exit 0 and exactly
`[propext, Classical.choice, Quot.sound]` for all promoted results.
