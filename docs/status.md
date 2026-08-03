# Erdős 700 status and claim boundaries

This is the canonical status page for the repository. It distinguishes what is
encoded and kernel-checked, what has a complete natural-language proof, what is
only a partial research result, and what remains open.

For the route-by-route history behind these labels, see the
[all-parts research map](research-map.md).

## Problem

For a composite integer \(n>1\), define

\[
f(n)=\min_{1<k\le n/2}\gcd\left(n,\binom nk\right).
\]

The three questions are:

1. characterize the integers for which \(f(n)=n/P(n)\). The maintained
   statement takes \(P(n)\) to be the largest prime factor; the 1978 paper
   takes it to be the greatest exact prime-power component. These are
   different targets, and this repository proves both;
2. determine whether \(f(n)>\sqrt n\) for infinitely many composite \(n\);
3. determine whether, for every \(A>0\),
   \(f(n)\ll_A n/(\log n)^A\).

## Status table

| Part  | Internal status | Exact result | Remaining external question |
| --- | --- | --- | --- |
| (i) | Solved and kernel-checked | Compact synchronized integer/Boolean characterizations for both the maintained largest-prime target and the original greatest-prime-power target | Independent novelty, priority, publication, and community adjudication |
| (ii) | Solved and kernel-checked | `Erdos700PNT.erdos_700_ii` proves an infinite set with `f(n)^2 > n` | Independent mathematical review and comparison with prior or independent resolutions; no novelty claim |
| (iii) | Open | Classical \(A\le1\) range; several exact partial lemmas and method counterexamples | Any unconditional improvement beyond \(D(n)\gg\log n\), the full theorem, or a counterexample |

## Part (i)

### Maintained largest-prime theorem and structural compiler

For every composite \(n>1\),

```lean
theorem Erdos700PartI.f_eq_div_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

`BoundarySafe n` is the decisive proof bridge: it says that no
divisibility-minimal divisor strictly above the largest prime factor can be
realized by one legal row with the required simultaneous carry inequalities.
It contains neither `f`, a gcd, nor a binomial coefficient.

The main structural closure is the compiler theorem

```lean
Erdos700PartI.ExplicitG.explicitG_iff_factorTableauFeasible
```

which turns the semantic factor tableau into a finite integer/Boolean system
with explicit prime-power, selector, prefix-product, base-digit, and borrow
rows. If `F` is an ordered exact factorization of `n`, the checked chain gives

\[
f(n)=\frac{n}{P(n)}
\quad\Longleftrightarrow\quad
\neg G(F,P(n)).
\]

The same row variable and multiplier are shared across every active prime.
There is no variable, row, or disjunction for every possible multiplier. The
indexed fields are polynomial in the binary length of `n`; the direct sparse
description is $O((\log n)^3)$ bits. This is a representation-size statement,
not a polynomial-time algorithm claim.

### Original 1978 greatest-prime-power theorem

Define

\[
Q(n)=\max_{p\mid n}p^{v_p(n)}.
\]

This differs from the largest prime factor: \(n=12\) separates the two
formulations. The checked historical theorem is

```lean
theorem Erdos700PartI.erdos_700_i_historical
    (n : ℕ) (hn : 1 < n) (hcomp : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.Q n ↔
      ¬ IsPrimePow n ∧ Erdos700.HistoricalBoundarySafe n
```

The non-prime-power conjunct is necessary because a composite prime power has
\(Q(n)=n\) while \(f(n)>1=n/Q(n)\).

### Equivalent checked forms

| Form | Final theorem |
| --- | --- |
| Proper prime-power baseline | `f_eq_div_primePow_iff_boundarySafeAt` |
| Full cross-base digit shadow | `f_eq_div_iff_fullShadowSafe` |
| Boundary range \(P(n)<d\le P(n)^2\) | `f_eq_div_iff_boundedObstructionSafe` |
| Exact cofactor multiplier range | `f_eq_div_iff_cofactorObstructionSafe` |
| Exact divisor-poset range | `f_eq_div_iff_divisorPosetSafe` |
| Semantic factor tableau | `boundarySafeAt_iff_factorTableauSafe` |
| Explicit integer/Boolean compiler | `explicitG_iff_factorTableauFeasible` |

### Claim boundary

This is an exact, decidable, non-tautological structural characterization. It
covers all composite integers, handles both source formulations, and
culminates in a compact symbolic system rather than an enumeration of the
original rows. It is a complete solution of the stated characterization
problem. It is not a short enumeration of factorization families; obtaining
one would be a stronger optional theorem.

The clean-room novelty audit found no prior source stating or immediately
implying these exact all-composite criteria and classified the work as a new
application of known Kummer/Lucas methods. That negative search evidence does
not settle priority or publication.

### Evidence

- `writeups/part-i-characterization.tex`
- `proof/PartIWork/report.md`
- `proof/PartIWork/boundary-antichain.md`
- `proof/PartIWork/HistoricalPrimePower.lean`
- `proof/PartIWork/CofactorObstruction.lean`
- `proof/PartIWork/FactorTableau.lean`
- `proof/PartIWork/ExplicitG.lean`
- `docs/part-i-release/complete-prose-proof.md`
- `docs/part-i-release/README.md`
- `docs/part-i-release/novelty-audit.md`
- `docs/part-i-run-coverage-audit.md`
- `proof/PartIVerify.lean`
- `proof/scripts/verify-part-i.sh`

## Part (ii)

### Checked theorem

```lean
theorem Erdos700PNT.erdos_700_ii :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧
      (Erdos700.f n) ^ 2 > n}.Infinite
