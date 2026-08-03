# Alternative unconditional route using only the prime number theorem

This route is preferable for Lean because a compatible formal PNT already
exists. It eliminates Maynard's theorem from the dependency graph.

## Prime-density lemma

Let \(\pi(x)\) count primes at most \(x\). The prime number theorem implies
\[
\pi(2N)-\pi(N)\sim \frac{N}{\log N}. \tag{1}
\]

For a positive integer \(T\), set
\[
N=8T^3,\qquad L=T,\qquad J=8T^2.
\]
Partition \([N,2N)\) into the \(J\) half-open integer intervals
\[
I_j=[N+jT,N+(j+1)T),\qquad 0\le j<J.
\]
By (1), the number of primes in \([N,2N)\) eventually exceeds
\[
J(\lfloor\log_2 T\rfloor+2),
\]
because
\[
\frac{N/\log N}{T^2\log T}\asymp\frac{T}{(\log T)^2}\longrightarrow\infty.
\]
Therefore, for every sufficiently large \(T\), some \(I_j\) contains more than
\(\lfloor\log_2T\rfloor+2\) primes.

## Finite combinatorial lemma

Let
\[
x_0<x_1<\cdots<x_{m-1}
\]
be integers in an interval of length \(T\). If no three indices \(i<j<k\)
satisfy
\[
x_k-x_j>x_j-x_i, \tag{2}
\]
then
\[
2^{m-2}\le x_{m-1}-x_0<T. \tag{3}
\]

Indeed, put \(S_j=x_{m-1}-x_j\). Applying the failure of (2) to
\((j,j+1,m-1)\) gives
\[
S_{j+1}\le x_{j+1}-x_j.
\]
Consequently
\[
S_j=(x_{j+1}-x_j)+S_{j+1}\ge2S_{j+1}.
\]
Iteration and \(S_{m-2}\ge1\) give (3).

Thus any interval of length \(T\) containing more than
\(\lfloor\log_2T\rfloor+2\) primes contains primes \(p<q<r\) satisfying
\[
r-q>q-p.
\]

## Application to the structural lemma

For the prime triple obtained above, put
\[
a=q-p,\qquad c=r-q,\qquad b=a+c=r-p.
\]
Then \(c>a>0\), and because all three primes lie in one half-open interval of
length \(T\),
\[
b<T.
\]
Also \(p\ge N=8T^3\), so
\[
4b^3<4T^3<8T^3\le p.
\]
The independently audited structural lemma therefore gives
\[
f(pqr)=pq,\qquad f(pqr)^2>pqr.
\]

As \(T\) is arbitrarily large and \(pqr\ge(8T^3)^3\), the resulting products
are unbounded. Hence the target set is infinite.

## Lean dependency audit

The compatible PrimeNumberTheoremAnd checkpoint is
`00737ce40d3ba12a58e63d7eca65563fb9860f7c`. It and pinned Formal Conjectures
use:

- Lean `v4.27.0`;
- Mathlib `a3a10db0e9d66acbebf76c5e6a135066525ac900`.

At that checkpoint,
`PrimeNumberTheoremAnd.Consequences.pi_alt'` states
\[
\bigl(x\mapsto\pi(\lfloor x\rfloor)\bigr)
\sim
\bigl(x\mapsto x/\log x\bigr).
\]

Compiled command:

```text
lake env lean CheckPntAxioms.lean
```

Kernel output:

```text
'pi_alt'' depends on axioms: [propext, Classical.choice, Quot.sound]
```

Although other files in that research repository contain unrelated `sorry`
declarations, the PNT theorem's transitive proof term does not depend on
`sorryAx`.
