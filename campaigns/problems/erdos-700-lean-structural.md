# Erdős 700(ii): formally verify the prime-triple structural lemma in Lean

This is a focused Lean engineering campaign. Do not restart mathematical
discovery and do not formalize Maynard's sieve here.

## Pinned environment

- Formal Conjectures checkout:
  `/home/ubuntu/github/google-deepmind/formal-conjectures`
- Required commit:
  `e751934294a381afd2d5fc1124c5953c8e25f9fa`
- Existing statement/API:
  `FormalConjectures/ErdosProblems/700.lean`
- Informal candidate:
  `campaigns/candidates/erdos-700-maynard/proof.md`
- Independent audits:
  `runs/math-1784832829-1919953/worker-reports/`

Read the repository `AGENTS.md` before editing or compiling.

## Required theorem

Produce a self-contained Lean file, importing
`FormalConjectures.ErdosProblems.«700»`, which proves without `sorry`, `admit`,
new axioms, or the open theorem `Erdos700.erdos_700.parts.ii`:

For natural numbers `p q r a c`, if

- `p.Prime`, `q.Prime`, and `r.Prime`;
- `q = p + a`;
- `r = q + c`;
- `0 < a` and `a < c`;
- with `b = a + c`, `4 * b^3 < p`;

then for every `k` with `1 < k` and `k <= (p*q*r)/2`,

`(Nat.gcd (p*q*r) ((p*q*r).choose k))^2 > p*q*r`.

Also prove `Erdos700.f (p*q*r) = p*q` if feasible; the gcd-square theorem is
the minimum acceptance target.

You may prove sharper helper lemmas. Prefer the blind congruence proof from the
audit if it is easier to encode than explicit digit arrays. Reuse the existing
`Erdos700.prime_dvd_of_not_dvd_choose`, Lucas congruences, factorization,
coprimality, and `omega`/`nlinarith` APIs rather than implementing a numeral
representation library.

## Workflow

1. Search the pinned checkout for exact existing lemmas.
2. Launch clean workers for Lucas API discovery, the three omission pairs,
   gcd assembly, and an independent Lean architecture.
3. Write the candidate only under the assigned run directory.
4. Compile it in the pinned checkout with the repository's pinned `lake`.
5. Run `#print axioms` on the final theorem and retain the output.
6. Adversarially inspect the theorem statement for weakening or quantifier
   mismatch.

## Output contract

- `structural.lean`: compiling proof.
- `compile.log`: exact successful Lean output.
- `axioms.log`: dependencies of the final theorem.
- `statement-audit.md`: mapping to the informal lemma.
- `report.md`: status and any exact remaining Lean goal.

Do not call a file complete unless Lean accepts it.
