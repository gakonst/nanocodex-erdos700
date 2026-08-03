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

1. characterize the integers for which \(f(n)=n/P(n)\), where \(P(n)\) is the
   largest prime factor of \(n\);
2. determine whether \(f(n)>\sqrt n\) for infinitely many composite \(n\);
3. determine whether, for every \(A>0\),
   \(f(n)\ll_A n/(\log n)^A\).

## Status table

| Part  | Internal status             | Exact result                                                                                    | Remaining external question                                                                               |
| ----- | --------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| (i)   | Complete and kernel-checked | `f_eq_div_iff_boundarySafe` plus an equivalent explicit finite factor-tableau constraint system | Whether the historical request for a “characterization” demands a more closed factorization-only taxonomy |
| (ii)  | Complete and kernel-checked | `Erdos700PNT.erdos_700_ii` proves an infinite set with `f(n)^2 > n`                             | Independent mathematical review, novelty audit, and community adjudication                                |
| (iii) | Open                        | Classical \(A\le1\) range; several exact partial lemmas and method counterexamples              | Any unconditional improvement beyond \(D(n)\gg\log n\), the full theorem, or a counterexample             |

## Part (i)

### Checked theorem

For every composite \(n>1\),

```lean
theorem Erdos700PartI.f_eq_div_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

`BoundarySafe n` says that no divisibility-minimal divisor strictly above the
largest prime factor can be realized by one legal row with the required
simultaneous carry inequalities. It contains neither `f`, a gcd, nor a
binomial coefficient.

The additional compiler theorem

```lean
Erdos700PartI.ExplicitG.explicitG_iff_factorTableauFeasible
```

turns the semantic factor tableau into a finite integer/Boolean system with
explicit prime-power, selector, prefix-product, base-digit, and borrow rows.

### What this does and does not establish

This is an exact, decidable, non-tautological iff characterization. It covers
all composite integers and has a checked finite encoding. It does not remove
the common multiplier from the digit/carry realization problem and therefore
is not a short list of factorization shapes.

The repository calls the formal development complete. It does not claim that
external reviewers must accept this as the intended final form of the
historical word “characterise.”

### Evidence

- `proof/PartIWork/report.md`
- `proof/PartIWork/boundary-antichain.md`
- `proof/PartIWork/STRUCTURAL_UPGRADE.md`
- `proof/PartIWork/ADVERSARIAL_AUDIT.md`
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

The repository should be read as a candidate proof package under independent
review. The canonical problem page was still marked open during this work.
Lean checks formal correctness of the encoded statements; literature priority,
novelty, and interpretation remain separate review tasks.
