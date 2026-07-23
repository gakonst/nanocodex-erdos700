# Source audit for the Maynard input

Primary source:

- James Maynard, “Small gaps between primes,” *Annals of Mathematics* 181
  (2015), 383–413, DOI 10.4007/annals.2015.181.1.7.
- Stable article page:
  <https://annals.math.princeton.edu/2015/181-1/p07>
- Publisher PDF:
  <https://annals.math.princeton.edu/wp-content/uploads/annals-v181-n1-p07-p.pdf>
- Preprint:
  <https://arxiv.org/abs/1311.4600>

## Exact mapping

The paper defines an admissible set on page 383 and fixes an arbitrary
admissible set \(\mathcal H=\{h_1,\ldots,h_k\}\) in Sections 2–4.

Proposition 4.2 states that if the primes have a positive level of
distribution, then for an admissible \(\mathcal H\), infinitely many
translates contain at least
\[
r_k=\left\lceil \theta M_k/2\right\rceil
\]
primes.

Proposition 4.3 gives
\[
M_k>\log k-2\log\log k-2
\]
for sufficiently large \(k\). The paper then invokes the unconditional
Bombieri--Vinogradov level \(\theta=1/2-\varepsilon\) and concludes on page 391:
for any admissible \(k\)-element set with \(k\ge C m^2e^{4m}\), at least
\(m+1\) translated entries are prime for infinitely many translating
integers.

The application in `proof.md` takes \(m=2\), so the conclusion is at least
three primes. This corrects the informal worker shorthand `K(3)`: in the
paper's displayed parametrization, `m = 2` yields `m + 1 = 3`.

## What is and is not being used

- Used: an arbitrary *fixed* sufficiently large admissible tuple contains at
  least three primes for infinitely many translates.
- Not used: the prime \(k\)-tuples conjecture for the entire tuple.
- Not used: Elliott--Halberstam, Dickson, Bateman--Horn, or a prescribed
  three-prime pattern.
- The tuple and every one of its offsets are fixed before the translate tends
  to infinity, as required by Maynard's setup.

Independent source and novelty audit run: `math-1784832830-1919956` on
`dev-georgios`. Its eventual report supersedes this preliminary mapping if it
identifies a quantifier mismatch.
