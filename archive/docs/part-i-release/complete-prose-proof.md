# Complete prose proof of the modern structural characterization

## Theorem

Let $n>1$ be composite, let $P=P(n)$ be the largest prime divisor of
$n$, and use the definitions of `Boundary`, `Realized`, and `BoundarySafe`
in `problem.md`. Then

\[
 f(n)=\frac nP\quad\Longleftrightarrow\quad
 \mathrm{BoundarySafe}(n).
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
 \exists d\mid W\;\mathrm{Boundary}(n,d). \tag{5}
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
 \mathrm{Realized}(n,d)
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
 &\qquad\Longleftrightarrow \mathrm{BoundarySafe}(n).
 \end{aligned}
\]

Together with (4), this proves the theorem.

## 7. Semantic factor tableau

The boundary predicate is the proof-theoretic bridge, not the final compact
presentation. Fix an ordered exact factorization

\[
n=\prod_{i=1}^{r}p_i^{a_i}
\]

and a baseline \(B\). Select exponents \(0\le e_i\le a_i\) and one positive
integer \(T\), and put

\[
d=\prod_i p_i^{e_i},\qquad K=dT.
\]

The semantic factor tableau requires

\[
B<d,\qquad K\le \lfloor n/2\rfloor,
\]

and, for every active prime \(p_i\) with \(e_i>0\),

\[
\frac{d}{p_i}\le B,
\qquad
\kappa_{p_i}(n,K)\le a_i-e_i. \tag{9}
\]

The selected product \(d\) is therefore a boundary divisor and the same row
\(K=dT\) realizes all its carry budgets. Conversely, a realized boundary
divisor supplies its exponent vector and its common multiplier. Hence

\[
\mathrm{FactorTableauFeasible}(n,B)
\Longleftrightarrow
\exists d\,
  (\mathrm{BoundaryAt}(n,B,d)\land\mathrm{Realized}(n,d)).
\tag{10}
\]

This is the checked theorem
`factorTableauFeasible_iff_exists_boundary_realized`.

## 8. Compact synchronized integer/Boolean compiler

Let \(F\) be the supplied ordered factorization of \(n\). The explicit system
\(G(F,B)\) replaces the semantic objects above by finite integer and Boolean
fields:

1. one-hot selectors choose each exponent \(e_i\);
2. prefix-product variables construct \(d\) and the one shared row \(K=dT\);
3. digit variables expand that same \(K\) in every base \(p_i\);
4. Boolean borrow variables encode subtraction of \(K\) from \(n\);
5. boundary and budget rows enforce (9) for active primes and use checked
   inactive bounds for unselected primes.

There is no multiplication of two free integer variables. Selected prime
powers are fixed coefficients, and each local borrow row is a signed linear
inequality whose Boolean outgoing borrow is true exactly when the subtraction
borrows. Summing the outgoing borrows gives the Kummer carry count.

Soundness decodes a satisfying assignment into the selected exponent vector,
the exact prefix products, the common multiplier, and the genuine carry
budgets. Completeness starts from a semantic tableau and fills every field
with its canonical selector, prefix, base digit, and borrow value. Therefore
Lean proves

\[
\boxed{
G(F,B)
\Longleftrightarrow
\mathrm{FactorTableauFeasible}(n,B).}
\tag{11}
\]

The exact declaration is
`Erdos700PartI.ExplicitG.explicitG_iff_factorTableauFeasible`.

Combining (4), (10), and (11), for every composite \(n>1\), gives the compact
headline form

\[
\boxed{
f(n)=\frac{n}{P(n)}
\Longleftrightarrow
\neg G(F,P(n)).}
\tag{12}
\]

This system does not enumerate the possible multipliers. Its indexed
selector, digit, borrow, and prefix coordinates are linear in

\[
\sum_i(a_i+1)+\sum_i(\lfloor\log_{p_i}n\rfloor+1)+r.
\]

There are \(O((\log n)^2)\) such coordinates, and the fixed coefficients have
\(O(\log n)\) bits, yielding an \(O((\log n)^3)\) direct sparse description.
This is a compact symbolic characterization. It does not assert a
polynomial-time feasibility algorithm or a short enumeration of factorization
families.

## Quantifier and independence check

The proof uses every $k$ with $1<k\le n/2$, including the endpoint. Every
boundary divisor must be safe, every prime divisor of a realized boundary
must meet its own budget, and the same positive multiplier $m$ must satisfy
all those budgets. The boundary right-hand predicate uses only divisibility,
factorization, the largest prime factor, floor division, and residue carry
counts. The compiled right-hand system goes further: it replaces the semantic
carry count by explicit digits and Boolean borrows. Neither form mentions
$f$, gcds, binomial coefficients, or the upstream open theorem.
