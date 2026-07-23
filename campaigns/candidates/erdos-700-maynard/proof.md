# Candidate solution of Erdős problem 700(ii)

Status: complete candidate proof; independent structural and source audits are
still running. This file must not yet be described as an accepted or formally
verified solution.

For
\[
f(n)=\min_{1<k\le n/2}\gcd\!\binom nk,n,
\]
we prove that there are infinitely many composite \(n\) for which
\(f(n)^2>n\).

## 1. Lucas criterion

Write \(u\preceq_s v\) if every base-\(s\) digit of \(u\) is at most the
corresponding digit of \(v\). Lucas's theorem gives, for a prime \(s\),
\[
s\nmid\binom nk\quad\Longleftrightarrow\quad k\preceq_s n.
\]
When \(s\mid n\), the units digit on the right is zero. Consequently
\[
s\nmid\binom nk
\quad\Longleftrightarrow\quad
s\mid k\ \hbox{ and }\ k/s\preceq_s n/s. \tag{1}
\]

## 2. Structural lemma

Let
\[
q=p+a,\qquad r=q+c=p+a+c,\qquad b=a+c,
\]
where \(p<q<r\) are primes, \(c>a>0\), and \(p>4b^3\). Put \(n=pqr\).
Then, for every \(0<k\le n/2\), at most one of \(p,q,r\) fails to divide
\(\binom nk\).

The following are valid base expansions, with digits listed algebraically from
the units digit upward:
\[
qr=ab+(a+b)p+p^2, \tag{2}
\]
\[
pr=(q-ac)+(c-a-1)q+q^2, \tag{3}
\]
\[
pq=bc+(p-c)r. \tag{4}
\]
Indeed, \(a,c<b\), while \(p>4b^3\), so all displayed coefficients are
nonnegative and smaller than their respective bases.

Suppose first that both \(p\) and \(q\) fail to divide \(\binom nk\).
By (1), \(k=pqt\) for a positive integer \(t\), and
\[
qt\preceq_p qr,\qquad pt\preceq_q pr. \tag{5}
\]
The bound \(k\le n/2\) gives \(t\le r/2\). In base \(p\),
write \(at=up+v\), where \(u=\lfloor at/p\rfloor\) and \(0\le v<p\).
Then
\[
qt=v+(t+u)p,
\]
where \(t+u<p\): indeed \(t<p\), so \(u<a\), and
\[
t+u\le (p+b)/2+a-1<p
\]
because \(b+2a-2<3b<p\). Comparing with (2) first gives
\[
t+u\le a+b.
\]
It follows that \(at<p\); comparison of units in (2) now gives \(at\le ab\),
and hence \(t\le b\). Therefore \(at<q\), and
\[
pt=(q-at)+(t-1)q.
\]
Comparison with (3) gives both \(q-at\le q-ac\), hence \(t\ge c\), and
\(t-1\le c-a-1\), hence \(t\le c-a\). This is impossible.

Suppose next that both \(q\) and \(r\) fail to divide \(\binom nk\). Write
\(k=qrt\). From (1),
\[
rt\preceq_q pr,\qquad qt\preceq_r pq.
\]
Since \(t\le p/2\), write \(ct=uq+v\), with \(0\le v<q\). Here \(t+u<q\),
because \(t<q\), \(u<c\), and \(p/2+c<q\). Thus the genuine low base-\(q\)
digits of \(rt\) are
\[
rt=v+(t+u)q.
\]
Comparison with (3) gives
\[
t+u\le c-a-1,
\]
so \(t\le c-a-1\). In particular \(ct<r\), and
\[
qt=(r-ct)+(t-1)r.
\]
Its units digit must be at most the units digit in (4), so
\[
r-ct\le bc.
\]
But \(ct+bc<2b^2<p<r\), a contradiction.

Finally, suppose that both \(p\) and \(r\) fail to divide \(\binom nk\). Write
\(k=prt\). From (1),
\[
rt\preceq_p qr,\qquad pt\preceq_r pq.
\]
As \(t\le q/2\), write \(bt=up+v\), with \(0\le v<p\). Here \(t+u<p\),
because \(t<p\), \(u<b\), and \((p+a)/2+b-1<p\). Thus the genuine low
base-\(p\) digits of \(rt\) are
\[
rt=v+(t+u)p.
\]
Comparison with (2) first gives \(t\le a+b\). Thus \(bt<p\), and comparison of units
then gives \(bt\le ab\), so \(t\le a\). Now
\[
pt=(r-bt)+(t-1)r.
\]
Comparison of its units digit with (4) would imply
\[
r-bt\le bc,
\]
and hence \(r\le ab+bc=b^2\), contrary to \(r>p>4b^3\).
This proves the lemma.

Because \(n\) is squarefree, every relevant gcd therefore contains at least
two of \(p,q,r\), and is at least \(pq\). At \(k=r\), the primes \(p,q\)
divide \(\binom nr\), while \(r\) does not, so in fact
\[
f(pqr)=pq. \tag{6}
\]
Moreover,
\[
pq-r=p^2+(a-1)p-b>0,
\]
and (6) yields
\[
f(n)^2=p^2q^2>pqr=n. \tag{7}
\]

## 3. Producing infinitely many triples unconditionally

We use the following consequence of Maynard's multidimensional sieve. There is
an absolute constant \(C\) such that, for any \(m\) and any fixed admissible
set \(\mathcal H=\{h_1,\ldots,h_K\}\) with
\[
K\ge C m^2e^{4m},
\]
at least \(m+1\) of the integers \(x+h_i\) are prime for infinitely many
integers \(x\). This is the conclusion derived on page 391 of Maynard's paper
from Propositions 4.2 and 4.3. It is unconditional, using
Bombieri--Vinogradov.

Take \(m=2\), choose a sufficiently large \(K\), and set
\[
W=\prod_{\substack{\ell\le K\\ \ell\ {\rm prime}}}\ell,\qquad
h_i=W(2^i-1)\quad(0\le i<K).
\]
The \(h_i\) are distinct and nonnegative. This set is admissible: modulo a
prime \(\ell\le K\), all its elements are \(0\), so it misses every nonzero
class; modulo a prime \(\ell>K\), its \(K<\ell\) elements cannot cover all
residue classes.

Maynard's theorem therefore gives infinitely many \(x\) for which at least
three of the \(x+h_i\) are prime. There are only finitely many triples of
indices, so one triple \(i<j<\ell\) occurs for infinitely many such \(x\).
For that fixed triple put
\[
p=x+h_i,\qquad q=x+h_j,\qquad r=x+h_\ell.
\]
Writing \(a=q-p\) and \(c=r-q\), we have
\[
a=W2^i(2^{j-i}-1)<W2^j
\]
and
\[
c=W2^j(2^{\ell-j}-1)\ge W2^j.
\]
Thus \(c>a>0\). The gaps, and hence \(b=a+c\), are fixed. The infinitely many
distinct translating integers \(x\) are unbounded, so eventually
\(p>4b^3\). Every corresponding product \(n=pqr\) then satisfies (7), and
these products are unbounded. Hence there are infinitely many such composite
integers \(n\).

## Primary source

James Maynard, “Small gaps between primes,” *Annals of Mathematics* 181
(2015), 383–413, DOI 10.4007/annals.2015.181.1.7:
<https://annals.math.princeton.edu/wp-content/uploads/annals-v181-n1-p07-p.pdf>.

The exact arbitrary-fixed-admissible-set quantifier appears in Proposition 4.2
and in the deduction on page 391: for any admissible \(K\)-element set with
\(K\ge Cm^2e^{4m}\), at least \(m+1\) translated entries are prime infinitely
often.
