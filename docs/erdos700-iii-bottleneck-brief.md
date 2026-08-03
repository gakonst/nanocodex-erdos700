# Erdős 700(iii): technical bottleneck brief

## Problem

For composite \(n>1\), define

\[
f(n)=\min_{1<k\le n/2}\gcd\!\left(n,\binom nk\right),
\qquad
D_n(k)=\frac{n}{\gcd(n,\binom nk)},
\qquad
D(n)=\max_{2\le k\le n/2}D_n(k).
\]

Part (iii) asks whether, for every real \(A>0\), there is a constant
\(C_A>0\), independent of \(n\), such that

\[
f(n)\le C_A\frac{n}{(\log n)^A}.
\]

Equivalently, for every \(A>0\), there is \(c_A>0\) such that

\[
D(n)\ge c_A(\log n)^A
\]

for every composite \(n>1\). The Erdős Problems card and the retained
Erdős--Szekeres source were recorded as still treating this question as open
in July 2026.

## Exact local language

Write

\[
n=\prod_{p\mid n}p^{a_p}.
\]

For every legal row \(k\), put

\[
d_p(k)=\left(a_p-v_p\binom nk\right)_+.
\]

Then the objective has the exact weighted form

\[
\boxed{\quad
\log D_n(k)=\sum_{p\mid n}d_p(k)\log p.
\quad}
\]

Kummer identifies \(v_p\binom nk\) with the number of base-\(p\) carries.
If \(q=p^a\parallel n\) and \(q\mid k\), scaling gives

\[
v_p\binom nk=v_p\binom{n/q}{k/q},
\qquad
d_p(k)=\left(a-v_p\binom{n/q}{k/q}\right)_+.
\]

Every endpoint must use the literal right-closed index. Replacing
\(\lfloor(k-1)/q\rfloor\) by \(\lfloor k/q\rfloor\) in the corresponding
block formulas is generally false.

## What has actually been proved

1. **Exact residual decomposition.** The hard case has many low-height exact
   prime-power components. After ordering and pigeonholing, one obtains a
   homogeneous dyadic packet of large prime bases. The strict component cap,
   high-height mass bound, integral-\(A\) endpoint, and row legality have been
   audited.

2. **Deep-prefix escape.** For every selected fixed-size subset, explicit CRT
   rows can suppress carries through
   \(\Omega_A(\log n/\log\log n)\) digit levels. Any genuine obstruction must
   recur in the remaining deep tail; a bounded-prefix counterexample cannot
   work.

3. **Exact effective conductor.** For
   \[
   \mathcal A=\{0\le z<p^D:z\le T,\ v_p\binom Tz<s\}
   \]
   and \(\Delta=p^D-T\), the least residue conductor is
   \[
   E=
   \begin{cases}
   0,&\Delta=1,\\
   \min(D,\lceil\log_p\Delta\rceil+s-1),&\Delta>1.
   \end{cases}
   \]
   This replaces an abstract tail period by an exact top-gap statistic.

4. **Structured blockers are limited.** Exact power-word anchors in one
   short prime packet have pairwise-coprime exponents. Their number is
   \[
   O_A\!\left(
      \frac{\log n\,\log\log\log n}{(\log\log n)^3}
   \right),
   \]
   which is smaller than the packet scale. A separate cyclotomic argument
   excludes one sparse four-digit endpoint architecture for fixed \(A<2\).
   Neither result classifies all hostile words.

5. **Conditional transfer.** A single legal row with retained weighted depth
   \[
   \sum_{p\mid n}d_p(k)\log p
   \ge A\log\log n-O_A(1)
   \]
   proves the target. The commonly used upper-half first-layer condition is a
   stronger special case, not an equivalent formulation.

These are partial results. There is no unconditional Part (iii) proof,
counterexample, or Lean candidate.

## The current load-bearing questions

### 1. Weighted-depth preservation

Find a legal row-construction or factor-peeling operation satisfying a
quantitative statement of the following kind:

> From a row with retained weight \(W\), move within an explicit legal
> progression to gain a new prime-power layer while losing at most a
> controlled fraction of \(W\).

A finite iteration must yield

\[
\sum_{p\mid n}d_p(k)\log p
\ge A\log\log n-O_A(1).
\]

This is weaker than finding \(m=\lceil A\rceil\) distinct supported primes:
several layers may come from one component and no fixed subset is prescribed.

### 2. The exponent-one pair problem

For \(1<A\le2\), the hard packet is squarefree and depth concentration gives
no extra slack. The core pair statement is:

> Given the actual common cofactor and a sufficiently large packet of primes,
> find distinct \(p,q\) and one literal legal multiplier \(u\) satisfying the
> two simultaneous all-digit Lucas inequalities.

A promising proof shape is an inverse theorem: long affine avoidance forces
the upper word into a low-complexity sparse/near-power class, after which
determinant, cyclotomic, or \(S\)-unit separation shows that only
\(o(|W|)\) packet primes can be hostile for the same \(n\).

### 3. Direct all-row contradiction

Assume every legal row has subthreshold weighted depth. Derive a deterministic
contradiction by averaging or composing the exact \(d_p(k)\), without
multiplying marginal success probabilities. A useful theorem must preserve
one literal \(k\); separate witnesses at different primes or scales do not
combine automatically.

## Routes that should not be retried unchanged

- multiplying marginal carry-free densities;
- a fixed finite menu of component-product or co-divisor rows;
- bounded-prefix CRT obstructions;
- complete-period equidistribution when the legal interval is exponentially
  shorter than the joint period;
- ordinary large-sieve bounds after taking absolute values;
- abstract set-cover or fractional-cover arguments without arithmetic input;
- copying a successful row across a changed ambient cofactor;
- excluding only the coordinatewise unit-lock residue;
- ordinary polynomial height, low-degree resultants, or symmetric power sums
  applied to the entire hypergraph lock;
- naive iteration of the published \(A=1\) witness while requiring the same
  row at every scale.

Each of these has an explicit retained countermodel or quantifier failure.

## Computational game selection

`experiments/erdos700_extremal.py` constructs large, exactly factored
residuals and retains only instances passing the strict component cap,
high-height mass, and upper-half gates. It scores rows with exact truncated
Legendre valuations and compares:

- uniform and midpoint rows;
- component/base products;
- divisor and cofactor rows;
- adaptive multipliers;
- weighted-depth hill climbing.

The experiment is designed to discover whether winning depth concentrates,
spreads, or comes from an unanticipated row family. Finite output is not
evidence for the asymptotic theorem.

## What would be most useful from a specialist

We would value one of:

1. a carry-preserving factor-composition theorem for the weighted objective;
2. an inverse theorem for a long affine progression avoiding a Lucas
   digit-downset in a growing base;
3. a diagonal, moving-base sparse-sum separation theorem with explicit enough
   constants for bases \(p\asymp\log n\);
4. an all-row obstruction or example showing that weighted-depth
   preservation is false;
5. identification of a primary-source theorem already implying one of these.

## Evidence map

- Immutable target: `campaigns/problems/erdos-700-iii.md`
- General conditional transfer: retained remote campaign
  `math-1785005284-4146904`
- Exact conductor theorem: retained remote campaign
  `math-1785009968-4160866`
- Pair and hostile-word analyses: retained remote campaigns
  `math-1785010372-4161735` and `math-1785012022-4186126`
- Smooth-cofactor and global-lock audits: retained remote campaigns
  `math-1785012022-4186125` and `math-1785012022-4186127`
- Formalized Parts (i) and (ii): `proof/`
