# Exact normalized digit-shadow/CRT upgrade

This is a proved strengthening of the raw multiplier formulation of
`Realized`. It is an exact finite-congruence normal form, not a closed-form
classification.

## Normalization lemma

Fix $d\mid n$, put $C=n/d$ and $M=\lfloor C/2\rfloor$. Then
$dm\le n/2$ is exactly $1\le m\le M$.

For each prime $p\mid d$, write

\[
 e=v_p(d),\qquad c=d/p^e,\qquad A=v_p(C),
 \qquad N=cC=n/p^e.
\]

Deleting the common $e$ trailing base-$p$ zero digits from $n$ and $dm$
gives

\[
 \kappa_p(n,dm)=\kappa_p(N,cm). \tag{1}
\]

This handles repeated powers exactly; it is not a squarefree reduction.

## Periodic digit shadow

Let $h$ be the largest integer with $p^h\le N$ (take $h=0$ when $N<p$),
and define

\[
 F_p(m)=\sum_{i=1}^{h}
 \mathbf 1[cm\bmod p^i>N\bmod p^i].
\]

For $1\le m\le M$, Kummer's residue criterion and (1) give
$F_p(m)=\kappa_p(n,dm)$. No layer above $h$ can carry because
$0<cm\le N/2<N<p^i$. The function $F_p$ is periodic modulo
$q_p=p^h$.

Let

\[
 E_p(m)=[F_p(m)\le A].
\]

Its exact least period has the form $p^{t_p}$, where $t_p$ is the least
$0\le t\le h$ for which $E_p$ is constant on every residue class modulo
$p^t$ inside one $p^h$ table. Define the accepted classes

\[
 R_p=\{r\in\mathbb Z/p^{t_p}\mathbb Z:E_p(r)=1\}.
\]

Then

\[
 \{1\le m\le M:\kappa_p(n,dm)\le A\}
 =\{1\le m\le M:m\bmod p^{t_p}\in R_p\}. \tag{2}
\]

The integer definition of $h$ is essential; no floating-point logarithm is
part of the theorem. If $t_p=0$, the modulus is $1$ and the sole residue is
the zero class.

## Exact CRT realization criterion

The moduli $p^{t_p}$ for distinct $p\mid d$ are pairwise coprime. Put

\[
 Q=\prod_{p\mid d}p^{t_p}.
\]

For each tuple $r=(r_p)\in\prod_{p\mid d}R_p$, let
$\rho(r)\in\{0,\ldots,Q-1\}$ be its CRT representative, and set

\[
 \lambda(r)=
 \begin{cases}
  \rho(r),&\rho(r)>0,\\
  Q,&\rho(r)=0.
 \end{cases}
\]

The replacement of zero by $Q$ is forced because the multiplier must be
positive. Combining (2) for all primes yields the exact theorem

\[
 \boxed{
 \operatorname{Realized}(n,d)
 \Longleftrightarrow
 \min_{r\in\prod R_p}\lambda(r)\le M.}
\]

This produces finite realization and nonrealization certificates from the
factorization data, local truth tables, and CRT representatives. One may
choose the sparsest local accepted list and filter it by the other primes,
often avoiding a scan of every $m\le M$.

## Counterexamples to stronger simplifications

The reduction is not uniformly small. For

\[
 n=p^{r+2},\qquad d=p^2,\qquad r\ge1,
\]

the sole carry budget is $r$ and there are only $r$ possible carry layers,
so every $1\le m\le\lfloor p^r/2\rfloor$ is locally accepted. Thus local
digit shadows alone can retain the full multiplier range.

The global common-multiplier condition also cannot be split prime by prime:
the accepted residues for distinct bases must be satisfied by one $m$. The
case $(450,10)$ makes this visible. The binary zero-carry constraint forces
$5m=65$, hence $m=13$; the base-5 carry budget then also passes. No smaller
$m$ is realized.

## Status

The theorem above was independently line-audited by a fresh adversary and was
also checked in the bounded scan through $n=1000$. It is a genuine exact
algorithmic normal form and exposes the cross-base obstruction. It does not
eliminate the multiplier/CRT-tuple search in the worst case and therefore is
not promoted as a complete factorization classification.
