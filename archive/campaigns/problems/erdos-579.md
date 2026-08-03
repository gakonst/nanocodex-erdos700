# Erdős problem 579: dense octahedron-free graphs

## Immutable target

For every real `δ > 0`, prove or disprove that there is `c = c(δ) > 0` such
that every sufficiently large `n`-vertex graph with at least `δ n^2` edges and
no `K_{2,2,2}` contains an independent set of size at least `c n`.

Do not retain the known assumption `δ > 1/8`, weaken linear independence to
`n^(1-o(1))`, or replace the asymptotic theorem by finite graph data.

## Canonical sources frozen for this campaign

- Status and context: <https://www.erdosproblems.com/579>
- Graph-problem formulation:
  <https://mathweb.ucsd.edu/~erdosproblems/erdos/newproblems/TuranOctahedron.html>
- Erdős–Hajnal–Sós–Szemerédi (1983):
  <https://www.renyi.hu/~p_erdos/1983-09.pdf>
- Lean statement, pinned commit:
  <https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/579.lean>

The canonical page was still open on 23 July 2026, with zero comments, zero
claimed proofs, and no user marked as currently working on it. The 1983 result
settles densities above `1/8`; the mathematical bottleneck is eliminating that
threshold.

## Discovery policy

Inference is the main compute. First isolate exactly where `1/8` enters the
published proof. Explore structural decomposition, dependent random choice,
supersaturation, density increment, graphon/regularity reformulation, and
reduction to a sharper local lemma. Demand a quantified route from each
intermediate lemma to a positive `c(δ)`.

A bounded graph experiment may refute a proposed local lemma or expose an
extremal template. Generic graph enumeration and numerical graphon
optimization are not accepted as substitutes for the proof.

Web and GitHub search are enabled. Search for equivalent modern
Ramsey–Turán formulations before treating a lemma as new.

## Required completion artifact

Write a complete proof or counterexample in `research-note.md`, with constants
and all uses of asymptotic notation made explicit. If it survives adversarial
review, create `solution.lean` importing
`FormalConjectures.ErdosProblems.«579»` and `candidate.json` containing exactly
`{"answer":"true"}` or `{"answer":"false"}`. According to that committed
answer, expose `Campaign.result` with exactly one of these types:

```lean
answer(True) ↔
  ∀ δ : ℝ, 0 < δ → ∃ c : ℝ, 0 < c ∧ ∀ᶠ n : ℕ in Filter.atTop,
    ∀ G : SimpleGraph (Fin n), Erdos579.octahedron.Free G →
      δ * (n : ℝ) ^ 2 ≤ G.edgeFinset.card →
        c * n ≤ (G.indepNum : ℝ)

answer(False) ↔
  ∀ δ : ℝ, 0 < δ → ∃ c : ℝ, 0 < c ∧ ∀ᶠ n : ℕ in Filter.atTop,
    ∀ G : SimpleGraph (Fin n), Erdos579.octahedron.Free G →
      δ * (n : ℝ) ^ 2 ≤ G.edgeFinset.card →
        c * n ≤ (G.indepNum : ℝ)
```

Do not combine the alternatives into a disjunction. Name the chosen theorem
`Campaign.result`. Do not use `sorry`, `admit`, new axioms, or either the
open theorem or the `δ > 1/8` theorem as if it held for arbitrary `δ`. Freeze
the proof, source audit, and Lean file together.

If blocked, preserve the best verified threshold improvement or structural
lemma and state the exact obstruction to pushing it to every `δ > 0`.
