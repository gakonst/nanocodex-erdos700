# Erdős 700(ii): Lean integration and exact Maynard trust boundary

This campaign formalizes the infinite-family half of the candidate solution
and attempts the exact Formal Conjectures target. It must be explicit about the
analytic theorem boundary.

## Inputs

- Pinned Formal Conjectures:
  `/home/ubuntu/github/google-deepmind/formal-conjectures` at
  `e751934294a381afd2d5fc1124c5953c8e25f9fa`
- Target:
  `FormalConjectures/ErdosProblems/700.lean`
- Candidate proof:
  `campaigns/candidates/erdos-700-maynard/proof.md`
- Source audit:
  `campaigns/candidates/erdos-700-maynard/source-audit.md`
- Structural formalization campaign: locate the newest run whose problem hash
  corresponds to `campaigns/problems/erdos-700-lean-structural.md`.

Read the pinned repository's `AGENTS.md`.

## Required work

1. Search Mathlib, Formal Conjectures, and its transitive dependencies for an
   already formalized Maynard/Maynard--Tao theorem strong enough to give three
   primes in infinitely many translates of every sufficiently large fixed
   admissible tuple. Record exact search commands and results.
2. Define the narrowest mathematically exact Lean proposition representing the
   one Maynard consequence used by the proof.
3. Without `sorry`, `admit`, or a new axiom, prove that this proposition plus
   the compiled prime-triple structural lemma implies
   `{n : ℕ | ¬ n.Prime ∧ 1 < n ∧ (Erdos700.f n)^2 > n}.Infinite`.
4. Attempt the exact theorem
   `answer(True) ↔ ...Infinite` only if the analytic theorem is already
   available from trusted compiled Lean declarations. Never import or invoke
   `Erdos700.erdos_700.parts.ii`.
5. If no formal Maynard theorem exists, isolate that fact as the single
   remaining trusted boundary. A conditional theorem that compiles and whose
   only explicit hypothesis is the exact Maynard consequence is still required.
6. Run `#print axioms` on every completed theorem and audit the exact statement.

The purpose is maximum honest formalization, not fooling the frozen verifier.
Do not introduce a source axiom merely to make the file compile.

## Output contract

- `integration.lean`: compiling conditional integration theorem and, if
  possible, the exact target.
- `compile.log`
- `axioms.log`
- `maynard-formalization-inventory.md`
- `statement-audit.md`
- `report.md`

No model consensus counts as a formal proof. No `sorry`, `admit`, or new axiom
is permitted in the output Lean file.
