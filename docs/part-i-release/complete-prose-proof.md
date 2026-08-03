# Complete prose proof of the modern boundary characterization

## Theorem

Let $n>1$ be composite, let $P=P(n)$ be the largest prime divisor of
$n$, and use the definitions of `Boundary`, `Realized`, and `BoundarySafe`
in `problem.md`. Then

\[
 f(n)=\frac nP\quad\Longleftrightarrow\quad
 \operatorname{BoundarySafe}(n).
\]

This proves the immutable modern statement. It does **not** identify this
$P$ with the greatest-prime-power function used in the 1978 source.

## 1. Complementary carry weight

For $2\le k\le\lfloor n/2\rfloor$, put

\[
 \kappa_p(n,k)=v_p\binom nk,
 \qquad
 W_n(k)=\prod_{p\mid n}p^{\,v_p(n)\mathbin{\dotminus}\kappa_p(n,k)},
\]

where $\dotminus$ is subtraction in $\mathbb N$. Kummer's theorem identifies
$\kappa_p(n,k)$ with `residueCarryCount n k p`: it is the number of base-$p$
carries in $k+(n-k)=n$, equivalently the number of $i\ge1$ for which

\[
 k\bmod p^i>n\bmod p^i.
\]

Let $G_k=\gcd(n,\binom nk)$. Prime by prime,

\[
 v_p(G_k)=\min\{v_p(n),\kappa_p(n,k)\}.
\]

Since $\min(a,c)+(a\mathbin{\dotminus}c)=a$, we get the exact
positive-integer identity

\[
 \boxed{G_kW_n(k)=n}. \tag{1}
\]

In particular, $W_n(k)>0$ and $W_n(k)\mid n$.

There is a second essential divisibility. The identity

\[
 n\binom{n-1}{k-1}=k\binom nk
\]

implies $n\mid k\binom nk$. Hence, for every prime $p$,

\[
 v_p(n)\le v_p(k)+v_p\binom nk,
\]

and therefore
$v_p(n)\mathbin{\dotminus}\kappa_p(n,k)\le v_p(k)$. Thus

\[
 \boxed{W_n(k)\mid k}. \tag{2}
\]

## 2. Largest-prime witness and numerical threshold

Since $n$ is composite and $P\mid n$, writing $n=Pc$ gives $c\ge2$.
Consequently $1<P\le n/2$, so $k=P$ is admissible. Lucas' theorem gives

\[
 \binom{n-1}{P-1}\equiv1\pmod P.
\]

Using

\[
 \binom nP=\frac nP\binom{n-1}{P-1},
\]

we obtain

\[
 \gcd\!\left(n,\binom nP\right)=\frac nP.
\]

Equation (1), followed by positive cancellation, now gives

\[
 \boxed{W_n(P)=P}. \tag{3}
\]

Set $q=n/P$. We claim

\[
 f(n)=q
 \quad\Longleftrightarrow\quad
 W_n(k)\le P\text{ for every admissible }k. \tag{4}
\]

If $f(n)=q$, then $q\le G_k$ for every admissible $k$. If some
$W_n(k)>P$, then

\[
 n=qP<qW_n(k)\le G_kW_n(k)=n,
\]

a contradiction. Conversely, suppose every $W_n(k)\le P$. If some
$G_k<q$, positivity gives

\[
 n=G_kW_n(k)<qW_n(k)\le qP=n,
\]

again impossible. Hence every $G_k\ge q$, while (3) supplies the admissible
witness $G_P=q$. The finite minimum is therefore $q$. Notice that (4) uses
the **numerical** order on the complementary weights, not componentwise
order on prime exponents.

## 3. The boundary antichain

Fix a divisor $W\mid n$. Then

\[
 W>P
 \quad\Longleftrightarrow\quad
 \exists d\mid W\;\operatorname{Boundary}(n,d). \tag{5}
\]

For the forward implication, among divisors of $W$ exceeding $P$, choose a
numerically least one, $d$. Then $d\mid n$ and $P<d$. If $p\mid d$, the
proper divisor $d/p$ also divides $W$; minimality forces $d/p\le P$.
Thus $d$ is a boundary divisor. The converse follows immediately from
$d\mid W$ and $d>P$.

This is the divisibility-minimal antichain step. It is not an assertion that
the prime-exponent vectors are componentwise minimal.

## 4. Divisibility by a boundary divisor is exactly the carry budget

Let $d\mid n$ and let $p\mid d$. Write

\[
 a=v_p(n),\qquad b=v_p(d)>0,
 \qquad c=\kappa_p(n,k).
\]

Because $d\mid n$, $b\le a$, and elementary natural-subtraction arithmetic
gives

\[
 b\le a\mathbin{\dotminus}c
 \quad\Longleftrightarrow\quad
 c\le a-b. \tag{6}
\]

Applying (6) at every prime of $d$ yields

\[
 d\mid W_n(k)
 \quad\Longleftrightarrow\quad
 \forall p\mid d,
 \ \kappa_p(n,k)\le v_p(n)-v_p(d). \tag{7}
\]

No signed deficit has been substituted for the truncated exponent. The
hypotheses $p\mid d$ and $d\mid n$ are what make (6) valid in exactly the
needed form.

## 5. Realization is the admissible common-multiplier condition

For a boundary divisor $d$,

\[
 \operatorname{Realized}(n,d)
 \quad\Longleftrightarrow\quad
 \exists k\ (2\le k\le\lfloor n/2\rfloor\ \land\ d\mid W_n(k)). \tag{8}
\]

Indeed, if the right side holds, (2) gives $d\mid k$, so $k=dm$. Since
$k>0$, $m>0$; the endpoint condition is exactly
$dm\le\lfloor n/2\rfloor$, and (7) supplies all carry budgets. Conversely,
a witness $m>0$ in `Realized` gives $k=dm$. Since
$d>P\ge2$, we have $k>1$; the stated inequality makes $k$ admissible, and
(7) gives $d\mid W_n(k)$. Equality at $k=n/2$ is retained.

## 6. Completion of both directions

Combining (5) and (8),

\[
 \begin{aligned}
 &W_n(k)\le P\text{ for every admissible }k\\
 &\qquad\Longleftrightarrow
 \text{no boundary divisor of }n\text{ is realized}\\
 &\qquad\Longleftrightarrow \operatorname{BoundarySafe}(n).
 \end{aligned}
\]

Together with (4), this proves the theorem.

## Quantifier and independence check

The proof uses every $k$ with $1<k\le n/2$, including the endpoint. Every
boundary divisor must be safe, every prime divisor of a realized boundary
must meet its own budget, and the same positive multiplier $m$ must satisfy
all those budgets. The right-hand predicate uses only divisibility,
factorization, the largest prime factor, floor division, and residue carry
counts; it does not mention $f$, gcds, binomial coefficients, or the upstream
open theorem.
