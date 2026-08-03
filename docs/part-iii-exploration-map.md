# Part (iii) exploration map

**Status (2026-07-28): no unconditional proof and no genuine target
counterfamily.**

This document is the durable synthesis of the Part (iii) campaign. It records
the exact target, the strongest proved reductions, the routes explored, the
failure certificates, and the current frontier. Runtime transcripts remain
under ignored `runs/` directories; this map retains only claims that survived
the campaign's internal audits.

This is also the canonical **do-not-retry ledger**. A route marked *killed*
must not be restarted from its slogan. It can be reopened only if the new
proposal supplies the extra input stated in its revival criterion. A
restricted lemma or finite example is retained as evidence, but is never
called progress on the full theorem.

## Target

Write

\[
D_n(k)=\frac{n}{\gcd(n,\binom nk)},\qquad
D(n)=\max_{2\le k\le n/2}D_n(k).
\]

The target is

\[
\forall A>0\ \exists c_A>0\ \forall n>1\text{ composite},\qquad
D(n)\ge c_A(\log n)^A.
\]

For \(n=\prod_{p\mid n}p^{a_p}\), define

\[
d_p(k)=\left(a_p-v_p\binom nk\right)_+.
\]

The one-row objective is exactly

\[
\log D_n(k)=\sum_{p\mid n}d_p(k)\log p.
\]

Every proposed proof must therefore produce one legal \(k\), not combine
different successful rows for different primes.

## Top-down idea tree

```text
Part (iii): D(n) >= c_A (log n)^A for every fixed A
│
├── 1. Remove regimes already controlled
│   ├── prime powers ........................................ PROVED
│   ├── one large exact prime-power component ............... PROVED
│   ├── bounded number of components ........................ PROVED
│   ├── high prime-power-height mass ........................ PROVED
│   └── strict residual case
│       └── many comparable, low-height components .......... REMAINS
│
├── 2. Construct one row directly
│   ├── largest-component row ............................... A=1 ONLY
│   ├── fixed finite multiplier/menu ........................ REFUTED
│   ├── recursively multiply component witnesses ............ REFUTED
│   ├── bounded-loss factor peeling/exchange ................ REFUTED LOCALLY
│   ├── fixed pair / pairwise Lucas alignment ............... OVERSTRONG
│   ├── upper-half full-layer packet (UHFL) ................. SUFFICIENT, OPEN
│   ├── arbitrary-height component packet
│   │   ├── exact valuation formula ......................... PROVED
│   │   └── instance-adaptive unbounded multiplier .......... OPEN
│   └── partial-layer weighted row .......................... TRUE TARGET, OPEN
│
├── 3. Force a row by averaging or correlation
│   ├── multiply marginal success probabilities ............. REFUTED
│   ├── abstract/fractional set cover ....................... REFUTED
│   ├── diffuse first or fixed moments ...................... TOO WEAK
│   ├── exceptional-row concentration ...................... NECESSITY PROVED
│   ├── factorial moments / Fourier expansions .............. IDENTITIES ONLY
│   ├── signed cross-prime energy ........................... OPEN
│   └── arithmetic same-row incidence theorem ............... OPEN
│
├── 4. Balanced-square laboratory n = Q^2
│   ├── full-depth subset-row classification ................ PROVED
│   ├── singleton gives the A=2 scale for that component .... PROVED
│   ├── constant-cardinality subset theorem ................. OPEN
│   ├── polynomial-size common tuner capacity (PWCC) ........ OPEN
│   └── transfer from Q^2 to arbitrary residual n ........... NOT PROVED
│
├── 5. Digit-box / affine inverse theory
│   ├── exact stabilizer criterion from Guo et al. .......... SOURCE RESULT
│   ├── quantitative prefix-fiber escape bound .............. PROVED-PARTIAL
│   ├── positive-density escape from box entropy ............ REFUTED
│   ├── sparse/near-power endpoint separation ............... PROVED-PARTIAL
│   └── embed local escapes into one actual Erdős row ........ OPEN
│
├── 6. Global invariant or all-row contradiction
│   ├── sublevel formulation H(x) ........................... EXACT EQUIVALENCE
│   │   └── prove H(x)=x^o(1) ............................... OPEN
│   ├── multiprime n divides lcm(1,...,D(n)) ................ PROVED
│   ├── prime-power sublevel branch ......................... EXPLICIT
│   ├── divisor-lattice monotonicity ........................ FALSE
│   ├── fixed cubic Carmichael bridge ....................... REFUTED
│   ├── growing Carmichael bridge ........................... QUARANTINED
│   ├── finite differences / determinant / resultant ........ INSUFFICIENT
│   └── global all-divisor product identity ................. OPEN
│
├── 7. Counterexample construction
│   ├── fixed-menu hostile residual families ................ METHOD ONLY
│   ├── one-escape digit boxes .............................. METHOD ONLY
│   ├── central-binomial smooth-component family ............ NO ALL-ROW BOUND
│   ├── CRT-hostile phase families .......................... METHOD ONLY
│   └── fixed A with D(n) = O((log n)^A) infinitely often ... NOT FOUND
│
└── 8. Current measurable frontier
    ├── beat D(n) >> log n by any explicit L(log n) -> ∞ .... OPEN
    ├── prove the fixed A=2 bound for all composite n ........ OPEN
    ├── prove an actual-phase same-multiplier capacity bound . OPEN
    └── construct a genuine target counterfamily ............ OPEN
```

## What was proved before the hard branch

The following reductions are reusable and should not be reproved in every
campaign:

1. \(D_n(k)\mid\gcd(n,k)\).
2. An exact component \(q=p^a\parallel n\) with \(n/q>1\) has the legal row
   \(k=q\) and \(D_n(q)=q\).
3. Prime powers satisfy the exact formula
   \[
   D(p^a)=p^{a-1}.
   \]
4. The largest exact component is \(\gg\log n\), giving the classical
   \(D(n)\gg\log n\) bound.
5. The target holds for \(0<A\le1\), bounded component count, sufficiently
   large largest component, and the audited high-height branch.
6. The unresolved residual branch can be decomposed into large homogeneous
   packets of low-height components.
7. The exact local objective is weighted retained \(p\)-adic depth at one row.

These facts reduce the problem but do not create the missing common row.

The beyond-\(A=1\) reset made the high-height branch quantitative. Put

\[
H_2(n)=\sum_{\substack{p^a\parallel n\\a\ge2}}a\log p.
\]

For all sufficiently large \(H_2(n)\), its argument proves

\[
D(n)\ge \frac{H_2(n)^2}{36}.
\]

Thus the fixed \(A=2\) target holds whenever
\(H_2(n)\ge\delta\log n\) for some fixed \(\delta>0\), including powerful
integers. This remains a restricted branch. The unresolved case is
squarefree-dominant.

There is also an all-height spectrum theorem. For

\[
N_h(n)=\prod_{\substack{p^a\parallel n\\a\ge h}}p^a,
\]

every integer with at least two distinct prime factors satisfies

\[
D(n)\ge
\left(\frac{\log N_h(n)}{13h}\right)^h.
\]

The \(h=2\) estimate above is sharper in its own range, but the spectrum
theorem records the exact residual requirement at every height.

## Route ledger

### Direct component and multiplier constructions

| Route                                       | Outcome                           | Failure certificate or surviving gap                                                                                                                |
| ------------------------------------------- | --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Largest component                           | Proves only \(A=1\)               | The lcm estimate supplies one component of size \(\gg\log n\), not arbitrary powers                                                                 |
| Naive recursive witness multiplication      | Refuted                           | At \(n=30\), the good rows for successive components combine to \(k=15\) with no retained gain                                                      |
| Fixed finite menu of component-product rows | Refuted at full residual strength | Infinite residual families can lock every prescribed bounded multiplier                                                                             |
| Bounded-loss adaptive factor peeling        | Refuted in its local form         | Adaptive-maximizer families show no uniform local preservation law                                                                                  |
| Height-uniform bounded menu                 | Refuted                           | For every fixed menu and height there are infinitely many residual instances where the singleton works but every menu extension loses the old depth |
| Instance-adaptive unbounded multiplier      | Not refuted                       | No theorem produces it with the required actual phases and legality                                                                                 |

The important lesson is not merely that a larger menu is needed. Any viable
construction must use the actual ambient integer and may need a multiplier
whose size grows with the instance.

### Pair, packet, and balanced-square routes

For \(N=Q^2\), the campaign obtained an exact classification of full-depth
subset rows \(k=uA_S^2\). This is a genuine theorem and a useful laboratory.
It did not establish the required subset or multiplier uniformly.

| Route                                                    | Outcome                                                         |
| -------------------------------------------------------- | --------------------------------------------------------------- |
| Prescribed successful pair                               | False in general                                                |
| Orient pair failure to one hostile base                  | False; \(n=29505\) has two nonempty but disjoint success sets   |
| Add one sacrificial tuner                                | Not a new degree of freedom; fixed-pair no-tuner families exist |
| Literal \(u=1\) pair in every dyadic packet              | Refuted for a growing chosen packet                             |
| Balanced-square full-depth row classification            | Proved                                                          |
| Constant-cardinality balanced subset                     | Open                                                            |
| Polynomial-size common tuner (`PWCC`)                    | Conditional reduction only                                      |
| Transfer balanced squares to arbitrary heights/cofactors | Open                                                            |

The balanced-square work exposes the exact linked residues and digit tests.
It does not establish that the balanced model controls the general residual
case.

### Averaging, moments, and exceptional rows

Uniform and diffuse distributions spread their mass over too many rows. In the
balanced-square model, any distribution capable of forcing the target mean
must place substantial mass on an exceptional row. This kills a large class
of “average the marginal carry-free probabilities” arguments.

| Route                                     | Outcome                                        |
| ----------------------------------------- | ---------------------------------------------- |
| Product of marginal Lucas probabilities   | Invalid: separate witnesses need not intersect |
| Abstract set/fractional cover             | Invalid without arithmetic same-row coupling   |
| Uniform first moment                      | Stops at the singleton/\(A=1\) scale           |
| Fixed higher moments                      | Insufficient without new ambient correlation   |
| Exceptional-row concentration lower bound | Proved-partial                                 |
| Signed actual-phase correlation           | Open                                           |

The exceptional-row theorem is quantitative. Put

\[
n_X=\left(\prod_{X<p\le2X}p\right)^2,\qquad
\rho_X(\mu)=|K_{n_X}|\max_k\mu(k).
\]

For every fixed integer \(r\ge1\), uniformly over probability measures
\(\mu\) on the legal rows,

\[
\mathbb E_\mu\log D_{n_X}(k)
\le
\log(2X)\left(
r-1+
O_r\!\left(\frac{\rho_X(\mu)}{(\log X)^r}\right)+
O\!\left(\frac{\rho_X(\mu)}{X\log X}\right)
\right).
\tag{ER}
\]

Consequently a mean of target size
\(A\log\log n_X-O_A(1)\) forces

\[
\rho_X(\mu)=
\Omega_A\!\left((\log\log n_X)^{\lceil A\rceil}\right).
\]

The actual target-size rows have relative density
\(O_A((\log X)^{-\lceil A\rceil})\). This scale is sharp for the
divisibility core: if \(N_X(k)\) counts interval primes dividing \(k\), then