```

The construction takes three nearby primes \(p<q<r\) with unequal adjacent
gaps and a quantitative separation condition. Lucas-theorem omission bounds
show that every legal row leaves at least two of the three primes in the gcd.
The row \(k=r\) gives equality \(f(pqr)=pq\), and the chosen inequalities give
\((pq)^2>pqr\). A prime-number-theorem packing argument supplies infinitely
many such triples.

### Evidence

- `writeups/part-ii-infinite-family.tex`
- `proof/docs/proof.md`
- `proof/docs/statement-audit.md`
- `proof/Solution.lean`
- `proof/README.md`
- `proof/scripts/verify.sh`

The final axiom audit reports only:

```text
[propext, Classical.choice, Quot.sound]
```

It does not depend on `sorryAx` or on the upstream open-conjecture wrapper.

## Part (iii)

Define

\[
D_n(k)=\frac{n}{\gcd(n,\binom nk)},\qquad
D(n)=\max_{2\le k\le n/2}D_n(k).
\]

Then Part (iii) asks for

\[
\forall A>0\ \exists c_A>0\ \forall n\text{ composite},\quad
D(n)\ge c_A(\log n)^A.
\]

The classical component witness and lcm estimate prove the range \(0<A\le1\).
Prime powers, boundedly many exact prime-power components, and integers with a
sufficiently large component are also controlled. The remaining case contains
many relatively small components and requires one literal legal row to retain
enough total prime-power depth across several bases.

No campaign in this repository has proved:

- a fixed exponent \(A>1\) uniformly for all composite integers;
- an unbounded multiplicative improvement over \(D(n)\gg\log n\);
- an infinite family disproving Part (iii);
- the open same-row arithmetic capacity statements named in some campaign
  reports.

See [`part-iii-exploration-map.md`](part-iii-exploration-map.md) for the full
route ledger and [`part-iii-run-coverage-audit.md`](part-iii-run-coverage-audit.md)
for the reconciled 105-directory evidence inventory.

The standalone reviewer report is `writeups/part-iii-frontier.tex`.

## Evidence labels

Use these labels consistently:

- **KERNEL-CHECKED:** Lean accepts the exact stated declaration and the
  dependency audit passes.
- **PROVED:** complete natural-language proof with all quantifiers and
  hypotheses closed.
- **PROVED-PARTIAL:** complete proof of a result strictly short of the original
  problem.
- **METHOD COUNTEREXAMPLE:** a proved family refuting an auxiliary lemma or
  strategy; not a counterexample to Erdős 700.
- **CONDITIONAL REDUCTION:** a proved implication whose new hypothesis remains
  open.
- **COMPUTATIONAL FALSIFIER:** a finite exact computation that disproves a
  named universal claim.
- **OPEN:** no complete proof or disproof.

## Publication posture

The repository should be read as a proof package under independent review.
Lean checks formal correctness of the encoded statements; literature priority,
novelty, and interpretation remain separate review tasks. In particular, the
repository makes no novelty or priority claim for Part (ii).
