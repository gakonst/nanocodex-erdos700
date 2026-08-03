# Erdős problem 700(ii): an unconditional strict binomial-gcd family

## Immutable target

For

`f(n) = min_{1 < k <= n/2} gcd(n, binomial(n,k))`,

prove or disprove that there are infinitely many composite integers `n > 1`
such that `f(n)^2 > n`.

Do not replace `>` by `>=`, assume an unproved prime pattern, or settle only a
finite range.

## Canonical sources frozen for this campaign

- Status and mathematical context: <https://www.erdosproblems.com/700>
- Discussion and conditional candidate families:
  <https://www.erdosproblems.com/forum/thread/700>
- Erdős–Szekeres (1978):
  <https://www.renyi.hu/~p_erdos/1978-46.pdf>
- Lean statement and helper lemmas, pinned commit:
  <https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/700.lean>

The canonical page was still open on 23 July 2026, with zero claimed proofs and
no user marked as currently working on it. The forum says the second
subquestion is the plausible route but gives only families conditional on
unproved prime patterns.

## Discovery policy

Inference is the main compute. Start by deriving a usable `p`-adic
characterization of `f(n)` from Kummer/Lucas and map exactly what an infinite
family must force for every `1 < k <= n/2`. Try structurally different
families, theorem transfer, and unconditional prime-distribution inputs.

A small program may test a stated family or falsify a lemma. It may not become
an open-ended census of `n`. Every exact job must state its hypothesis,
information gain, decision rule, and bounded pilot.

Web and GitHub search are enabled. Audit every apparently new theorem before
using it, and distinguish an unconditional input from a heuristic or
conjecture.

## Required completion artifact

Write a complete proof or counterexample in `research-note.md`, with every
external theorem stated precisely. If the result survives adversarial review,
also create `solution.lean` against
`FormalConjectures.ErdosProblems.«700»` and `candidate.json` containing exactly
`{"answer":"true"}` or `{"answer":"false"}`. According to that committed
answer, expose `Campaign.result` with exactly one of these types:

```lean
answer(True) ↔
  {n : ℕ | ¬ n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}.Infinite

answer(False) ↔
  {n : ℕ | ¬ n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}.Infinite
```

Do not combine the two alternatives into a disjunction: that is classically
trivial and does not answer the problem. Do not use `sorry`, `admit`, new axioms, the
open theorem `Erdos700.erdos_700.parts.ii`, or any equivalent assumption of the
target. Freeze the proof, source audit, and Lean file together.

If a complete result is not reached, return the strongest checked lemma and the
single exact missing statement whose proof would close the route.
