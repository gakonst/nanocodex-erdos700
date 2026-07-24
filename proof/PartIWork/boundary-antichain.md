# Boundary-antichain characterization of Erdős 700(i)

Let

\[
f(n)=\min_{1<k\le n/2}\gcd\!\left(n,\binom nk\right)
\]

and let \(P(n)\) be the largest prime factor of a composite integer \(n>1\).
For each prime \(p\), let \(C_p(n,k)\) be the number of base-\(p\) carries in
\(k+(n-k)\). Define the complementary carry weight

\[
W_n(k)=\prod_{p\mid n}
  p^{\left(v_p(n)-C_p(n,k)\right)_+}.
\]

Kummer's theorem and unique factorization give

\[
\gcd\!\left(n,\binom nk\right)W_n(k)=n.
\tag{1}
\]

The checked largest-prime witness has

\[
1<P(n)\le n/2,\qquad W_n(P(n))=P(n).
\tag{2}
\]

Consequently,

\[
f(n)=\frac{n}{P(n)}
\quad\Longleftrightarrow\quad
W_n(k)\le P(n)\text{ for every }1<k\le n/2.
\tag{3}
\]

## Boundary divisors

A divisor \(d\mid n\) lies in the boundary when

\[
P(n)<d
\quad\text{and}\quad
\frac d p\le P(n)\text{ for every prime }p\mid d.
\tag{4}
\]

Condition (4) says exactly that \(d\) is divisibility-minimal among the
divisors of \(n\) that are numerically greater than \(P(n)\). Necessity follows
by deleting one prime factor. Conversely, every proper divisor \(e\mid d\)
divides \(d/p\) for some prime \(p\mid d\), so (4) forces \(e\le P(n)\).
This argument includes repeated prime powers.

A boundary divisor \(d\) is realized when there is an integer \(m>0\) such
that

\[
dm\le n/2
\tag{5}
\]

and, for every prime \(p\mid d\),

\[
C_p(n,dm)\le v_p(n)-v_p(d).
\tag{6}
\]

The right side of (6) is ordinary subtraction because \(d\mid n\).

## Divisibility bridges

For every admissible \(k\),

\[
W_n(k)\mid k.
\tag{7}
\]

Indeed,

\[
k\binom nk=n\binom{n-1}{k-1},
\]

so \(n\mid k\binom nk\). Comparing prime valuations and using (1) gives
\(v_p(W_n(k))\le v_p(k)\) for every prime \(p\).

For every positive divisor \(d\mid n\),

\[
d\mid W_n(k)
\quad\Longleftrightarrow\quad
C_p(n,k)\le v_p(n)-v_p(d)
\text{ for every prime }p\mid d.
\tag{8}
\]

At a prime \(p\mid d\), put \(a=v_p(n)\), \(b=v_p(d)\), and
\(c=C_p(n,k)\). Since \(0<b\le a\),

\[
b\le(a-c)_+
\quad\Longleftrightarrow\quad
c\le a-b.
\]

This proves (8), including the cases where the carry count exceeds \(a\).
Thus realization is exactly the existence of an admissible multiple \(dm\)
for which \(d\mid W_n(dm)\).

## Proof of the characterization

Assume first that \(W_n(k)\le P(n)\) for every admissible \(k\). If a boundary
divisor \(d\) were realized by \(m\), then (5) and \(d>P(n)\ge2\) would make
\(k=dm\) admissible. Equations (6) and (8) would give \(d\mid W_n(k)\), hence

\[
W_n(k)\ge d>P(n),
\]

a contradiction.

Conversely, suppose no boundary divisor is realized. If an admissible \(k\)
had \(W_n(k)>P(n)\), choose a divisibility-minimal divisor \(d\mid W_n(k)\)
above \(P(n)\). Equation (1) implies \(W_n(k)\mid n\), so \(d\mid n\), and
minimality makes \(d\) a boundary divisor. Equation (7) gives \(d\mid k\);
write \(k=dm\). Admissibility gives \(m>0\) and \(dm\le n/2\), while (8)
supplies all realization inequalities. This realizes \(d\), again a
contradiction.

Combining this equivalence with (3) proves

\[
\boxed{
f(n)=\frac{n}{P(n)}
\quad\Longleftrightarrow\quad
\text{no boundary divisor of \(n\) is realized}.
}
\]

The right side contains neither \(f\), a gcd, nor a binomial coefficient. It
is an exact finite characterization in terms of the factorization of \(n\)
and explicit prime-power carry tests.

## Scope

This theorem is a complete exact characterization and a finite decision
procedure. It does not provide a closed factorization-only list of every
equality case: realization can require a nontrivial multiplier, and its
cross-base digit conditions are genuine arithmetic structure. Any public
claim should distinguish the checked equivalence from the stronger,
subjective expectation of a simple taxonomy of factorizations.
