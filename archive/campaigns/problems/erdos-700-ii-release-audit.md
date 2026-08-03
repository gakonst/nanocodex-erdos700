# Erdős Problem 700(ii): release, reproducibility, and adversarial audit

## Immutable target

Audit and release the existing claimed solution of Erdős Problem 700(ii).
Do not rediscover a nearby theorem and do not weaken or alter the statement.
The exact theorem that must survive every gate is:

```lean
theorem Erdos700PNT.erdos_700_ii :
    {n : ℕ | ¬n.Prime ∧ 1 < n ∧
      (Erdos700.f n) ^ 2 > n}.Infinite
```

Here `Erdos700.f` is the pinned Formal Conjectures definition

```lean
noncomputable def Erdos700.f (n : ℕ) : ℕ :=
  sInf {m | ∃ k, 1 < k ∧ k ≤ n / 2 ∧
    m = Nat.gcd n (n.choose k)}
```

This campaign is complete only if the mathematical proof, exact statement,
Lean proof term, transitive axiom set, clean reproducibility path, CI path,
literature position, and public exposition have each been checked
independently.

## Existing candidate

Read the existing source before assigning work:

- `proof/Solution.lean`;
- every imported local Lean file reachable from `proof/Erdos700PNT.lean`;
- `proof/Verify.lean` and `proof/scripts/verify.sh`;
- `proof/README.md`;
- `proof/docs/proof.md`;
- `proof/docs/statement-audit.md`;
- `docs/methodology.md`;
- `.github/workflows/lean.yml`;
- completed reports and exact-job artifacts from prior runs with this same
  theorem.

Never inspect any `events.jsonl`.

The candidate route uses only the prime number theorem plus a finite packing
lemma to construct unbounded prime triples `p < q < r` with
`q-p < r-q` and a cubic separation condition. A Lucas-theorem argument then
shows that every admissible binomial coefficient retains at least two prime
factors of `p*q*r`, yielding `f(p*q*r)^2 > p*q*r`.

Treat all of that as a candidate to attack, not as true because it is already
written or compiles.

## Required worker portfolio

Launch these as genuinely independent assignments. Prefer one batch for the
known roles and retain every report.

1. **Blind mathematical referee.** Reconstruct the complete proof from the
   Lean declarations and prose. Check the PNT extraction, box endpoints,
   logarithmic occupancy bound, asymmetric-gap lemma, cubic inequality,
   Lucas omissions, passage from divisibility to the exact minimum, strict
   inequality, unboundedness, and unbounded-set-to-infinite conversion.
   Identify the first false or under-justified step, or issue a line-item
   referee acceptance.
2. **Hostile structural auditor.** Focus only on the three prime-omission
   arguments and their assembly. Attack repeated uses of natural subtraction,
   digit/carry boundaries, ordering and primality hypotheses, the full range
   `1 < k ≤ n/2`, and the claim that at least two of `p,q,r` divide every
   relevant binomial coefficient. Search for small counterexamples to each
   simplification, without treating finite testing as proof.
3. **Lean kernel and dependency auditor.** Build the exact pinned target,
   inspect every transitive import, scan repository Lean sources for
   `sorry`, `admit`, local `axiom`, unsafe shortcuts, or use of the upstream
   open-conjecture theorem, and run `#print axioms` on the final theorem and
   every promoted load-bearing theorem. Confirm whether the exact dependency
   set is `[propext, Classical.choice, Quot.sound]`.
4. **Statement-alignment auditor.** Compare the original public wording, the
   pinned definition, and the formal theorem. Check compositeness, the floor
   in `n/2`, non-emptiness of the minimum, equivalence of strict square and
   square-root inequalities over naturals, and `Set.Infinite`. Reject any
   answer that proves only arbitrarily large candidates without completing
   the set-theoretic implication.
5. **Reproducibility and CI auditor.** Verify the pinned Lean, Mathlib, Formal
   Conjectures, and PrimeNumberTheoremAnd revisions; exercise
   `proof/scripts/verify.sh`; inspect `.github/workflows/lean.yml`; make sure
   CI builds the right root and then audits the same theorem. Fix only
   concrete reproducibility defects and record exact commands, versions,
   exit codes, and retained logs.
6. **Fresh literature and novelty auditor.** The lead must perform current web
   search and give this worker the resulting primary-source URLs. Search the
   exact Erdős 700(ii) statement and its closest theorem/citation
   neighborhood, not just the problem page. Separate “mathematically
   correct,” “apparently new,” and “accepted/adjudicated.” Record authors,
   titles, dates, URLs, query coverage, and the closest prior result. Never
   infer novelty merely because the problem page still says open.
7. **Exposition and release editor.** Assuming only claims that survived the
   other audits, make the human proof, statement audit, verification guide,
   methodology case study, and repository map mutually consistent. Preserve
   a sharp attribution boundary between model inference, deterministic
   verification, prior literature, and human/operator decisions. Do not make
   an adjudication or priority claim.

Keep at least the blind referee and novelty audit independent of the favored
proof narrative. Worker agreement is not proof.

## Deterministic verification

The campaign is already launched inside the pinned Nix development shell.
Use the shell directly; do not invoke a nested `nix develop` from a mutable
run directory.

From the repository root, the mandatory deterministic gate is:

```text
cd proof
./scripts/verify.sh
```

The flake supplies `elan`, and `proof/lean-toolchain` pins Lean 4.27. Do not
replace it with nixpkgs' unpinned `lean4`.

Also verify the CI-equivalent second phase:

```text
cd proof
ERDOS700_SKIP_BUILD=1 ./scripts/verify.sh
```

No `sorry`, `admit`, new local axioms, unsafe proof bypass, or invocation of
`Erdos700.erdos_700.parts.ii` is permitted. Never edit the theorem, dependency
pins, verifier, or CI merely to make a failing candidate pass.

## Required retained artifacts

Produce or update:

- `proof/docs/referee-report.md`;
- `proof/docs/structural-audit.md`;
- `proof/docs/statement-audit.md`;
- `proof/docs/literature-audit.md`;
- `proof/docs/reproducibility-audit.md`;
- `proof/docs/release-checklist.md`;
- `proof/compile.log`;
- `proof/axioms.log`;
- any necessary corrections to `proof/README.md`, `proof/docs/proof.md`,
  `docs/methodology.md`, `proof/scripts/verify.sh`, or
  `.github/workflows/lean.yml`.

The reports must cite specific declarations and line/file locations. Build
and axiom logs must be raw retained output, not summaries invented after the
fact.

## Completion decision

Freeze the exact repository candidate after all fixes, run the configured
verifier against the frozen candidate, and report one honest status:

- `verified` only if all mathematical, formal, statement, dependency, and
  reproducibility gates pass;
- `strong-candidate` if the proof is complete but fresh expert/literature
  validation remains;
- `partial` or `refuted` with the smallest exact failed lemma otherwise.

Novelty and public adjudication are separate from proof correctness. State
them separately even if the theorem is kernel checked.
