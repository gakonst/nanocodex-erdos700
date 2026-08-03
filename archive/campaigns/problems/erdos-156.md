# Erdős problem 156: remove the logarithm from small maximal Sidon sets

## Immutable target

Prove or disprove that the minimum size of a maximal Sidon subset of
`{1,...,N}` is `O(N^(1/3))`.

“Maximal” means inclusion-maximal inside `{1,...,N}`, not maximum-cardinality.
A bound of `O((N log N)^(1/3))`, a construction only for a sparse subsequence
of `N` without a uniform extension argument, or a finite computation does not
settle the target.

## Canonical sources frozen for this campaign

- Status and context: <https://www.erdosproblems.com/156>
- Ruzsa, *A Small Maximal Sidon Set*:
  <https://doi.org/10.1023/A:1009757824153>
- Lean statement, pinned commit:
  <https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/156.lean>

The canonical page was still open on 23 July 2026, with zero comments, zero
claimed proofs, and no user marked as working on it. The known upper bound has
size `O((N log N)^(1/3))`; the campaign must eliminate the logarithmic loss.

## Discovery policy

Inference is the main compute. Reconstruct why the logarithm enters Ruzsa's
covering/maximality argument before proposing changes. Favor altered random
constructions, local-dependency or nibble arguments, algebraic templates,
absorption, and a deterministic completion lemma. Maintain separate proof
obligations for the Sidon property, coverage/maximality, and cardinality.

Small random experiments may test one explicitly stated dependence estimate or
construction invariant. Enumerating optimal sets for increasing `N` is not a
research route.

Web and GitHub search are enabled. Check recent Sidon-set work for an existing
equivalent result before claiming novelty.

## Required completion artifact

Write a complete proof or counterexample in `research-note.md`, including all
probability bounds and quantifiers. If the argument survives adversarial
review, create `solution.lean` importing
`FormalConjectures.ErdosProblems.«156»` and `candidate.json` containing exactly
`{"answer":"true"}` or `{"answer":"false"}`. According to that committed
answer, expose `Campaign.result` with exactly one of these types:

```lean
answer(True) ↔
  (fun N ↦ (Erdos156.minMaximalSidonSet N : ℝ)) =O[Filter.atTop]
    (fun N ↦ (N : ℝ) ^ (1 / 3 : ℝ))

answer(False) ↔
  (fun N ↦ (Erdos156.minMaximalSidonSet N : ℝ)) =O[Filter.atTop]
    (fun N ↦ (N : ℝ) ^ (1 / 3 : ℝ))
```

Do not combine the alternatives into a disjunction. Name the chosen theorem
`Campaign.result`. Do not use `sorry`, `admit`, new axioms, or either open
or “solved” Formal Conjectures theorem whose proof still contains `sorryAx`.
Freeze the proof, source audit, and Lean file together.

If blocked, return an exact gap map: the first false or unproved inequality,
the best repaired construction, and the minimal lemma needed to remove the
logarithm.
