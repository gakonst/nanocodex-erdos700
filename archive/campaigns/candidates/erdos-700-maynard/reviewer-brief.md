# Reviewer brief: candidate solution of Erdős 700(ii)

Claim: there are infinitely many composite \(n\) such that
\[
\left(\min_{1<k\le n/2}\gcd\!\left(n,\binom nk\right)\right)^2>n.
\]

The complete argument is in `proof.md`. The proof has two independently
checkable pieces.

## A. Elementary structural lemma

Let \(p<q<r\) be primes with
\[
q=p+a,\qquad r=q+c,\qquad c>a>0,\qquad b=a+c,
\]
and suppose \(p>4b^3\). For \(n=pqr\), Lucas's theorem and the genuine base
expansions
\[
qr=ab+(a+b)p+p^2,
\]
\[
pr=(q-ac)+(c-a-1)q+q^2,
\]
\[
pq=bc+(p-c)r
\]
show that no two of \(p,q,r\) can simultaneously be absent from
\(\binom nk\) for \(0<k\le n/2\). Hence every relevant gcd is at least \(pq\).
At \(k=r\) it is exactly \(pq\), so \(f(pqr)=pq\), and \(pq>r\) gives
\(f(pqr)^2>pqr\).

The main audit target is the carry/borrow normalization in the three
pair-omission cases. All three have separately passed adversarial
reconstruction, and a blind proof found an equivalent congruence argument.

## B. Unconditional infinitude

Choose \(K\) large enough for Maynard's theorem with parameter \(m=2\), put
\[
W=\prod_{\ell\le K,\ \ell\ {\rm prime}}\ell,\qquad
h_i=W(2^i-1)\quad(0\le i<K).
\]
This is admissible. Maynard's Proposition 4.2 plus Proposition 4.3 and
Bombieri--Vinogradov imply that infinitely many translates contain at least
three primes.

For every \(i<j<\ell\),
\[
h_j-h_i<W2^j\le h_\ell-h_j,
\]
so any selected prime triple has \(r-q>q-p\). A fixed index triple occurs
infinitely often; its gaps are fixed while its first prime tends to infinity.
The structural lemma therefore eventually applies.

## Five questions for an independent reviewer

1. Is the shifted Lucas criterion
   \[
   s\nmid\binom nk\iff s\mid k\ \text{and}\ k/s\preceq_s n/s
   \]
   being used correctly for each \(s\mid pqr\)?
2. Are the quotient/remainder carry checks in all three pair cases complete?
3. Does the witness \(k=r\) indeed give gcd exactly \(pq\)?
4. Does Maynard's page-391 conclusion quantify over every fixed admissible
   sufficiently large tuple, rather than merely asserting existence of one?
5. Does finite pigeonhole over the selected index triples correctly yield one
   fixed gap pattern occurring for unbounded translates?

Primary source:
<https://annals.math.princeton.edu/wp-content/uploads/annals-v181-n1-p07-p.pdf>.