\[
\frac{\#\{k:N_X(k)\ge m\}}{|K_{n_X}|}
\sim
\frac{(\log2)^m}{m!(\log X)^m}.
\tag{ER-core}
\]

Thus a successful averaging measure must deliberately localize on rare
high-order divisibility atoms. The same campaign derived the exact
right-closed Lucas phase at every fixed product order and a same-row signed
factorial detector. Their remaining input is an aggregate actual-phase
rejection bound. An arbitrary cofactor can force all fixed-order
packet-product rows to depth zero, but the cofactor then leaves the hard
residual scale; this is a transfer counterexample, not a target
counterfamily.

An averaging proof must now explain where its concentrated arithmetic measure
comes from. It cannot merely choose one after assuming the desired row exists.

### Digit-box and affine routes

For a base-\(p\) digit downset

\[
\mathcal D_c=\{y:y\preceq_pc\},
\qquad
E(c,s)=\{y\in\mathcal D_c:[sy]_{p^L}>c\},
\]

remove the common \(p\)-adic factor from \(c\) and write the reduced word as

\[
d=\sum_{i=0}^{\ell-1}a_ip^i,\qquad a_0>0.
\]

If the escape set is nonempty, put \(t=v_p(s-1)<\ell\). The robust
digit-box campaign proved:

\[
t=0\quad\Longrightarrow\quad
|E(c,s)|\ge r(d),
\tag{DB0}
\]

where \(r(d)\) is the number of active digits of \(d\). If \(t\ge1\), put

\[
B=\prod_{i<t}(a_i+1),\qquad
H=
\begin{cases}
1,&\ell-t\ge t,\\
\displaystyle\prod_{i=\ell-t}^{t-1}(a_i+1),&\ell-t<t.
\end{cases}
\]

Then

\[
|E(c,s)|\ge B-H\ge B/2.
\tag{DB}
\]

The proof is a genuine affine-fibre rigidity theorem: a zero-escape fibre is
an affine automorphism of the suffix box, and for a fixed slope at most one
translation is possible. Both bounds are sharp at the information level
stated. In particular,

\[
L=1,\quad c=p-2,\quad s=2
\]

has one escape, while for

\[
L=2r,\quad C=bp^{r-1}-1,\quad
c=1+p^rC,\quad s=1+p^r
\]

the box has \(2bp^{r-1}\) points and again exactly one escape. Total
digit-box entropy, active-digit count, or box cardinality therefore cannot
by itself provide a positive fraction or fixed positive power of useful
multipliers.

The associated bounded-congestion same-row theorem is also exact. If
\(G_i\) maps into the true layer support \(S_i\subseteq K\) with congestion
at most \(M_i\), and

\[
F(k)\ge\sum_{i:k\in S_i}w_i,
\]

then

\[
\max_{k\in K}F(k)
\ge
\frac1{|K|}
\sum_i\frac{w_i|G_i|}{M_i}.
\tag{BC-SEC}
\]

For an exact component packet this has a literal adapter:
\(A_i(V)=E(M_i,s_i)\cap F_iV\) maps injectively to rows \(uQ\).
The full escape set cannot replace this admissible subset. For infinitely
many \(n=p(p-2)\) with \(p\equiv5\pmod9\), the relevant box has one escape,
but that escape lies outside every legal packet-admissible set \(F_iV\).
This family is not in the hard residual branch.

The remaining application gap is an arithmetic embedding: local escape sets
must supply large captured subsets and bounded-congestion maps into true
supports for one fixed ambient \(n\), with the right-closed phases, legal
half-range, and enough aggregate weighted capacity. The conditional statement
named `RWER` expresses exactly that requirement but does not prove it.

### Global invariant and all-row routes

The exact sublevel function

\[
H(x)=\max\{\log n:n\text{ composite and }D(n)\le x\}
\]

satisfies:

\[
\text{Part (iii)}\quad\Longleftrightarrow\quad
H(x)=O\_\varepsilon(x^\varepsilon)\text{ for every }\varepsilon>0.
\]

If \(n\) has at least two distinct prime factors, then

\[
D(n)\le x\quad\Longrightarrow\quad
n\mid\operatorname{lcm}(1,\ldots,x).
\]

The multiprime hypothesis is essential: \(D(4)=2\) but
\(4\nmid\operatorname{lcm}(1,2)\), and in general
\(D(p^a)=p^{a-1}\). This is an attractive global representation, but the
multiprime sublevel set is not monotone in the divisor lattice and no
container or product theorem has improved the resulting \(O(x)\) bound for
\(\log n\).

The latest reset sharpened the sublevel calculation to

\[
\log n\le\vartheta(x)+O(\sqrt x)=x+o(x),
\]

where the repeated-prime-power contribution is the \(O(\sqrt x)\) term.
The leading squarefree term remains \(x\), so this does not beat \(A=1\).

Two exact all-row/divisor identities were also retained:

\[
\operatorname{lcm}_{1\le k\le K}D_n(k)
=\gcd\!\left(n,\operatorname{lcm}(1,\ldots,K)\right),
\]

and, if \(C_{p,h}(n)\) counts proper divisor rows retaining the \(h\)-th
\(p\)-layer,

\[
\prod_{\substack{d\mid n\\1<d<n}}D_n(d)
=\prod_{p^a\parallel n}\prod_{h=1}^a p^{C_{p,h}(n)}.
\]

The first records the union of layers across rows and the second their
marginal multiplicities. Neither controls concentration at one row. Natural
complementary-row lower bounds already fail at \((n,d)=(132,6)\) and
\((252,14)\).

The first identity has a useful exact cover consequence that was missing from
the earlier map. For multiprime \(n\), let

\[
\tau_{\rm cov}(n)=
\min\left\{|K|:
\operatorname{lcm}_{k\in K}D_n(k)=n\right\}.
\]

Then

\[
\tau_{\rm cov}(n)\le\omega(n),\qquad
D(n)\ge n^{1/\tau_{\rm cov}(n)}.
\]

Consequently Part (iii) already holds along every family with

\[
\tau_{\rm cov}(n)=o\!\left(\frac{\log n}{\log\log n}\right),
\]

in particular whenever
\(\omega(n)=o(\log n/\log\log n)\). This is a genuine solved regime, not a
solution in the dense residual range.

Complement rows can in fact be completely inert. All prime-complement rows
have denominator \(1\) for \(n=2310\) and \(n=7293\). At

\[
n=14835=3\cdot5\cdot23\cdot43,
\]

the prime rows give their singleton components while every composite proper
divisor row gives \(1\). Thus the all-divisor product identity can be exactly
sharp while providing no aggregation beyond singleton rows.

The fixed bridge \(\lambda(n)\le D(n)^3\) is false. Growing-exponent
Carmichael formulations did not yield a strictly easier proved endpoint.
Finite-difference, determinant, cyclotomic, and \(S\)-unit arguments produced
limited rigidity theorems but not an all-row contradiction.

### Counterexample route

Many infinite families refute proposed proof mechanisms. None is a
counterexample to Part (iii). A target disproof requires one fixed \(A>0\) and
an unbounded family satisfying an all-row upper bound

\[
D(n)=O((\log n)^A).
\]

No retained family has this property. The central-binomial family
\(n_M=\binom{2M}{M}\) has smooth exact components and remains a useful hard
family, but no suitable upper bound on every legal row has been proved.

## Packet-capacity fork: 2026-07-27 audit

The latest campaign isolated a particularly clean sufficient reduction and
then stress-tested essentially every obvious way of proving it.

Let \(P\) be \(H\) exact components of one height in \([y,2y)\). For fixed
\(\delta>0\), define

\[
m_\delta=\lfloor1/\delta\rfloor+1.
\]

The statement `SPC(delta)` says that if \(n\mid L_X\), \(H\ge X^\delta\),
and \(y\ge X^\delta\), then one legal row fully supports at least
\(m_\delta\) members of \(P\). The implication

\[
\bigl(\forall\delta>0,\ \mathrm{SPC}(\delta)\bigr)
\Longrightarrow \text{Part (iii)}
\]

is proved by binning exact components by height and dyadic size. `SPC` itself
is not proved. It is a useful coordinate for the hard branch, not a result.

### Exact packet regressions

Three cofactor-one packets now serve as mandatory tests:

\[
\begin{aligned}
P_4&=(103,131,139,181),&
D\!\left(\prod P_4\right)&=181,\\
P_6&=(61,71,73,79,83,101),&
D\!\left(\prod P_6\right)&=83\cdot101=8383,\\
P_7&=(41,43,47,53,67,71,73),&
D\!\left(\prod P_7\right)&=71\cdot73=5183.
\end{aligned}
\]

For \(P_4\), every pairwise Lucas intersection is endpoint-only. For \(P_6\),
all \(20\) triples are endpoint-only. For \(P_7\), all \(35\) triples are
endpoint-only even though all \(21\) pairs have an interior common row. Thus:

- four vertices do not force a pair;
- six or seven vertices do not force a triple;
- pairwise compatibility does not imply common-row triple compatibility;
- a Ramsey or clique argument needs an asymptotic arithmetic input, not a
  fixed graph threshold.

The exact checks are `verify_k4.py` and `search_cap3.cpp` in
`runs/erdos700-iii-packet-capacity-20260727/`.

### Lock, smoothness, and rigidity routes

The following facts survived audit.

1. If \(n=CQ\), \(Q=\prod q_i\), and
   \(C(Q/q_i)\equiv c\pmod{q_i^T}\) for one bounded common label \(c\), then

   \[
   C^T\sum_iq_i^{-T}>1.
   \]

2. In the squarefree unit-lock case, the complete-homogeneous hierarchy gives

   \[
   C>
   \frac{1}{h_J(1/p_1,\ldots,1/p_H)}
   \ge
   \frac{y^J}{\binom{H+J-1}{J}}.
   \]

   The same bound holds for one common bounded digit template and has an
   unequal-depth version.

3. If \(n=CQ\mid L_X\) and the unit lock has depth \(J\), then

   \[
   \psi(X)>
   (H+J)\log y-\log\binom{H+J-1}{J}.
   \]

These exclude a deep coherent finite-label lock with a small cofactor. They
do **not** show that bounded common-row capacity produces a coherent lock.
Their cost is only \(O((H+J)\log y)\), not the \(HJ\log y\) needed in the
polynomial-packet regime.

Conversely, shallow locks are compatible with full sublevel smoothness.
There are explicit squarefree cofactors \(C_4,C_7\) such that

\[
C_i(Q_i/p)\equiv1\pmod p\quad(p\in P_i),\qquad
C_4Q_4\mid L_{181},\quad C_7Q_7\mid L_{223}.
\]

They lock every row below \(103^2\), respectively \(41^2\), to packet
capacity at most one. More generally, CRT gives an arbitrarily long
prescribed finite lock horizon. Therefore:

- “smoothness destroys CRT locks” is false;
- any bounded-depth or bounded-row-menu argument is false as a closure;
- the full cofactor-dependent digit tails must be used.

### GCD compression, zero-sums, and prefix counting

Several attractive common-row reformulations are exact but do not improve the
scale.

- For rows \(K=\{k_1,\ldots,k_s\}\),

  \[
  \frac{n}{\gcd(n,\binom n{k_1},\ldots,\binom n{k_s})}
  =
  \operatorname{lcm}_{j}D_n(k_j).
  \]

  Hence a short row-gcd compression is literally a short cover of exact
  components. If it used \(o(H)\) rows, pigeonhole would already give the
  desired high-capacity row. The identity does not construct such a cover.

- Digit atoms modulo a directional multiplier yield many subset-sum
  quotients, and three induced partitions obey an exact common-difference
  inequality. In the hard regime, however, the available partition lengths
  are polynomial while the quotient interval has size \(R\ge y^{H-3}\).
  The threshold is quantitatively vacuous.

- If finite prefixes alone certify an endpoint-only triple, their total depth
  satisfies

  \[
  \sum_iJ_i\log p_i\ge\log R.
  \]

  Summing over hostile triples forces an \(\Omega(H)\)-deep profile at almost
  every base, but it still costs only \(O(H\log y)\) per word and gives no
  common label.

- Orienting every failed triple yields \(\Theta(H^2)\) rejected pair moduli at
  many bases. One depth-one digit can service all
  \(\binom{H-1}{2}\) rejections, so repeated directed failure cannot be
  charged one modulus at a time.

### Cover identities and phase-free averaging

For a cofactor-one packet, capacity at most \(M\) is equivalent to every
\((M+1)\)-subset of packet primes covering every interior binomial
coefficient. Factorial-moment and first-product identities are exact. They
retain only unsigned incidence data and do not force overlap.

The failure is not marginal. Exact all-digit examples give:

\[
\begin{array}{c|c|c|c}
S&R&(|T_p|)_{p\in S}&\bigcap_{p\in S}T_p\\
\hline
(101,103)&960509&(8760,69316)&\{0,R\}\\
(41,43,47)&52790&(10368,11376,792)&\{0,R\}\\
(101,103,107)&925335&(574,119140,239934)&\{0,R\}.
\end{array}
\]

For the pair, the marginal prediction exceeds \(632\) and the cyclic-box
prediction exceeds \(518\). For the two triples, the corresponding
predictions are still \(>33,>8\) and \(19.16,10.89\), respectively.
Therefore none of the following can be retried without a new signed input:

- multiplying marginal Lucas densities;
- entropy or cardinality surplus;
- phase-free Fourier mass;
- fixed second or third moments;
- dependent random choice;
- complete-period cyclic-box heuristics.

There is also an exact abstract support model
\(\widetilde{\mathcal S}_p=\{0,Q,p,Q-p\}\) at the correct sublevel and packet
scales. It satisfies reflection, divisibility, literal witnesses, all
factorial-moment vanishings, and the formal product identity while retaining
capacity one. It is not an actual Pascal row; it certifies that those data
alone are logically insufficient.

### Pascal-ring and bounded-depth algebra

Booleanized Pascal coefficients preserve idempotence, the powered adjacent
recurrence, and the first Frobenius shift, but Booleanization is not additive
and does not preserve Vandermonde convolution.

The stronger fixed-depth fake

\[
\widetilde F_{p,J}(X)
=(1+X)^{b_p}(1+X^{Q-b_p})
\]

agrees with the true row at every coefficient within \(p^{J+1}\) of either
endpoint. It preserves the first \(J\) Lucas factors and every Hasse identity
of order below \(p^{J+1}\), yet its assembled interior capacity is at most
\(J+1\). Thus every bounded-depth Pascal, Hasse, differential, or root-support
argument is insufficient.

The true omitted tail

\[
(1+X^{p^{J+1}})^{a_p}
\]

usually has an interior macro-block; only \(O(H/\log y)\) bases can have an
endpoint-only true tail. This is a real distinction from the fake, but no
argument synchronizes the macro-blocks at one coefficient. That
synchronization—not another bounded-prefix identity—is the surviving
Pascal-algebra problem.

### Character phase and one-base energy

For the complete unit Lucas box \(E_p\subset G_p\), put

\[
\lambda_p(\chi)=\frac1{|G_p|}
\sum_{x\in E_p}\overline{\chi(x)},\qquad
\alpha_p=\lambda_p(\mathbf1).
\]

Generic character damping is false even for actual dyadic packet primes.
One can produce a primitive character nearly principal on a whole packet,
and even exponentially many primitive near-principal characters on one fixed
packet in the sublevel regime. Conductor size, packet primality, and
Parseval/cardinality alone do not damp the nonprincipal contribution.

The surviving digit-box-specific identity is

\[
\sum_\chi|\lambda_p(\chi)|^2
\left|\sum_{q\ne p}\chi(q)\right|^2
=
\frac1{|G_p|}
\sum_{q,r\ne p}|E_p\cap(r/q)E_p|.
\]

Equivalently, the nonprincipal part is the variance of the directed-star
count \(N_p(t)=\sum_{q\ne p}1_{E_p}(qt)\). The carry automaton computes every
dilate intersection exactly. On every coordinate of \(P_4\) and \(P_7\),
the variance is between \(0.98\) and \(1.01\) times the random diagonal
scale. A universal constant \(1\) is false: product-constrained searches
reach about \(1.293\), and arbitrary one-digit boxes reach \(1.6\). No
universal constant \(2\) theorem is proved.

There is an exact first-digit decomposition. If the first cap is \(d\),
\(\delta=d/(p-1)\), and the remaining tail density is \(\beta\), let

\[
L_0(z)=\#\{q:(q\bmod p)z\in[1,d]\}.
\]

Then

\[
V_p\le
\beta(1-\beta)\,\mathbb E L_0^2
+\beta^2\operatorname{Var}(L_0).
\]

This separates multiplicative interval energy at the first digit from
conditional tail decorrelation; neither estimate is presently available
uniformly. Exhaustive small searches found ratios \(37/27\), and the
one-digit packet \(p=31,\{41,43,53,59,61\}\) gives \(119/75\), reinforcing
that a constant-one conjecture is false.

Even a perfect one-base bound would not imply capacity:

1. it controls a directed star over a complete residue group;
2. the legal interval occupies only \(O(1/y)\), possibly \(O(1/y^2)\), of
   that group and may be wholly exceptional;
3. \(p\)-acceptance of \(qt\) does not imply reciprocal \(q\)-acceptance of
   \(pt\).

The third failure has an exact abstract regular-tournament model with
\(\alpha_p=1/2\) and zero variance at every base but no mutually compatible
pair at any \(t\). Therefore the data \(\{\alpha_p,V_p\}\) cannot logically
imply a common row.

First-order energy also does not tensorize. Balanced order-two character
values can have

\[
\sum_q\chi(q)=0
\quad\text{but}\quad
e_{2s}(\chi(q):q)=(-1)^s\binom{H/2}{s},
\]

so higher subset-product correlations can be maximal while the first energy
vanishes.

For two bases and an \(r\)-subset-product menu, the exact common count is

\[
Z_{p,q,r}
=
\sum_{\chi,\psi}
\lambda_p(\chi)\lambda_q(\psi)\chi(q)\psi(p)\,
e_r\bigl(\chi(s)\psi(s):s\in P\setminus\{p,q\}\bigr).
\]

The CRT does not create a free bilinear large sieve:
\((\chi,\psi)\mapsto\chi\psi\) is just the character group modulo
\(p^Jq^K\). Even when all subset products are distinct below that modulus,
unweighted Cauchy--Schwarz loses the full mode count and is exponentially
worse than the principal term.

The correct weighted second moment has the exact shared-dilate form

\[
\sum_{\chi,\psi}
|\lambda_p(\chi)|^2|\lambda_q(\psi)|^2
|e_r(\chi(s)\psi(s))|^2
=
\frac1{\varphi(p^J)\varphi(q^K)}
\sum_{\substack{|I|=r\\|U|=r}}
|E_p\cap a_{I,U}E_p|\,|E_q\cap a_{I,U}E_q|.
\]

This identity is useful, but a second moment still does not control the
signed first moment without paying for all character pairs. The actual K4
packet already gives a product-constrained legal-row falsifier: for
\((p,q)=(103,131)\), outside menu \(\{139,181\}\), and \(r=1\), both legal
pair rows fail in both bases, so \(Z_{103,131,1}=0\) although its principal
term is positive. Any relative estimate must therefore average
asymptotically over many base pairs or menus; it cannot hold pair by pair.

On a literal legal interval the expansion also contains

\[
S_R(\chi\psi)=\sum_{\substack{t\le R\\(t,pq)=1}}\chi(t)\psi(t).
\]

Ordinary Pólya--Vinogradov and unweighted large-sieve estimates do not close
when the full prefix modulus is comparable to \(R^2\), especially when
\(R\alpha_p\alpha_q=O(1)\). A revival needs a
digit-box-\(\lambda\)-weighted incomplete-character estimate at the scale of
the principal mass, not a generic character bound.

### Carry recursion and short intervals

The exact dilate-intersection automaton must retain the full carry
distribution. A scalar digit recursion is false: for

\[
p=23,\qquad q=17,\qquad r=29,
\]

one has \(r/q\equiv-1\pmod{23}\), and at a suitable incoming carry the next
digit is \(y=d-x\). All \(d+1\) digits survive instead of the random
\((d+1)^2/p\) scale.

A possible revival would require an operator decomposition

\[
T_d^{q,r}=\text{rank-one main term}+R_d^{q,r}
\]

with a centered norm bound that survives a product of varying digit
operators. No such theorem is proved.

Elementary one-digit short-interval discrepancy gives

\[
O\!\left(\min\{M,A_pT/M\}+1\right)
\]

at modulus \(M=p^{j+1}\), and \(O(\sqrt{A_pT})\) after summing scales. It
still leaves exactly the top \(m-1\) digit levels unresolved for an
\(m\)-prime row. Those levels carry the missing cross-base phase; shrinking
the interval merely moves the same obstruction.

### Toeplitz, Hankel, and Smith-minor route

For valid index ranges, the standard Pascal-row minors have explicit product
formulas:

\[
\det_{0\le i,j<r}\binom n{k+i-j}
=
\prod_{j=0}^{r-1}\frac{\binom{n+j}{k}}{\binom{k+j}{k}},
\]

and

\[
\det_{0\le i,j<r}\binom n{k+i+j}
=
(-1)^{r(r-1)/2}
\prod_{j=0}^{r-1}
\frac{(n+j)!\,j!}{(k+r-1+j)!\,(n-k-j)!}.
\]

If capacity is \(<m\), every minor using \(2r-1\) coefficients is divisible
by \(p^r\) for all but at most \((2r-1)(m-1)\) packet primes. This looks
promising but is exactly saturated: near the edge, each such prime already
contributes \(r\,v_p(n)\), and the explicit product contains the automatic
\(n^r\) factor carrying the full packet. K4, K7, and the arbitrary-depth CRT
locks are actual counterexamples to every bounded-window version.

A determinant route is viable only if it constructs a nonzero **integral
normalization** that removes the automatic \(n^r\) factor and then proves a
strictly smaller packet-valuation or Archimedean upper bound. Standard
Toeplitz, Hankel, determinant, resultant, and Smith-minor forms do not.

### Counterfamily attempts

Finite hostile packets cannot be scaled by preserving their complete old
words: if a lift \(N=nR\) has
\(R\equiv1\pmod{p^{d_p}}\) for two old primes, then the newly legal row
\(k=n\) supports both. A scalable negative family must rewrite almost every
old digit tail.

An infinite endpoint-only triple exists through the exact fringe identity
\(T(A,p,R)=J\cup(R-J)\), for example

\[
p=13,\quad A=7\cdot11,\quad
R_L=1+\frac{13^L-1}{77},\quad L=10+770k.
\]

It has fixed packet size and no \(X\)-smoothness control, so it is a
counterexample to a universal richness claim, not to Part (iii).

A genuine disproof still needs a growing, sublevel-smooth packet with bounded
all-row capacity and bounded cofactor leakage. No construction has all three.
Weak-Giuga infinitude is unknown, shallow CRT locks do not bound later rows,
and adjoining factors or full-word lifting creates new common rows.

### Exact surviving target

All current routes converge on the same object. For an \(m\)-subset \(S\),
let \(N_S\) be its actual common unit-quotient count on the legal interval,
and \(U_S\) the number of unit quotients there. A sufficient estimate is

\[
\sum_{|S|=m}
\left|N_S-U_S\prod_{p\in S}\alpha_p\right|
=
o\!\left(
\sum_{|S|=m}U_S\prod_{p\in S}\alpha_p
\right).
\]

In character form it must retain simultaneously:

- the actual digit-box weights \(\lambda_p(\chi_p)\);
- the cross-base edge decorations \(\prod_{p\ne q}\chi_p(q)\);
- the common short-interval factor
  \(\sum_{t<R_S}\prod_{p\in S}\chi_p(t)\);
- signed cancellation before absolute values.

No one-base energy, complete-period theorem, unsigned moment, or abstract
incidence inequality controls this expression.

There is one sharp marginal-only dense exception. If
\(\bar\alpha>1-1/m\) and an aggregate short-interval first-moment discrepancy
is smaller than the margin, an \(m\)-supported row follows. The threshold is
best possible for marginal data by a balanced rejected-vertex hypergraph
model. The hard Lucas packets have much smaller \(\alpha_p\), so the general
case still requires mixed arithmetic correlation.

## Forensic history audit: additions found on 2026-07-27

This pass audited the 79 MB original root Codex rollout, the separate 34 MB
Part-(iii) continuation root, all 28 mathematical descendants of that
continuation, the earlier specialist forks, a filtered 37 MB corpus of 4,362
retained files under 97 top-level dev-box run directories, the loop manifests,
and the accessible Brave ChatGPT Pro threads. Recorder `events.jsonl`, build
trees, frozen environments, and raw telemetry were deliberately excluded. The
audit found **no hidden unconditional proof and no genuine target
counterfamily**. It did find the following results and failure certificates
that the earlier synthesis had not retained.

### Quantitative reductions that survive

**Hard-sequence classification.** If a putative hard sequence obeys

\[
D(n)\le C(\log n)^A,
\]

then

\[
\left(\frac1A+o(1)\right)\frac{\log n}{\log\log n}
\le\omega(n)\le
(1+o(1))\frac{\log n}{\log\log n}.
\]

After deleting negligible logarithmic mass, almost all remaining prime bases
exceed \((\log n)^{1-\varepsilon}\), their exponents are at most
\(\lfloor A\rfloor\), and one row can be carry-free in at most
\(\lfloor A\rfloor\) core components. Thus every true hard sequence is
forced into the dense, low-height, moving-base regime rather than merely
being heuristically expected there.

**Minimal overweight divisors and homogeneous phases.** Suppose \(n\mid L_x\).
Every divisor \(d\mid n\) that is divisibility-minimal subject to \(d>x\)
satisfies

\[
x<d\le x^2.
\]

An exact phase-extraction lemma then produces large homogeneous
prime/exponent classes and canonical boundary packets. The named
Homogeneous Phase Common-Multiplier Lemma (`HPCM`) would finish this route,
but remains unproved.

**Sparse Lucas boxes.** For \(q=p^a\parallel n\), write
\(N=n/q=\sum_jd_jp^j\) and

\[
\rho_q(n)=\#\{2\le k\le n/2:q\mid D_n(k)\}.
\]

Then

\[
\rho_q(n)=
\left\lfloor\frac{\prod_j(d_j+1)-1}{2}\right\rfloor.
\]

The complete classification of \(\rho_q(n)\le2\) is

\[
N=d,\quad 1\le d\le\min(5,p-1),
\]

or, for \(L\ge1\),

\[
N=p^L+1,\qquad N=2p^L+1,\qquad N=p^L+2.
\]

The constant cases disappear in every fixed polynomial-component regime
\(Q(n)\le r^B\) once \(r=\omega(n)\) is large. More strongly, a standard
Matveev linear-form estimate proves

\[
\#\{i>\lfloor r/2\rfloor:\rho_{q_i}(n)\le2\}\le1
\qquad(Q(n)\le r^B)
\]

for every fixed \(B\) and all sufficiently large \(r\). Indeed, two sparse
upper components would give distinct numbers
\(X_i=c_ip_i^{m_i}\), \(c_i\in\{1,2\}\), both within \(2r^B\) of \(n\).
The resulting nonzero linear form in at most three rational logarithms is
simultaneously at most \(\exp(-r\log r+O_B(r))\) and at least
\(\exp(-O_B((\log r)^3))\), a contradiction.

This narrows the weighted route to one exact missing implication. Put

\[
U=\{i:i>\lfloor r/2\rfloor\},\qquad
W_U(k)=\sum_{\substack{i\in U\\q_i\mid D_n(k)}}\log q_i.
\]

For fixed \(A>1\), it would suffice to prove that some \(B>A\) and
\(\eta>0\) satisfy

\[
\max_{2\le k\le n/2}W_U(k)<(A+\eta)\log r
\quad\Longrightarrow\quad
\#\{i\in U:\rho_{q_i}(n)\le2\}\ge2.
\tag{TB}
\]

The conclusion contradicts the at-most-one theorem. Neither LP duality,
small relative digit-box density, nor denominator-height Fourier estimates
prove `(TB)`.

**Mixed-depth least representative.** Failure of dense escape yields a
low-exponent core \(P\) carrying nearly all logarithmic mass, individual
least Kummer depths \(\ell_q\), and labels \(\alpha_q\) satisfying

\[
(P/q)R\equiv\alpha_q\pmod{p^{\ell_q}},\qquad
R=n/P<\prod_qp^{\ell_q}.
\]

Hence the actual cofactor \(R\), not a freely chosen surrogate, is the least
positive simultaneous CRT representative. This removes the false
common-depth assumption. The remaining problem is an Archimedean lower bound
for this least representative with the structured labels that arise from
actual Lucas failure.

**Exact deepest-support cover LP.** For

\[
E(k)=\{p:p^{v_p(n)}\mid k,\quad
k/p^{v_p(n)}\preceq_p n/p^{v_p(n)}\},
\]

the row-cover number \(\tau_{\rm cov}(n)\) has the exact fractional
set-cover dual. If

\[
d(T)=\max_k|E(k)\cap T|,\qquad
\mathcal A=\max_T\frac{|T|}{d(T)},\qquad r=\omega(n),
\]

then

\[
\mathcal A\le\tau_{\rm cov}(n)\le H_r\mathcal A,
\qquad
\frac r d\le\tau_{\rm cov}(n)\le r-d+1,
\quad d=\max_k|E(k)|.
\]

On admissible sublevel pairs,
\(\tau_{\rm cov}(n)=x^{o(1)}\) is equivalent to
\(\log n=x^{o(1)}\). The proposed `ODHEGC` hereditary capture lemma would
give

\[
\tau_{\rm cov}(n)\le7(\log_2x)^3,
\]

but perturbation yields only \(|I|\le M\tau_{\rm cov}(n)\), and explicit
examples refute the needed merge/strip monotonicity. The exact LP is valid;
the phase-free closure inference is not.

**Actual-row Carmichael aggregation.** Proper-divisor rows admit exact
partial-layer frequencies \(\theta_\ell\), and

\[
\sum_{\ell\mid\lambda(n)}(1-\theta_\ell)^r<1
\quad\Longrightarrow\quad
\lambda(n)\mid\prod_{j\le r}\lambda(D_n(k_j)).
\]

There is also, for every \(Q>1\), an actual-row cover

\[
\lambda(n)\mid L(Q)\prod_{j=1}^r\lambda(D_n(k_j)),
\qquad
r\le2\frac{\log n}{\log Q}+1.
\]

Its scalar consequence is weaker than the known \(A=1\) bound, and the
one-scale tradeoff cannot close Part (iii). It remains a legitimate
multi-row mechanism rather than a one-row theorem.

There is a second exact actual-row estimate. Let \(R_*(n)\) be the minimum
number of distinct legal rows in a Carmichael product certificate. Assign
each maximal prime-power atom of \(\lambda(n)\) to one canonical component
that attains it, and let \(s_Q\) count the active owners \(q_i<Q\). Then

\[
R_*(n)\le s_Q+3\frac{\log n}{\log Q}+1.
\tag{OWN}
\]

The displayed owner expression cannot reach the desired iterated-log scale.
For fixed \(T>1\) and \(0<\delta<T-1\), put

\[
n_X=
\left(\prod_{X<p\le2X}p\right)
\left(\prod_{X<p\le(1+\delta)X}p\right).
\]

These integers eventually lie in the \(T\)-dense branch, yet for every atom
assignment and every \(1<Q\le n_X/2\),

\[
s_Q+3\frac{\log n_X}{\log Q}+1
\ge
\frac{\min(\delta,1)}2\frac{X}{\log X}
\gg\frac{\log\log\log n_X}{T}.
\tag{OWN-F}
\]

This refutes only the strategy of optimizing the right side of `(OWN)`. It
does not refute a new bound on \(s_Q\) alone, nor an arbitrary
phase-sensitive aggregation by actual rows.

On the interval-square family
\(n_X=\prod_{X<p<2X}p^2\), a separate actual-row analysis bounds the
top-resonant contribution of every row by \(O(X/\log^2X)\). The
nonresonant contribution remains uncontrolled, so this is not an all-row
aggregation theorem.

**Entropy and token partitions.** For legitimate Carmichael-atom ownership,
the exact entropy selection bound is

\[
\max_k\log D_n(k)\ge
W e^{-\Phi_n(\pi)},\qquad W=\log\lambda(n).
\]

The surviving `TPRI` assertion is phase-sensitive: unless the component row
or entropy branch already wins, the physical exponent tokens should admit
an \(O(T)\)-color multiplicative partition whose actual right-closed rows
retain \(\Omega(W)\) total owner weight. It would imply
\(W\ll T\log D(n)\), but remains unproved.

The later promotion audit proves that promoting sponsored partial layers to
full depth costs at most \(\log n\). It reduces the remaining cover budget to

\[
r+|Z_0\setminus C|
=O\!\left(
\frac{\log\log\log n}{\log\log\log\log n}
\right).
\tag{UTC}
\]

Every actual row covers at most six of the residual opposite-tail owners.
The exact CRT/Fourier common-row criterion and hybrid row bound survive, but
scalar spectral charging and sponsor reassignment do not prove `(UTC)`;
there is no hidden Hall-type sponsor capacity.

**Canonical first-failure phases.** If failed primes are grouped by

\[
\Phi_p=
p^{a_p+d_p+1}
\left\lceil\frac{n-k}{p^{a_p+d_p+1}}\right\rceil,
\]

then every occupied phase class obeys

\[
\sum_{p\in C(\Phi)}\log p
\le
\min\!\left\{
\frac{\log\Phi}{E_\Phi},
\frac{\log(n-\Phi)}{A_\Phi}
\right\}.
\]

For balanced interval-prime squares, each exact phase fibre is at most
\(\sqrt{Z\log(2Y)}\). The number and total logarithmic mass of occupied
phases remain uncontrolled; this is distinct from the already-recorded
tail-conductor bound.

### Exact same-row identities recovered from older runs

**Depth envelope and coordinatewise sharpness.** If \(p^a\parallel n\),
\(h_p=v_p(n/p^a-1)\), \(n\mid L_x\), and \(x<k<n\), then

\[
v_p(D_n(k))
\le
\min\!\left\{a,\max\!\left(0,\lfloor\log_p k\rfloor-h_p\right)\right\}.
\tag{DE}
\]

Every depth allowed by `(DE)` has a one-coordinate witness:
if \(1\le c\le a\) and \(p^{h_p+c}<n\), then
\(p^c\mid D_n(p^{h_p+c})\). Thus the envelope has no useful local slack;
the remaining loss is entirely simultaneous compatibility across bases.

**Full-depth support size and singleton classification.** Put
\(P=p^a\parallel n\), \(m=n/P\), write
\(m=\sum_jd_jp^j\), and set

\[
\Delta_p(m)=\prod_j(d_j+1),\qquad
\varepsilon_p(m)=
\mathbf 1_{\{2\mid m,\ m/2\preceq_p m\}}.
\]

The number of legal rows carrying the full \(P\)-component is exactly

\[
F_p(m)=\frac{\Delta_p(m)-2+\varepsilon_p(m)}2.
\tag{FS}
\]

Subject to \(p\nmid m\), this support is a singleton exactly for

\[
m=2\quad(p\ {\rm odd}),\qquad
m=3\quad(p\ge5),\qquad
m=1+p^h\quad(h\ge1).
\tag{S1}
\]

In the principal case \(m=1+p^h\), its unique row is \(k=P\). By contrast,
for every proper component and every lower threshold \(1\le b<a\),

\[
\#\{2\le k\le n/2:p^b\mid D_n(k)\}\ge p^{a-b}\ge2.
\tag{S2}
\]

Thus only a full-depth source can be a forced singleton. For odd \(n\) there
is at most one full-depth singleton component; when \(4\mid n\), there are at
most two. The only parity regime not bounded by this argument is
\(v_2(n)=1\). This is a component-support statement: the exact support of a
Carmichael atom is an OR over all prime-power components that can source it,
so arbitrary atom ownership cannot be substituted for the exact support.

**Adjacent rows and rational cuts.** Since
\(D_n(k)\mid k\), adjacent denominators are coprime. Primewise comparison in
the Pascal recurrence gives the stronger exact identity

\[
\frac{n}{
\gcd\!\left(n,\binom nk-\binom n{k+1}\right)}
=D_n(k)D_n(k+1).
\tag{ADJ}
\]

It is a two-row product, not a one-row amplification. A broader valid
averaging identity comes from a proper unitary factorization \(n=dQ\).
For \(q_p=p^{a_p}\parallel Q\), \(R_p=Q/q_p\), put

\[
C_{p,d}(j)=v_p\binom{dR_p}{jR_p},\qquad
\Lambda_d(j)=
\sum_{q_p\parallel Q}\min(a_p,C_{p,d}(j))\log p.
\]

The legal rows \(k=jQ\) prove

\[
\log D(n)\ge
\log Q-\frac1{d-1}\sum_{j=1}^{d-1}\Lambda_d(j).
\tag{RC}
\]

This is an unconditional carry-energy inequality. Closing it would require a
uniform energy deficit on one useful unitary cut; levelwise orbit
equidistribution does not supply that deficit after truncation.

**Prime-punctured row formula and rotating descent.** In the
interval-prime-square model \(N_X=Q_X^2\), write

\[
m=\min(k,N_X-k),\quad N_X=bg,\quad m=ag,\quad(a,b)=1,
\]

and, for \(r_p=v_p(g)>0\), define

\[
U_p=\frac1b
\binom{b(g/p^{r_p})}{a(g/p^{r_p})}.
\]

Then every layer is given exactly by

\[
d_p(k)=\bigl(r_p-v_p(U_p)\bigr)_+.
\tag{PP}
\]

The slope-preserving recursion

\[
g_{i+1}=\gcd\!\left(g_i,\frac1b\binom{bg_i}{ag_i}\right),
\qquad E_i=g_i/g_{i+1},
\]

makes \(E_i\) the exact denominator of the \(i\)-th descended row and
telescopes \(\prod_iE_i=g_0/g_\infty\). It is not a monotone charging
process. The exact chain

\[
(1225,595)\longrightarrow(245,119)\longrightarrow(35,17)
\]

has successive loads \(5,7,1\): the \(7\)-coordinate is initially inactive
and activates only after the \(5\)-factor is stripped.

**Fibre atoms, difference cliques, and common prefix coefficients.** For a
fixed packet and cofactor \(R\), the endpoint-only vector is an atom of the
nonnegative affine fibre monoid exactly when there is no common interior
multiplier. Equivalently, it is conformally indecomposable in the associated
integer kernel. Standard Minkowski, Siegel, and Graver bounds control signed
or unconstrained kernel vectors and are automatic at the packet scale; they
do not force a nonnegative conformal decomposition.

For local symmetric supports \(G_i\subset\mathbb Z/R\mathbb Z\), let

\[
\kappa_i=\max\{|B|:B-B\subseteq G_i\}.
\]

The exact difference-clique criterion
\(\prod_i\kappa_i>R^{t-1}\) forces a common nonzero multiplier for \(t\)
coordinates. The analogous zero-sum/circular-partition criterion has the
same threshold. Both are quantitatively empty when \(R\) is exponential in
the packet size.

There is nonetheless shared arithmetic that abstract fibre arguments omit.
For \(q_j=p_j^{a_j}\), \(Q_U=\prod_{j\in U}q_j\), \(L=n/Q_U\), and

\[
E_s=\sum_{\substack{J\subset U\\|J|=s}}
\frac{Q_U}{\prod_{j\in J}q_j},
\]

one has, for every \(i\in U\),

\[
\frac n{q_i}
=L\sum_{s=1}^{|U|}(-1)^{s-1}E_s
\,p_i^{a_i(s-1)}.
\tag{CP}
\]

Thus the changing-base prefix words are truncated evaluations of one common
coefficient sequence. Prefix-remainder entropy gives

\[
\sum_{h=1}^{L_p}\log\frac{p^h}{R_{p,h}}
>
\log\frac{p^{L_p}}{S_p},
\]

but no aggregate simultaneous-remainder inequality strong enough for the
target was obtained. The proposed `CF_t` and polynomial-conductor-quotient
variant `PCQ_t` remain conditional.

**Actual-pattern determinant cover.** For a packet of \(h\) squarefree
primes in \((Y,2Y]\), a depth \(e\), lower-digit support sizes \(s_p\), and
the actual defective pattern sets \(D_p\) with projected higher coefficients
\(B_p\), the retained theorem is

\[
T_0:=\sum_{\{p,q\}}s_ps_q
\le K_e(Y)\sum_p|D_p|
\le K_e(Y)\sum_ps_p|B_p|,
\]

\[
K_e(Y)=
\left\lceil\frac{(2e+1)\log(2Y)}{\log Y}\right\rceil-1.
\tag{APD}
\]

When \(Y\ge2^e\), its one-sided form gives

\[
(h-1)(S-h)\le\sum_p(s_p+e-1)|B_p|,
\qquad
\max_p|B_p|\ge
\left\lceil\frac{h-1}{e+1}\right\rceil.
\]

Pair emptiness therefore forces linearly many actual higher-digit defects at
some base. Fixed-depth CRT programming can realize that defect density, so
`(APD)` does not itself create a common row.

### Algebraic and Pascal--Cartier reset

Over \(\mathbb F_p\), the Pascal series satisfies the exact rank-one Cartier
factorization

\[
\mathcal C_{r+p^bt}(z)
=\mathcal C_r(z)\mathcal C_{p^bt}(z),
\]

which recovers the entire Lucas support hierarchy and all one-digit chains.
For the product ring \(\prod_{p\mid n}\mathbb F_p\), the multiplicative
polynomial solutions are exactly

\[
G(T)=\sum_{p\mid n}e_pT^{N_p}.
\]

The formal identities therefore permit the exponents \(N_p\) to split by
prime. By contrast, the arbitrary-height capacity-one model

\[
G^*(T)=\sum_pe_pT^p,\qquad
A^*(x)=1+\sum_pe_px^p
\]

comes from one profinite exponent and preserves all these formal identities.
It shows that abstract Frobenius/Cartier algebra alone contains too little
Archimedean information.

The obstruction persists for genuine integers at every fixed depth. Finite
jets are independently programmable because

\[
M_{p,a}:=\frac np\bmod p^a
\equiv R(Q/p)\pmod{p^a}.
\]

For every fixed \(L\), CRT gives an ordinary \(n_L=QR_L\) for which each
packet coordinate has only the endpoint choices \(\{0,p\}\) throughout a
long endpoint window below \(p^{L+1}\). Consequently no bounded-depth
Pascal, Cartier, Frobenius, Hasse, or differential identity can close the
problem. A viable algebraic proof must use the full smooth diagonal
constraint \(R\mid L_X/Q\) at depth growing with the instance.

### Sparse-box and cyclotomic branch recovered only from Brave

This branch was not present in the dev-box corpus. Its exact finite and
elementary claims were checked against the Lucas-box formula. The
Matveev-based theorem below is retained as a browser proof candidate pending
an independent primary-source audit of the quoted logarithmic-form
specialization; the final bounded-deletion argument separately remains a
browser proof sketch pending an independent line-by-line audit. A second-pass
reopening of the broad thread recovered its full terminal response and
confirmed that it claims neither the global estimate nor a counterfamily: its
stated endpoint is precisely the large-box, high-conductor phase-cancellation
obstruction recorded below.

A later broad Pro run supplied a stronger smooth-packet statement. Suppose
\(n\mid L_X\), and \(P\) is a set of \(H\) primes with

\[
p\parallel n,\qquad p\in[y,2y],\qquad
H\ge X^\delta,\qquad y\ge X^\delta.
\]

Writing \(n/p=\sum_jd_{p,j}p^j\), put

\[
B_p=\prod_j(d_{p,j}+1),\qquad
\sigma_p=\left\lfloor\frac{B_p-1}{2}\right\rfloor.
\]

The browser proof claims that for fixed \(\delta,K>0\) and all sufficiently
large \(X\),

\[
\#\{p\in P:B_p\le(\log X)^K\}
\le
\left\lfloor\log_2((\log X)^K)\right\rfloor-1,
\tag{PSR}
\]

and consequently

\[
\#\{p\in P:\sigma_p\le(\log X)^K\}
=O_K(\log\log X).
\]

For fixed \(B\), its sharper form is

\[
\#\{p\in P:B_p\le B\}
\le\max\{0,\lfloor\log_2B\rfloor-1\}.
\]

The proof iterates a pairwise Matveev gap lemma through all nonzero
base-\(p\) digits. This audit checked the internal digit-block reduction and
the zero/nonzero split, but not the external theorem citation. If `(PSR)` is
confirmed, it proves that essentially every component in a hostile
polynomial packet has a super-polylogarithmic individual Lucas box. It still
does not create a common row: the certified capacity-one and capacity-two
packets have enormous individual boxes with empty pair or triple
intersections.

For every \(s\ge0\), put

\[
L=12s+6,\qquad n_L=15(5^L+1).
\]

The \(5\)-box forces a candidate multiplier \(u\equiv1\pmod3\). Then
\(5u\equiv2\pmod3\), while the base-\(3\) target has units cap \(1\).
Hence the \(3\)- and \(5\)-coordinates have no common interior row, although

\[
\rho_5(n_L)=7,\qquad \rho_3(n_L)>2.
\tag{LB}
\]

This infinite family refutes all of the following local implications:
individual branching \(\rho\ge3\) forces extension; bounded or sublinear
cylinder depth; an ordinary support-sunflower argument; and dependent random
choice based only on individual support density.

The browser proof sketch also gives a bounded-deletion obstruction. Fix
\(s\). For sufficiently large packet size \(r\), \(Q(n)\le r^2\), and an
upper component \(q_i=p_i^a\), deleting at most \(s\) other components cannot
leave

\[
\frac{n}{q_i\prod_{j\in S}q_j}=p_i^M\pm1.
\tag{CY}
\]

The claimed proof combines a factorial lower bound, \(M\asymp r\), a
cyclotomic factor \(\Phi_m(p_i)\), Brun--Titchmarsh, and the resulting
\(\varphi(m)\) contradiction. Even if `(CY)` survives a clean audit, it
rules out only one sparse-tail mechanism; it does not prove `(TB)`.

Two tempting strengthenings are false. The all-ones word
\((p^L-1)/(p-1)\) has relative box density \((2/p)^L\) but
\(\rho\asymp2^{L-1}\), so sparse density does not imply sparse support.
For the same word, the normalized low-frequency Fourier coefficient
\(\prod_j\cos(\pi/p^j)\) stays bounded away from zero, so
denominator/conductor height alone cannot separate the box.

### Further exact no-go certificates and finite falsifiers

The following items are useful principally because they close named routes.
None is evidence against Part (iii).

- A fixed finite annular row menu can have all selected higher digits erased
  by CRT with only \(O(\log L/L)\) entropy loss. Phase-free finite menus are
  therefore dead even when several exponents are offered geometrically; a
  smooth-cap, instance-adaptive annular theorem remains open.
- A robust signed-Hankel obstruction closes the fixed-divisor-alphabet BG
  counterexample gate. Let \(X\ge\max(16,C^4)\), let
  \(p_1,\ldots,p_H\in(\sqrt X,X]\) be distinct, put \(Q=\prod_ip_i\), and let
  \(\varnothing\ne G\subseteq[H]\) with \(|G^c|\le e\). For positive
  \(\alpha_i\mid C\), there are no \(1\le R\le X\) and
  \(L\ge16e+22\) satisfying
  \[
  (Q/p_i)R\equiv\alpha_i\pmod{p_i^L}\qquad(i\in G).
  \]
  Ordinary BG is already impossible for \(L\ge22\). This eliminates that
  sufficient counterexample architecture; it does not show that failure of
  dense escape must produce BG data.
- If a divisor \(d\) of a cofactor is locked at an old base \(p\) to depth
  \(L\), then \(d\equiv1\pmod{p^L}\). The number of old supported bases is at
  most \(\log(d-1)/(L\log y)\), and every
  \(1<d<p_{\min}^L\) erases all old words. Tail non-preservation still does
  not imply that a new common row appears.
- Boolean ballot-lattice and ordinary Helly/VC/container compressions admit
  exact almost-disjoint support models. The valid deepest-support LP above
  must not be confused with those invalid phase-free closure steps. More
  concretely, for every fixed ballot-lattice dimension \(J\), infinitely
  many central-binomial rows have a prime
  \(p\parallel\binom{2M}{M}\), \(p\asymp\sqrt M\), which appears in every
  coordinate-star subset witness but is lost from every corresponding
  denominator value.
- For a fixed divisor-tail alphabet, put
  \[
  Z_c(k,n)=\frac1{c!}\prod_{j=0}^c(ck-jn).
  \]
  Under the audited squarefree tail congruences,
  \(D_n(k)^{A+c+1}\mid Z_c(k,n)\) and
  \(|Z_c(k,n)|\le n^{c+1}/4\) for every row. But the entire class is empty
  when \(A\ge c+1\); the general fixed-alphabet criterion also requires every
  prime divisor to exceed the alphabet maximum. Growing alphabets remain
  outside this no-go theorem.
- The primitive-necklace decomposition gives
  \[
  D_n(k)=\frac{\gcd(n,k)}
  {\gcd(\gcd(n,k),N_{n,k})}
  \]
  and exact divisor-lattice recurrences, but complement pairing merely
  repeats equal values. Full-face amplification and universal exponential
  mean bounds fail on digit-gap families. The proposed Smith transfer
  \(D^2\ge\nu\) already fails at \(n=70\).
- Higher power sums, Newton identities, Hankel moments, and the proposed
  cubic exterior invariant collapse by degree two or retain the automatic
  \(n^r\) factor. In particular the odd-semiprime normalization
  \(E_3=n^3/\gcd(n^3,\Delta_3(B_n))\) can equal \(n^3>D(n)^3\).
- The quotient-descent assertion `AQG_100` is exactly false at
  \[
  n=20806=2\cdot101\cdot103,\quad
  D(n)=103,\quad T(n)=202,\quad D(T(n))=101,
  \]
  with disjoint prime supports and the exact comparison
  \(103^{200}<101^{201}\).
- The universal primorial hypothesis `H_prim` is exactly false:
  \[
  S_{59}(698036931)=\{29,37,41,43\},\qquad
  29\cdot37\cdot41\cdot43>59^3.
  \]
  Its order, Kraft, factorial, and primorial-recursion repairs fail for the
  same quantifier reason: a large active product is a lower bound on a
  maximum, not an all-row upper bound.
- The capped Giuga example
  \(1722=2\cdot3\cdot7\cdot41\) does not recover the high pair
  \(\{7,41\}\). Adding one prime cannot repair the extension scheme, and
  \(t\) added primes force a new component larger than
  \(N^{1/(2t)}\). The prime-pair-product construction itself gives
  \(D\asymp\sqrt N\), far too large for a target counterfamily.
- For
  \[
  P=(83407,83417,83437,83449),
  \]
  all six pair systems are empty, \(D(\prod P)=83449\), and
  \(\lambda(\prod P)=84099531928617288>83449^3\).
  This finite quartet refutes the fixed cubic bridge, three-row cover,
  `HL6`, `CI`, and `H_lambda` variants. The retained proposed infinite lift
  uses Maynard's admissible-tuple theorem. The transfer to that published
  theorem was checked against the primary source, and six independent
  retained internal audits found no mathematical defect in the final
  argument. It nevertheless remains an unpublished, non-formal auxiliary
  theorem rather than an externally verified result. In any event it has
  \(D(n)\asymp n^{1/4}\), so it does not approach the Part-(iii) scale.

The strongest Carmichael statement left by these falsifiers is only the
conditional dense bridge

\[
R_{\rm dense}(T):\qquad
\rho(n)>\frac{\log n}{T\log\log n}
\Longrightarrow
\lambda(n)\le
D(n)^{\log\log\log n/T},
\]

which remains unproved.

## Canonical single-atom R=2 audit: 2026-07-28

Write

\[
n=2P,\qquad P=\prod_{p\in I}p,\qquad x=D(n),
\qquad p>\sqrt x\ (p\in I).
\]

The component row gives `p<=x`, and therefore

\[
x^{|I|/2}<P\le x^{|I|}.                            \tag{R2-EQ}
\]

Thus an absolute bound on `|I|` and a bound `P<=x^C` with absolute `C` are
equivalent. There is no branch in which canonical R=2 cardinality is
unbounded but the aggregate atom bound remains polynomial.

For odd `p,q in I`, the exact all-row criterion uses

\[
M=\frac{2P}{pq},\qquad1\le t\le\frac M2,
\qquad qt\preceq_p qM,\quad pt\preceq_q pM.       \tag{R2-PC}
\]

This is obtained by writing the literal row as `k=pqt`; reflection about
`M/2` covers the other half. Exact `{2,p}` instances of the same criterion
then determine `D`, because an odd-pair-free row has denominator in
`{1,2,p,2p}`.

Two scope corrections are mandatory. Canonical capacity requires at most
one central survivor, not zero: `n=70=2*5*7` has exact `D=7`, central survivor
`5`, endpoint-only odd support, and both odd primes above `sqrt(7)`. Also the
safe pre-extraction top prune is only `p_min^2>p_max`; the stronger
`p_min^2>2p_max` can discard systems whose exact `D` is `p_max`.

The full-support formula gives the valid all-digit packing

\[
\sum_{p\in I}
\frac{\Delta_p(2P/p)-2+
\mathbf1_{\{P/p\preceq_p2P/p\}}}{2}
\le P-1.                                           \tag{R2-PACK}
\]

It is not quantitatively close to saturation. On the exact packet
`(67,151,199,401)` the left side is `54930` while
`P-1=807326482`. At the literal co-divisor rows `k=n/r`, only one of sixteen
ordered top incidences survives; all other fifteen fail at their least
actual depths and obey `r beta=alpha+h p^ell`. Hence neither unsigned
support packing nor counting actual co-divisor failures charges the packet.

Corrected searches found no H=5 packet among all `962598` top-scale choices
with primes in `[151,400]`: `46940` have an exact central pair row, and each
of the other `915658` has a pair witness by `t=2000000`. There is also no
exact H=4 packet in that interval. One-million-choice
H=5 and H=6 searches, plus corrected 500000-step guided searches for each
size beyond 150, found no survivor. These are finite
falsification data only. In particular, the H=5 shallow lock
`(211,227,233,239,347)` acquires pair witnesses after `t=10^6`, so it remains
a K33 regression rather than evidence for a family.

The R=2 dichotomy remains open. Its exact surviving arithmetic is the signed
aggregate of the simultaneous full-tail counts in `(R2-PC)`; phase-free
packing and literal divisor-row failure counts have now been eliminated.
Artifacts are under `runs/erdos700-iii-r2-gateway-20260728/`.

## R=2 representation-theorem reset: 2026-07-28

For each prime divisor `p|n`, write

\[
\frac np=\sum_i A_i p^i,
\qquad
\Pi_p(n):\quad n=\sum_i A_i p^{i+1}.
\]

The right side is a partition whose parts are powers of `p`. For distinct
`p,q|n`, a nonempty proper subidentity of
`Pi_p(n)=Pi_q(n)` is exactly an interior `k` for which both `p` and `q` fail
to divide `binom(n,k)`. Reflection makes this the full `(R2-PC)` criterion.
Thus an endpoint-only pair is exactly a primitive partition identity, or a
conformally indecomposable kernel vector. This refines the fibre-atom
observation already recorded under K42; it is not a signed-lattice relaxation.

Sissokho's average minimal-zero-sum theorem applies with all hypotheses
literal and gives the new necessary condition

\[
s_p(n/p)s_q(n/q)\le n.                              \tag{PPI-S}
\]

The exact four-prime packet `(67,151,199,401)` has digit sums
`(58,166,190,166)`. Its largest pair product is `31540`, so `(PPI-S)` has
minimum integer slack factor `51193`. It is far below the packet gateway.
Moreover, for `N=2H+1`, the `H` partitions `(i,N-i)`, `1<=i<=H`, have
pairwise subset-sum intersection exactly `{0,N}`. Hence generic pairwise
primitive identities have unbounded family size. Any stronger theorem must
use the literal prime-power parts, their actual digit multiplicities, and the
common factorization `n=2 product(I)`.

The other native theorem transfers were audited and stopped at their first
mismatch.

- Bounded radix knapsack is exact, but Brown completeness and Frobenius-type
  conclusions are one-sided and do not synchronize the same multiplier.
- The coefficient `binom(n,k)/n + Z` has additive order exactly `D_n(k)`, but
  the standard order theorem for the full vector gives an lcm. At `n=70`,
  the maximum coordinate order is `7` and the vector order is `70`.
- Fixed-instance digit languages are regular, but Cobham requires one set in
  two fixed bases; here two finite languages, both bases, both caps, and the
  cutoff move. Fine--Wilf has the analogous one-word hypothesis mismatch.
- Shareshian--Woodroofe Theorem 1.3 translates an endpoint-only pair exactly
  into universal Sylow-`p,q` generation of `A_n`. This is reversible, and the
  available prime-gap theorem constructs one covering pair rather than
  bounding an all-divisor clique.

One constructive continuation survives with a proved normalization. For
fixed shifts `z_i`, put `p_i=T+z_i` and

\[
F_i(X)=2\prod_{h\ne i}(X+z_h-z_i)=\sum_r c_{i,r}X^r.
\]

Since `n/p_i=F_i(p_i)`, once `p_i` dominates the fixed coefficients, every
base-`p_i` digit is exactly a fixed nonnegative constant or `p_i` minus a
fixed positive constant. For `q=p+delta`, equality of two capped endpoint
subpartitions is reversibly equivalent to the bounded close-base carry system

\[
C_0(b)=pu_1,\qquad
C_l(b)+u_l=a_{l-1}+pu_{l+1} (1\le l\le H),\qquad
u_{H+1}=0,
\]

where

\[
C_l(b)=\sum_{r+1\ge l}{r+1\choose l}\delta^{r+1-l}b_r.
\]

For fixed shifts the carries are bounded independently of `T`. Maynard's
Theorem 1.2 applies to any sufficiently large set of distinct shifts and
produces many fixed-size subsets having infinitely many simultaneously prime
translates. The geometric shifts `z_i=2*4^i` meet that literal distinctness
hypothesis. If `c_m>0` is Maynard's lower proportion, it would suffice to
prove that more than a `1-c_m` proportion of the `m`-subsets are eventually
endpoint-only for this carry system. That density assertion is unproved. The
modest-scale prime quintuple
`(101603,101627,101723,102107,103643)` has common rows on all ten pairs (the
largest first witness is `4234`), so automatic geometric primitivity is false
before the stable scale. Timeouts and prefix scans at larger scales are not
evidence.

Automatic primitivity is also false as a stable integer-base assertion. For
all sufficiently large `p=769 mod 1920`, the five shifts

\[
(p-120,p-96,p,p+384,p+1920)
\]

have a proper solution of the capped pair system for `p,p+1920`, with
multiplier

\[
t=\frac{1920p^2+960675839p+769}{1920}.
\]

Both full radix expansions, every cap, and the legal cutoff are proved
symbolically in the report. If all five values are prime, this is a literal
common Erdős row. It is a scalable carry obstruction but not a prime
counterfamily: simultaneous primality of those five prescribed linear forms
is unproved, and one structured subset has zero density in the Maynard
intersection problem. Checked artifacts are under
`runs/erdos700-iii-r2-representation-20260728/`.

If the carry-density statement is proved, Maynard supplies a prime subset
beyond its stability threshold. Odd-pair endpoint-only behavior gives
`p_max<=D(n)<=2p_max`; squarefreeness then gives `n|L_{D(n)}`, while
`p_min^2>2p_max` for large translates verifies canonical extraction. Thus
the downstream implication includes parity, exponents, endpoints, exact
`D`, and smoothness rather than only a prime-pattern heuristic.

## Top-component mass and depth iteration audit: 2026-07-28

For multiprime `n`, put `x=D(n)` and

\[
T_x(n)=\sum_{\substack{p^a\parallel n\\p^a>\sqrt x}}a\log p.
\]

The proposed top-mass estimate was

\[
T_x(n)\ll \frac{x}{\log x}.                       \tag{TM}
\]

It was not proved or disproved. The adversarial audit did establish that,
up to changes in absolute constants and finite exceptions, `(TM)` is
equivalent to the first uniform sublevel advance

\[
D(n)\gg\log n\,\log\log n.
\]

It is therefore not a routine local lemma below the frontier: proving it
would cross the first unbounded-factor barrier.

The proposed depth-growing proof from the two-digit `(AS2)/(PW2)` identity
has a scalable failure certificate. Translating one block to height `h`
changes the represented integer by `p^h` in base `p` and by `q^h` in base
`q`; nonnegative block concatenation does not preserve one literal row.
An explicit CRT family realizes arbitrarily many such translated blocks in
the two actual Lucas words of one ambient integer, at growing mixed depths
and with the actual least positive cofactor. The two proposed rows remain
different. This closes literal block iteration, not every possible use of
the two-digit identity.

Smoothness and large top mass also do not supply the missing all-row bound.
A growing smooth packet can satisfy the component-level mass conditions and
still have a legal row with denominator above the proposed sublevel. Fake or
bounded-prefix support systems can be made fully hostile, but they are method
counterexamples only: they do not realize one integer with exact
`x=D(n)` and all rows bounded by `x`.

One positive partial theorem survived. The smooth-core extraction `(SCE)`
shows that in the mass range relevant to `(TM)`, one legal row discards at
most two top primes and leaves an actual cofactor that is an
`O(exp(sqrt(x)))` least mixed-depth CRT representative. This is a proved
natural-language partial result with deterministic regressions, not a Lean
theorem. Its proposed continuations `(MSLR)`, `(AAB)`, and `(FDCR)` remain
open. In particular, literal ownership by cofactor atoms is false even for
canonical `R_*=2` packets.

No late run produced an unconditional Part (iii) improvement or a genuine
target counterfamily. The terminal reports are retained on `dev-georgios`
under `runs/erdos700-iii-audited-max-20260727/`,
`runs/erdos700-iii-tm-proof-20260728/`, and
`runs/erdos700-iii-tm-adversary-20260728/`.

## Route constraints

The non-overlap matrix was introduced to prevent route renaming. “Killed”
means the named mechanism is false or quantitatively insufficient as stated;
it does not mean that every theorem using related mathematics is impossible.

| ID  | Mechanism                                                                                     | Disposition                                                                          | What a replacement must add                                                          |
| --- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| K01 | Multiply marginal carry-free or Lucas densities                                               | Killed: successes can occur at disjoint rows                                         | Average the exact weighted depth at one literal row                                  |
| K02 | Fixed finite menus of component-product, co-divisor, or divisor-lattice rows                  | Killed by CRT and full-residual counterfamilies                                      | Let the row family depend on the actual ambient integer or prove an all-row identity |
| K03 | Bounded-prefix CRT obstruction or construction                                                | Killed by deep-prefix escape                                                         | Control the deep tail or a global invariant                                          |
| K04 | Complete-period equidistribution                                                              | Killed at the needed scale: the legal interval is much shorter than the joint period | Prove a short-interval theorem with the actual cutoff and phases                     |
| K05 | Ordinary large sieve after absolute values                                                    | Killed as closure: absolute values erase the necessary signed correlation            | Retain signs or first prove a new arithmetic energy estimate                         |
| K06 | Use abstract/fractional cover or incidence averaging as phase-free closure                     | Killed by almost-disjoint support models; the exact cover LP itself remains valid     | Add an arithmetic identity coupling supports at the same row                         |
| K07 | Copy or scale a successful row after changing the ambient cofactor                            | Killed: the right-closed phase changes; \(n=900\) is a regression case               | Prove the exact valuation transfer in the new ambient integer                        |
| K08 | Exclude only the coordinatewise unit-lock residue                                             | Killed as a reduction: the hostile condition is \(\forall S\,\exists p\in S\)        | Treat the full hostile hypergraph or derive unit lock from extra hypotheses          |
| K09 | Low-degree resultants, Vandermonde, symmetric sums, reciprocal sums, or ordinary height alone | Killed at extraction scale by a logarithmic-exponent gap                             | Use literal binomial structure or a quantitatively stronger theorem                  |
| K10 | Naive iteration of the \(A=1\) witness                                                        | Killed by \(n=30\) and scalable method obstructions                                  | Prove an explicit cumulative loss or transfer invariant                              |
| K11 | Reflection or complement alone                                                                | Killed as a construction                                                             | Use reflection only after constructing a genuine row                                 |
| K12 | Balanced squares or one fixed height as a universal model                                     | Killed as a transfer                                                                 | Prove a height-uniform theorem or a loss-controlled height decomposition             |
| K13 | Sacrificial/controller components outside the residual cap                                    | Out of scope for the hard branch                                                     | Preserve the exact component cap and moving-base scale                               |
| K14 | Arbitrary-target automata or arbitrary affine-avoidance inverse theorem                       | Killed by dense high-dimension words with long empty intervals                       | Exploit the actual orbit and common ambient integer                                  |
| K15 | Orient every failed pair to one wholly hostile base                                           | Killed by \(n=29505\)                                                                | Handle variable-phase correlation                                                    |
| K16 | Add one sacrificial EGRS tuner                                                                | Killed: it is the old multiplier, fixed-pair no-tuner families exist, and no matching moving-base endpoint theorem was primary-source verified | Introduce an independent legal degree of freedom and audit any imported theorem against the actual cutoff |
| K17 | Fixed cubic Carmichael bridge \(\lambda(n)\le D(n)^3\)                                        | Killed by the verified finite quartet; its proposed infinite lift passed source-transfer and six internal audits but remains unpublished/non-formal | Use no fixed-cubic bridge; prove any growing bridge from scratch                     |
| K18 | Phase-free entropy selection                                                                  | Killed as the arithmetic step                                                        | Prove actual-phase coupling before using entropy                                     |
| K19 | Off-the-shelf smooth numbers in progressions                                                  | Killed as direct transfer by the modulus/range mismatch                              | Match the pointwise modulus, short interval, and prescribed residue                  |
| K20 | Sparse or near-power classification from endpoint gaps alone                                  | Killed as a complete inverse theorem                                                 | Control internal gaps or state a narrower consequence                                |
| K21 | Annular zero-block batching as a completed proof                                              | Open but incomplete                                                                  | Supply the missing global sponsor and residual budget                                |
| K22 | Pairwise Lucas alignment as the default target                                                | Quarantined as overstrong                                                            | Target weighted depth or prove the exact hard-scale pair transfer                    |
| K23 | Factorial moments or Fourier expansions without ambient correlation                           | Killed as closure                                                                    | Exhibit a new sign, recurrence, or diagonal term forcing one row                     |
| K24 | Largest component or largest prime alone                                                      | Proved only at \(A=1\)                                                               | Add a genuine amplification mechanism                                                |
| K25 | Finite examples or easy-branch infinite families as target evidence                           | Killed by quantifiers                                                                | Use computation only to falsify a named lemma or check an identity                   |
| K26 | Weighted exchange or peeling with an unstated preservation law                                | Quarantined; existing attempts changed phase or lost accumulated depth               | State and prove exact valuation transfer with summable loss                          |
| K27 | UHFL as an equivalent or default objective                                                    | Quarantined as overstrong                                                            | Start from total weighted depth; use UHFL only as a sufficient corollary             |
| K28 | Fixed Ramsey or clique threshold for packet compatibility                                     | Killed by K4, K6, and K7; all K7 pairs coexist with no supported triple               | Prove an asymptotic arithmetic restriction on the compatibility hypergraph           |
| K29 | Infer a coherent common residue or bounded digit template from low capacity                    | Unsupported converse; finite hostile packets have varying labels                     | Derive the common template from the all-\(t\) cover before applying rigidity          |
| K30 | Use sublevel smoothness alone to destroy CRT locks                                             | Killed by explicit smooth K4/K7 cofactors and arbitrary finite lock horizons          | Enter the full cofactor-dependent tails and quantify their cross-base incompatibility |
| K31 | Compress a row gcd and treat it as a bypass of capacity                                       | Exact identity shows this is merely a component cover                                | Construct an \(o(H)\)-row cover; pigeonhole then supplies the desired row             |
| K32 | Density, entropy, cyclic-box prediction, DRC, or unsigned moments                              | Killed by exact pair/triple examples with large numerical surplus                    | Retain the signed actual cross-base phase                                             |
| K33 | Bounded-depth Hasse, Lucas-prefix, differential, or Pascal-ring identities                    | Killed by the fixed-depth fake polynomial                                            | Use the true macro-tail and synchronize it at one literal coefficient                 |
| K34 | Generic primitive-character damping from dyadic primes, conductor, or mode count              | Killed by one and exponentially many near-principal primitive characters             | Prove a digit-box-\(\lambda\)-weighted, cross-base restriction theorem                |
| K35 | Deduce capacity from one-base complete-group \(\lambda^2\) energy                             | Logically insufficient: misses legal intervals and reciprocal acceptance             | Bound signed mixed correlations on the common short legal interval                   |
| K36 | Iterate a scalar one-digit carry estimate                                                     | Killed by a persistent all-digit transition at a special incoming carry              | Control the full centered carry transfer operator through all digit levels            |
| K37 | Apply an unweighted CRT/bilinear large sieve to two character moduli                           | Collapses to one modulus and loses the full mode count                               | Weight by the actual \(\lambda_p\)'s and retain edge phases before summation          |
| K38 | Standard Toeplitz, Hankel, determinant, resultant, or Smith minor of a bounded row window      | Exact packet valuations saturate via the automatic \(n^r\) factor                    | Produce an integral normalization removing that factor with a strict valuation bound  |
| K39 | Scale a finite hostile packet by preserving its complete old words                            | Killed: the new legal row \(k=n_{\rm old}\) supports every preserved pair             | Rewrite almost every old tail while retaining smoothness and an all-row bound         |
| K40 | Import a current fixed-base digit-distribution theorem                                        | Hypotheses and uniformity do not match moving bases, moving caps, and same-\(t\) need | Prove a finite moving-base affine theorem with exact Lucas caps and legal cutoff       |
| K41 | Treat a fixed-packet endpoint family as a target counterexample                               | Killed by packet-growth and smoothness quantifiers                                   | Grow the packet while controlling smoothness, all rows, and cofactor leakage          |
| K42 | Apply Minkowski, Siegel, or generic Graver bounds to the endpoint fibre                       | Killed as closure: they find signed vectors or give automatic bounds, not a nonnegative conformal split | Prove a packet-specific positive decomposition using the actual Lucas inequalities |
| K43 | Infer extension, a shallow cylinder, a sunflower, or DRC overlap from \(\rho_p\ge3\)           | Killed by \(n_L=15(5^{12s+6}+1)\)                                                    | Use cross-base labels or a global smoothness constraint, not local branching alone    |
| K44 | Infer sparse support from small digit-box density or Fourier damping from conductor height     | Killed by the all-ones Lucas word                                                     | Prove a signed cross-base estimate at the actual legal interval                       |
| K45 | Use formal Frobenius/Cartier/Pascal identities without full-depth integer coupling             | Killed by split-exponent/profinite models and fixed-depth CRT jets                    | Use \(R\mid L_X/Q\) at depth growing with the instance                                |
| K46 | Use a finite annular exponent menu without retaining its actual phase                         | Killed by CRT erasure with \(O(\log L/L)\) entropy loss                              | Make the menu instance-adaptive and prove a smooth-cap annular theorem                |
| K47 | Infer a new overlap merely because extending the cofactor destroys old tail words              | Killed: small cofactor divisors can erase every old word without creating an overlap  | Track the exact replacement supports in the enlarged ambient integer                  |
| K48 | Multiply adjacent denominators or transport a layer by short shifts                           | Exact identities give a two-row product, while adjacent supports are disjoint         | Convert an explicit bounded row cover to one row with a new arithmetic mechanism      |
| K49 | Charge a quotient descent monotonically                                                       | Killed by \(1225\to245\to35\), where the active prime rotates from \(5\) to \(7\)    | Control the complete punctured valuation deficit without support monotonicity         |
| K50 | Build a counterfamily from a fixed finite divisor-tail alphabet                               | Empty in the high-precision range \(A\ge c+1\)                                      | Use a growing/base-dependent alphabet or a genuinely multi-digit state                |
| K51 | Amplify by primitive-necklace recurrence, complement pairing, or divisor-lattice Möbius inversion | Exact identities repeat or upper-bound values; digit-gap families kill full-face amplification | Supply a same-row concentration theorem beyond the recurrence                     |
| K52 | Iterate the quotient \(n\mapsto n/D(n)\) through `AQG_100` or weak monotonicity                 | Killed by \(20806\mapsto202\) and other exact descent falsifiers                      | Prove a different aggregate potential with a verified per-step gain                   |
| K53 | Use `H_prim`, Kraft/order bounds, factorial recursion, or a primorial active-product cap         | Killed by the exact \(y=59\) active set                                               | Replace the false universal cap by an all-row estimate with the correct inequality direction |
| K54 | Use higher power sums, Newton/Hankel moments, or the cubic exterior/Smith normalization         | Collapses by degree two or exceeds \(D^3\) on odd semiprimes                         | Find a normalized integral invariant without the automatic top-row factor             |
| K55 | Import the proposed composite-base Wu all-row specialization                                  | The stated specialization fails at \(m=n=3r,\ j=r\) for \(r\ge11\)                  | Recheck the exact source hypotheses and index orientation before any use              |
| K56 | Build a counterfamily from fixed-divisor-alphabet BG packets with bounded erasures              | Impossible for \(L\ge16e+22\); ordinary BG fails for \(L\ge22\)                     | Use a growing base-dependent alphabet, or first prove hard failure forces stronger non-BG data |
| K57 | Optimize the known Carmichael owner-row expression                                             | Killed by `(OWN-F)`, uniformly over \(Q\) and every atom assignment                  | Aggregate actual phases directly rather than canonical component ownership            |
| K58 | Expect smoothness to make many individual Lucas boxes bounded or polylogarithmic                | Quarantined by the full browser argument for `(PSR)` pending source audit; huge-box hostile packets still exist | Prove signed cross-base intersection in the large-box regime                          |
| K59 | Replace canonical `R=2` capacity by central all-failure, or pre-prune with \(p_{\min}^2>2p_{\max}\) | Killed by the exact \(n=70\), \(D=7\), one-central-survivor certificate and exact `{2,p}` recovery | Permit one central survivor and compute `D` before applying \(p^2>D\) |

+| K59 | Replace canonical R=2 capacity by central all-failure, or pre-prune with \(p_{\min}^2>2p_{\max}\) | Killed by the exact \(n=70\), \(D=7\), one-central-survivor certificate and exact \(\{2,p\}\) recovery | Permit one central survivor and compute \(D\) before applying \(p^2>D\)               |
| K60 | Charge a canonical R=2 packet by unsigned full-support packing or the count of literal co-divisor failures | Killed quantitatively by the exact four-prime packet: packing ratio \(6.81\cdot10^{-5}\), with 15 of 16 actual incidences failing | Correlate the actual phases with full non-divisor rows in one signed same-row estimate |
| K61 | Apply Brown completeness, Frobenius, or an interval subset-sum theorem to one radix knapsack | Killed as closure: the hypotheses and conclusions are one-sided and do not force the reciprocal condition at the same multiplier | Prove a genuinely two-system theorem with both literal caps and the shared cutoff |
| K62 | Use the additive order of the torsion coefficient vector or a unipotent Jordan block | Killed by the standard direct-product order theorem and `n=70`: it yields lcm `70`, while the maximum coordinate order is `7` | Supply a theorem forcing one coordinate order, not the order of the full element |
| K63 | Bound R=2 packets through the alternating-group translation alone | Exact but reversible: Shareshian--Woodroofe identifies each edge with universal Sylow generation; available results create one pair and do not bound an all-divisor clique | Add a group theorem with a literal uniform clique bound for divisor-prime Sylow classes |
| K64 | Deduce bounded packet size from generic primitive partition identities or their minimal-zero-sum/Graver bounds | Killed quantitatively by `(PPI-S)` slack `51193` and structurally by the unbounded family `(i,2H+1-i)` | Use the actual prime-power parts, digit caps, and common product factorization |
| K65 | Treat lacunary common translates as automatically endpoint-only once their digits stabilize | False as a carry claim: besides the modest prime quintuple, the displayed quadratic multiplier gives a scalable stable capped solution on one geometric five-shift congruence class | Prove endpoint-only behavior for more than the complementary Maynard proportion of literal prime subsets, or control the density of stable obstructions |
| K66 | Iterate `(AS2)/(PW2)` by translating and concatenating digit blocks                           | Killed: the two bases rescale a height-`h` block by different factors `p^h` and `q^h`; a growing-depth actual CRT family keeps the proposed rows unequal | Add a full-depth operation proved to preserve one literal cofactor-dependent row      |
| K67 | Derive `(TM)` from prefix width, least CRT representativeness, and smoothness alone             | Killed by the growing mixed-depth construction and by smooth high-mass packets lacking all-row control | Use the complete endpoint-rejection supports and prove a quantitative signed label bound |
| K68 | Treat `(TM)` as an easier local lemma below the quantitative frontier                           | False as a scope claim: up to constants it is equivalent to `D(n) >> log n log log n` | Prove it as the first genuine unbounded-factor advance, with all sublevel quantifiers intact |
| K69 | Charge top primes independently to literal cofactor-atom rows                                 | Killed as ownership: canonical `R_*=2` packets can make every top prime fail the sole atom row | Couple actual least-depth phases across atom and non-divisor rows                     |

New work should explicitly identify the relevant IDs and the additional
arithmetic input that escapes them.

## Conditional reductions that must not be called results

Several reports introduced useful names:

- `ARSI(A)`: actual-phase same-multiplier capacity in the full residual
  decomposition;
- `PWCC`: polynomial-tuner weighted carry capacity in the balanced-square
  model;
- `RWER(A)`: robust weighted escape realization;
- `UHFL`: an upper-half full-layer packet statement;
- `SPC(delta)`: constant packet capacity in a polynomial homogeneous packet;
- `HPCM`: a common multiplier for the canonical homogeneous phase;
- `(TB)`: small upper-half weighted maximum forces two sparse Lucas boxes;
- `ODHEGC`: hereditary capture strong enough to make the exact deepest-support
  cover polylogarithmic;
- `TPRI`: a phase-sensitive multiplicative partition of physical exponent
  tokens;
- `(UTC)`: the ultra-low-tail residual owner budget after promotion;
- `CF_t` and `PCQ_t`: common-fibre and polynomial-conductor-quotient bounds;
- `R_dense(T)`: a growing Carmichael bridge in the dense component regime.

Their implications were audited. Their hypotheses were not proved. They are
coordinates for the obstruction, not evidence that Part (iii) is close.

## Current acceptance gate

To prevent more activity without mathematical movement, the current campaign
counts `PROGRESS` only for one of:

1. a complete bound
   \(D(n)\ge c\log n\,L(\log n)\) for all sufficiently large composite \(n\),
   with an explicit \(L(x)\to\infty\);
2. the complete uniform \(A=2\) bound;
3. an infinite counterfamily to one of those precise statements;
4. a verified primary-source theorem that directly implies one of the above.

New local identities, renamed sufficient conditions, restricted-family
theorems, and finite computations remain useful research notes but are
classified `NO_PROGRESS` against this gate.

The first campaign run under this gate finished `STATUS: NO_PROGRESS`. It
proved the restricted high-height estimate and the identities recorded above,
but produced no unbounded improvement over \(D(n)\gg\log n\), no uniform
\(A=2\) theorem, and no target counterfamily. Its recursive child batches also
failed to return payloads, so no unavailable worker claim was used.

## Surviving directions

After the history audit, the following routes are not merely renamed versions
of a killed mechanism:

1. **Prove `(TB)`.** This is now the narrowest full-depth packet target:
   turn a small upper-half weighted maximum into two sparse boxes,
   contradicting the proved at-most-one theorem. The missing input must use
   actual cross-base labels; LP, density, DRC, and generic Fourier damping are
   forbidden by K32, K43, and K44.
2. **Signed mixed short-interval estimate.** Prove the aggregate estimate in
   the packet-capacity section while retaining the actual
   \(\lambda_p\)-weights, edge phases, shared multiplier, and legal cutoff.
   This is the sharp analytic form of the same-row problem.
3. **Full-depth smooth diagonal rigidity.** Combine the mixed-depth least
   representative or common-prefix identity `(CP)` with
   \(R\mid L_X/Q\). Bounded prefixes and formal Pascal/Cartier identities are
   forbidden by K33 and K45; a successful theorem must grow in depth with the
   instance.
4. **Phase-sensitive physical-row cover.** Prove `TPRI`, `(UTC)`, or another
   actual-row cover using the residual owner structure. The exact cover LP
   and six-owner capacity may be used, but phase-free cover and Hall-style
   sponsor reassignment are not available.
5. **Sublevel extremal theorem.** From \(D(n)\le x\), use the complete family
   of denominator or rational-cut constraints to prove
   \(\log n\le x/L(x)\) for some explicit \(L(x)\to\infty\). It must exploit
   same-row concentration or a uniform carry-energy deficit, not another gcd
   or marginal product identity.
6. **First quantitative barrier.** Prove the uniform \(A=2\) bound, or even
   \(D(n)\gg\log n\,L(\log n)\) with \(L\to\infty\), using partial layers and
   an instance-adaptive multiplier. This remains a valid weaker target.
7. **Lacunary `R=2` bounded-carry theorem.** For a Maynard-sized distinct
   shift set, prove that more than the complementary Maynard proportion of
   fixed-size subsets eventually has only endpoint solutions to the exact
   stable carry system, or construct a positive-density family with
   arbitrarily late solutions. Generic partition bounds and automatic
   geometric primitivity are excluded by K64 and K65.
8. **Top-component mass `(TM)`.** Prove the exact sublevel estimate using
   full-depth endpoint rejection and the actual smooth cofactor. Success
   gives (D(n)\gg\log n\log\log n); translated block iteration, prefix
   width, and independent atom ownership are excluded by K66–K69.

A determinant route is also logically reopenable only if it first supplies
the integral normalization specified in K38. A negative route is reopenable
only with a growing smooth packet, bounded all-row capacity, and bounded
cofactor leakage simultaneously.

These directions may still fail. Their advantage is epistemic: success would
be an unconditional quantitative advance, and failure can be stated against a
precise theorem rather than another equivalent bridge.

## Artifact and prompt index

- `docs/part-iii-exploration-map.md`: this canonical attempt and
  do-not-retry ledger.
- `docs/part-iii-run-coverage-audit.md`: exact 105-directory coverage matrix,
  including prompt-only, worker-only, controller, quarantined, and
  out-of-scope dispositions.
- `docs/erdos700-iii-bottleneck-brief.md`: compact technical starting point.
- `campaigns/problems/erdos-700-iii.md`: immutable target.
- `campaigns/problems/README.md`: grouped campaign prompt index.
- `campaigns/problems/erdos-700-iii-beyond-a1-reset.md`: current quantitative
  acceptance gate.
- `runs/erdos700-iii-packet-capacity-20260727/report.md`: exact derivations for
  the packet-capacity fork.
- `runs/erdos700-iii-packet-capacity-20260727/verify_k4.py`,
  `verify_new_lemmas.py`, and `search_cap3.cpp`: deterministic regressions for
  the retained finite falsifiers and exact identities.
- `runs/erdos700-iii-r2-gateway-20260728/` and
  `runs/erdos700-iii-r2-representation-20260728/` on `dev-georgios`: exact
  `R=2` gateway and representation-reset reports.
- `runs/erdos700-iii-audited-max-20260727/`,
  `runs/erdos700-iii-tm-proof-20260728/`, and
  `runs/erdos700-iii-tm-adversary-20260728/` on `dev-georgios`: terminal
  top-component-mass reports and deterministic checks.
- Root Codex history audited:
  `~/.codex/sessions/2026/07/22/rollout-2026-07-22T15-07-34-019f8bde-ae0f-77f0-a4e4-4d3e84f5381c.jsonl`,
  the 34 MB continuation
  `~/.codex/sessions/2026/07/26/rollout-2026-07-26T10-49-48-019f9f8c-215d-7ff0-a390-f79351c726d0.jsonl`,
  and the relevant 23 and 27 July specialist rollouts. The per-fork matrix is
  `docs/part-iii-session-coverage-audit.md`.
- Remote dev-box root audited:
  `ubuntu@dev-georgios:/home/ubuntu/campaigns/erdos700-research/nanocodex-erdos700`.
  The reconciled corpus contains 105 top-level run directories: 16
  Part-(i)/(ii), 3 Part-(iii) prompts with no returned work, 84 directories
  containing Part-(iii) material, and 2 operational-only artifacts. Recorder
  `events.jsonl`, build trees, raw snapshots, and telemetry were excluded.
- High-value dev-box sources recovered in the final diff include
  `runs/math-1784949501-3806031/turn2-exact-incidence.md` (full-depth
  singleton classification),
  `runs/math-1784987750-4084057/exact-statements-and-proofs.md` (owner bound
  and its dense falsifier), and
  `runs/math-1784913529-3482687/bg-robust-theorem.md` (robust BG
  impossibility).
- Accessible Brave/ChatGPT Pro threads audited:
  `6a67e243-31fc-8329-a50d-03c04504e99e` (broad sparse-shadow proof
  candidate and exact high-conductor phase obstruction),
  `6a667fdb-a9f0-8329-a158-d2c7c9034b9d` (sparse/cyclotomic),
  `6a668048-74b4-832e-839d-cdad03dc5e26` (hostile weighted route),
  `6a67e296-c66c-832d-aa8e-b5a11fdffa4f` (Pascal--Cartier),
  `6a666ed5-1aec-8327-ac10-041ff0c7fb6b` (fibre/common-prefix route), and
  `6a67e26a-ae70-8325-a446-e5db722aeba2` (character route).
- Exact source-coverage matrices:
  `docs/part-iii-run-coverage-audit.md` (all 97 dev-box run directories) and
  `docs/part-iii-session-coverage-audit.md` (root sessions, all 28
  continuation descendants, and six identified Brave threads).
- Ignored `runs/`: raw campaign reports, exact jobs, and telemetry.

The ignored run artifacts remain necessary for forensic review, but the claims
above—not terminal scrollback—are the repository's maintained research state.
