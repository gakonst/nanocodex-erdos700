# Part (i): zero-sum audit and focused direct-classification attempt

Status: **correct reformulation and closed families; the focused follow-up did
not obtain a direct all-factorization classification**.  The exact remaining
elimination problem is stated in Section 10.

This report audits the result recovered from the authenticated shared
conversation [Part 1 Solution Status](https://chatgpt.com/share/e/6a711117-98a0-8005-9513-41ba76ca3aa0).
The conversation is discovery evidence, not authority.  Every formula below
has been normalized against the checked boundary definitions in
`lean-part1/PartIWork/BoundaryAntichain.lean`.

The historical baseline is primary here.  Erdős and Szekeres define it as the
greatest prime power dividing $n$ and ask for equality with $n/Q(n)$ in their
[1978 paper](https://www.renyi.hu/~p_erdos/1978-46.pdf).  The maintained
largest-prime formulation is stated separately throughout.

This stricter status is consistent with the maintained problem's
[public discussion](https://www.erdosproblems.com/forum/thread/700?order=oldest),
which specifically notes that a test ranging over all candidate multipliers
does not look like a valid characterization and continues to list Part (i) as
open.  That community status is context, not proof of the negative verdict;
the mathematical reason is the surviving shared-witness quantifier isolated
below.

## 1. Corrections to the rendered transcript

The page's visual extraction reversed several fractions and binomial
arguments.  The coherent definitions are as follows.  Let $q$ satisfy the
checked witnessed-baseline hypotheses; in particular, it may be any proper
prime-power divisor of $n$.  Define

\[
\partial_q(n)=\left\{d\mid n:d>q\text{ and }
  \frac d r\le q\text{ for every prime }r\mid d\right\}.
\]

For $d\in\partial_q(n)$, put $c=n/d$.  If $p\mid d$, set

\[
e_p=v_p(d),\qquad b_p=v_p(c),\qquad
D_{p,d}=\frac d{p^{e_p}},\qquad
N_{p,d}=\frac n{p^{e_p}}=D_{p,d}c.
\]

The equality under discussion is $f(n)=n/q$, not the nonsensical rendered
ratio $q/n$.  In the two-prime theorem the binomial is

\[
\binom{q-1}{\left\lfloor qm/p^{a-1}\right\rfloor},
\]

not the reverse ordering produced by the text extraction.

## 2. Refinement lemma

For $0\le x\le N$, write $N=\sum_j a_jp^j$ in base $p$, and let $T_p(N)$ contain $a_j$
copies of $p^j$.  One refinement replaces one $p^j$ by $p$ copies of
$p^{j-1}$.  If $r_p(N,x)$ is the minimum number of refinements after which
$x$ is a submultiset sum, then

\[
r_p(N,x)=v_p\binom Nx
=\frac{s_p(x)+s_p(N-x)-s_p(N)}{p-1}.
\]

The proof in the shared session is sound.  Each refinement increases the
token count by $p-1$, giving the lower bound.  Conversely, merge the
disjoint canonical token multisets of $x$ and $N-x$ down to the canonical
tokens of $N$, then reverse those merges.  This uses exactly the digit-sum
difference divided by $p-1$.

## 3. Quotient-spectrum theorem

Define

\[
\Sigma_{p,d}=\left\{m\in\{0,\ldots,c\}:
v_p\binom{N_{p,d}}{D_{p,d}m}\le b_p\right\}.
\]

By the refinement lemma this can equivalently be stated using bounded token
refinements or the corresponding digit-sum inequality.  Then the recovered
theorem is

\[
\boxed{
f(n)=\frac nq
\iff
\forall d\in\partial_q(n),\quad
\bigcap_{p\mid d}\Sigma_{p,d}=\{0,c\}.
}
\tag{ZS}
\]

The witnessed-baseline qualification is essential: for example, $n=30$ and
the arbitrary divisor $q=6$ pass the displayed spectrum endpoint tests, but
$f(30)=6\ne30/6$.  Here $q=P^+(n)$ gives the maintained problem.  Taking
$q=Q(n)=\max_{p\mid n}p^{v_p(n)}$ gives the historical problem when $n$
is not a prime power; prime powers remain the known historical exceptions.

The proof is correct.  Dividing both arguments of a binomial by
$p^{e_p}$ preserves its $p$-valuation, so

\[
v_p\binom n{dm}=v_p\binom{N_{p,d}}{D_{p,d}m}.
\]

Thus $m$ belongs to every active spectrum exactly when the old boundary
divisor $d$ is realized at the shared multiplier $m$.  Complementation
$m\mapsto c-m$ explains why excluding every non-endpoint spectrum element
is equivalent to excluding a witness in $1\le m\le c/2$.

### Direct-classification audit

The last paragraph is also why (ZS) does **not** resolve the reviewer's
objection by itself.  Each spectrum is defined over every
$m\in\{0,\ldots,c\}$, and intersecting the spectra asks whether the same
nontrivial $m$ passes all prime-base tests.  This is exactly the shared
multiplier search in `Realized`, expressed additively.  It removes binomial
coefficients and gives an elegant zero-sum interpretation, but it does not
eliminate the global witness.

Accordingly, (ZS) is a valid theorem and useful structural upgrade.  Calling
it a conventional direct classification of every $n$ would repeat the
presentation error that prompted this audit.

## 4. Complete two-prime reduction

Let $p<q$ be primes and $n=p^aq^b$.  For the maintained largest-prime
baseline:

1. If $b\ge2$, equality fails at the row $k=q^b$.
2. If $b=1$ and $p^a>q$, equality fails at the least prime power $p^e>q$.
3. If $b=1$ and $p^a<q$, the unique boundary divisor is $pq$, and

\[
f(p^aq)=p^a
\iff
v_p\binom{q-1}{\left\lfloor qm/p^{a-1}\right\rfloor}
\ge v_p(m)+1
\]

for every

\[
1\le m\le\left\lfloor\frac{p^{a-1}}2\right\rfloor.
\]

This is an exhaustive reduction of the two-prime stratum and is often a
short fixed list of digit conditions.  As $a$ varies, however, it still has
a multiplier-indexed test; the genuinely closed examples below are the cases
where that remaining list has been eliminated.

Indeed, in the remaining case the possible rows are $k=pqm$ in the displayed
range, the base-$q$ condition is automatic, and the base-$p$ carry recurrence
is

\[
v_p\binom{p^aq}{pqm}
=a-1-v_p(m)
 +v_p\binom{q-1}{\left\lfloor qm/p^{a-1}\right\rfloor}.
\]

Comparing this with the boundary budget $a-1$ gives the criterion above.

## 5. Genuine closed classifications recovered

The specializations below do eliminate the multiplier search.

For every prime $q>4$,

\[
f(4q)=4.
\]

For every prime $q>9$,

\[
f(9q)=9
\iff
q\ne\frac{3^r+1}{2}\quad\text{for every }r\ge1.
\]

For every prime $q>8$,

\[
f(8q)=8
\iff
q-1\text{ and }3q-1\text{ are not powers of }2.
\]

Equivalently, the prime exceptions lie in

\[
\{2^{t+2}+1:t\ge0\}\ \cup\
\left\{\frac{2^{2t+5}+1}{3}:t\ge0\right\}.
\]

For every prime $q>6$,

\[
f(6q)=6
\iff
\begin{cases}
\text{the binary expansion of }q\text{ has adjacent }1\text{s},\\
\text{the ternary expansion of }q\text{ has a digit }2.
\end{cases}
\]

The last result follows particularly cleanly from the two boundary divisors.
The divisor $2q$ is realized exactly when adding $q+2q$ creates no binary
carry, i.e. when $q$ has no adjacent binary ones.  The divisor $3q$ is
realized exactly when doubling $q$ creates no ternary carry, i.e. when all
ternary digits of $q$ are $0$ or $1$.

The other three families follow from the same digit-sum identity.  For $4q$,
the only possible obstruction has binary carry count
$v_2\binom{2q}{q}=s_2(q)\ge2$, exceeding its budget.  For $8q$, the two
multipliers have carry counts

\[
v_2\binom{4q}{2q}=s_2(q),\qquad
v_2\binom{4q}{q}=s_2(3q).
\]

They meet the obstruction budget exactly when respectively $q-1$ or $3q-1$
is a power of two.  Finally,

\[
v_3\binom{3q}{q}=\frac{s_3(q)+s_3(2q)-s_3(3q)}2
=\frac{s_3(2q)}2.
\]

This is at most one exactly when $s_3(2q)=2$.  Since $q>9$ is prime, that
forces $2q=3^r+1$, and the converse is immediate.  These arguments prove the
closed family statements without relying on the census.

## 6. Universal cofactor theorem

The shared session also gives a valid broad existence theorem:

> For every integer $s\ge2$, infinitely many primes $P>s$ satisfy
> $f(sP)=s$.  Since $P>s$, this simultaneously matches the maintained and
> historical baselines.

Let

\[
H=\lceil\log_2s\rceil+1,\qquad L=4H,\qquad
M=\mathrm{rad}(s)^L.
\]

Every sufficiently large prime $P\equiv-1\pmod M$ works.  For a prime
$p^a\mathrel{\Vert}s$, every possible boundary is $Pp$, and a witness would require

\[
v_p\binom{(s/p)P}{mP}\le a-1.
\]

The lowest $L$ base-$p$ digits instead contribute exactly

\[
L-v_p\binom{s/p}{m}-v_p(m)-v_p(s/p-m)+v_p(s/p)
\]

carries.  The three negative terms are each at most $H$, so this is at
least $L-3H=H\ge a$, a contradiction.  Dirichlet's theorem supplies
infinitely many primes in the reduced class $-1\bmod M$.

The stronger claim that the exceptional primes have a power-saving counting
bound is still **provisional**.  The shared answer gives a plausible
finite-state forbidden-word sketch, but not enough detail to certify the
reset word, forced-carry word, uniform exponent, and finite union over all
boundary multipliers as a publication-ready proof.

## 7. Reproducible checks

Run:

```console
python3 archive/docs/part-i-direct-classification/experiments/verify_shared_claims.py \
  --all-n-limit 5000 --prime-limit 100000
```

The audit checked:

- all 4,330 composites through $5000$ for the maintained baseline;
- all 4,288 non-prime-power composites through $5000$ for the historical
  baseline;
- the direct complementary-weight calculation, the checked boundary
  criterion, and (ZS) against one another;
- 9,588--9,590 applicable primes below $100000$ in each of the four closed
  families;
- twelve focused baseline regressions and twelve exact counterexamples to
  proposed multiplier-elimination shortcuts.

The carry identity used in the universal-cofactor proof was separately
checked in 152,994 parameter cases with $p\le7$, $A<100$, and
$p^L>A$.  The predecessor identity in Section 9 was checked in 36,975
parameter cases.  These computations are regression evidence, not proof.

## 8. Claim ledger

Proved on paper and independently regression-checked:

- the refinement lemma;
- the normalized quotient-spectrum equivalence (ZS);
- the $4q,6q,8q,9q$ closed classifications;
- the universal cofactor theorem;
- the predecessor carry identity in Section 9.

Already Lean-checked in the repository:

- the boundary-antichain equivalence on which (ZS) rests;
- both maintained and historical baseline specializations.

Not established:

- that (ZS) is a direct all-factorization classification in the reviewer's
  sense;
- the claimed power-saving/density-one strengthening;
- a Lean formalization of the refinement and quotient-spectrum layer.

The first item is the substantive remaining gap for calling Part (i) solved
under the stricter reading of “characterise.”

## 9. What the focused closure attempt adds

Write the ordered exact factorization as

\[
n=\prod_{i=1}^r p_i^{a_i},\qquad p_1<\cdots<p_r,
\]

and let $B$ be either the historical baseline
$Q(n)=\max_i p_i^{a_i}$ or the maintained baseline $P^+(n)=p_r$.  A boundary
exponent vector $e=(e_i)$ has

\[
0\le e_i\le a_i,\qquad d(e)=\prod_i p_i^{e_i}.
\]

If $p_0$ is the least prime in the support of $d$, then the boundary test
simplifies to

\[
d\in\partial_B(n)
\iff B<d\quad\hbox{and}\quad d/p_0\le B.
\tag{18}
\]

Indeed, $d/p_0$ is the largest of the prime-deletion quotients.  Thus, writing
$d=p_0u$, the outer boundary branches are exactly the factor-derived choices
with

\[
B/p_0<u\le B.
\tag{19}
\]

This is a clean recursive description of all boundary divisors.  It does not
settle whether a boundary is realized.

### 9.1 Exact predecessor identity

Fix a boundary $d$, put $c=n/d$, and let $p^e\mathrel{\Vert}d$ and
$D=d/p^e$.  For $1\le m<c$, shifting away the common $e$ trailing base-$p$
digits and then using

\[
Dm\binom{Dc}{Dm}=Dc\binom{Dc-1}{Dm-1}
\]

gives

\[
C_p(n,dm)
=v_p\binom{Dc}{Dm}
=v_p(c)-v_p(m)+v_p\binom{Dc-1}{Dm-1}.
\tag{20}
\]

The available boundary budget is $v_p(c)$.  Therefore the local condition is
exactly

\[
C_p(n,dm)\le v_p(c)
\iff
v_p\binom{Dc-1}{Dm-1}\le v_p(m).
\tag{21}
\]

This isolates the only contribution of the multiplier's $p$-adic valuation.
In the primitive case $\gcd(m,d)=1$, Lucas reduces (21) to the digit condition

\[
Dm-1\preceq_p Dc-1
\qquad(p\mid d),
\tag{22}
\]

but the same $m$ must still satisfy (22) in every active base.  The primitive
example $n=195$ below shows that this is not an artificial edge case.

### 9.2 Canonical CRT normal form, and why it is not the endpoint

For an active prime $p$, put

\[
H_p=\lfloor\log_p(Dc)\rfloor,\qquad L_p=p^{H_p},
\]

and define the accepted residue cylinders

\[
\mathcal A_p=
\left\{r\bmod L_p:
\#\{1\le j\le H_p:D r\bmod p^j>Dc\bmod p^j\}
\le v_p(c)\right\}.
\tag{23}
\]

The moduli $L_p$ are pairwise coprime.  For
$\mathbf r\in\prod_{p\mid d}\mathcal A_p$, let $\rho^+(\mathbf r)$ be the
least positive representative of its CRT class, taking the zero class to the
full common period.  With the convention that the minimum of an empty set is
$+\infty$, define

\[
\lambda(n,d)=
\min_{\mathbf r\in\prod_{p\mid d}\mathcal A_p}
\rho^+(\mathbf r).
\tag{24}
\]

The residue form of Kummer and CRT give the exact equivalence

\[
d\text{ is realized}
\iff
\lambda(n,d)\le\left\lfloor\frac c2\right\rfloor.
\tag{25}
\]

Equation (25) is useful for locating the gap, but it is **not** promoted as a
classification.  Evaluating the minimum in (24) searches tuples of local
residues and is the common-multiplier feasibility problem once again.  The
same objection applies to the complementary statement that the local
first-overflow cylinders cover the whole interval
$[1,\lfloor c/2\rfloor]$.

## 10. The single remaining proof obligation (the missing lemma)

The remaining result must be a **factor-coupled short-CRT elimination lemma**
for the systems (23).  More precisely, one must first exhibit an explicitly
defined, well-founded evaluator

\[
\mathsf L(F,e)\in\mathbb N\cup\{+\infty\},
\]

whose clauses read only the ordered factors
$F=((p_i,a_i))$, the boundary vector $e$, and their digit data.  Its recursive
calls must strictly decrease a stated factor/digit measure, and no clause may
iterate or quantify over multiplier values, CRT residue tuples, reachable
automaton states, or solver assignments.  The missing lemma would then prove

\[
\boxed{\mathsf L(F,e)=\lambda(n,d(e)).}
\tag{26}
\]

This is currently an exact completion contract, not a proved mathematical
lemma, because the evaluator's clauses have not been found.  Merely asserting
that (24) has a minimum, defining another predicate for its value, or checking
a cylinder cover does **not** discharge (26).  The missing content is the
explicit evaluator and the exhaustive proof of its branch equations.  No such
branch theorem was found in this attempt.

Its sufficiency is immediate from the checked base theorem.  For the
historical problem, composite prime powers are the explicit failure branch;
otherwise generate the boundary vectors by (18)--(19), apply (26) to every
vector, and require (25) to fail.  Replacing $B=Q(n)$ by
$B=P^+(n)$ gives the maintained theorem.  Thus one uniform elimination lemma
would finish both formulations, while keeping their baselines separate.

## 11. Counterexamples retained from failed shortcuts

For each row below, $A_p$ is the set of multipliers in
$1\le m\le\lfloor(n/d)/2\rfloor$ that pass the base-$p$ budget.  The values
are exact Legendre/Kummer calculations and are asserted by the checker.

| Shortcut | Historical counterexample |
|---|---|
| Solve every prime condition independently; assume monotonicity | $n=40$, $Q=8$, $d=10$: $A_2=\{2\}$ and $A_5=\{1\}$.  Both are nonempty, but their intersection is empty. |
| Test only $m=1$ | $n=136$, $Q=17$, $d=34$: the carry pairs at $m=1,2$ are $(4,0)$ and $(2,0)$ against budgets $(2,0)$, so only $m=2$ works. |
| Choose a primewise least accepted multiplier | $n=120$, $Q=8$, $d=12$: $A_2=\{2,3,4\}$ and $A_3=\{1,3\}$; the unique common value is $3$, which is neither local minimum. |
| Restrict to divisors of the cofactor or indices dividing $n$ | $n=195$, $Q=13$, $d=15$, $c=13$: the unique witness is $m=2\nmid c$, $\gcd(m,n)=1$, and $dm=30\nmid195$. |
| Delete inactive cofactor components recursively | $n=210$, $Q=7$, $d=10$ has the unique witness $m=8$; after deleting either inactive component, the same $d$ is unrealized for both $n=70$ and $n=30$. |
| Pairwise or Helly-style compatibility | $n=1470$, $Q=49$, $d=70$: $A_2=\{2,4,6\}$, $A_5=\{1,2,3,9,10\}$, and $A_7=\{1,5,6,7,10\}$.  Every pair intersects, but the triple intersection is empty. |
| Reduce every failure to a boundary with at most two active primes | $n=1694=2\cdot7\cdot11^2$, $Q=121$: the only realized boundary is $d=154$, with active support $\{2,7,11\}$; the two-support boundaries $242$ and $847$ are unrealized. |
| Use a fixed initial menu through $651$ | $n=31\cdot47\cdot1307$, $d=31\cdot47$, has multiplier range $1\le m\le653$ and the unique witness $m=652$. |
| Descend through proper divisors of a witness | $n=180880$, $Q=19$, $d=20$ has the unique witness $m=4100$; every proper divisor of $4100$ fails. |

Two further regressions show how genuinely digital the obstruction is.  At
$n=6006$, $Q=13$, and $d=21$, the unique witness is the primitive value
$m=139$ in a range ending at $143$.  For the identical exponent/support shape
$n=3\cdot5\cdot7\cdot q$ and boundary $d=105$, $q=101$ has pairwise but no
triple compatibility and all boundaries are safe, whereas $q=103$ has the
unique common multiplier $m=31$ and fails.  These finite examples do not prove
an unbounded-minimal-witness theorem; they only invalidate the stated
shortcuts.

The mandatory formulation separator remains

\[
(\gcd(12,\tbinom{12}{k}))_{k=2}^{6}=(6,4,3,12,12).
\]

Hence $f(12)=3=12/Q(12)$ with $Q(12)=4$, while
$f(12)\ne12/P^+(12)=4$ with $P^+(12)=3$.

## 12. Final closure verdict

The elimination, recursive boundary/cofactor, CRT-cylinder, and
minimal-counterexample routes all stop at the short-CRT problem (24)--(25).
The separate [adversarial referee report](adversarial-referee-report.md)
accepts this negative verdict after requiring the witnessed-baseline scope
correction above.
The focused attempt therefore does not justify a new Lean theorem or any
upgrade of the public Part I claim.  The closed families and universal
cofactor theorem remain valid partial classifications; the all-factorization
reviewer-grade taxonomy remains open at the lemma in Section 10.
