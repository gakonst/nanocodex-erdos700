# Erdős Problem 700(i): publication-level release and characterization gate

## Immutable mathematical target

For composite `n > 1`, define

```text
f(n) = min_{1 < k <= n/2} gcd(n, binomial(n,k))
```

and let `P(n)` be the largest prime factor of `n`.

The historical task is to characterize those `n` for which

```text
f(n) = n / P(n).
```

Audit and, if necessary, strengthen the existing boundary-antichain theorem:

```lean
theorem Erdos700PartI.f_eq_div_iff_boundarySafe
    (n : ℕ) (hn : 1 < n) (hnprime : ¬ n.Prime) :
    Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

No weakening, restricted factorization class, density statement, or finite
computation counts as completion.

## Required recovery

Read:

- every source and Markdown file under `proof/PartIWork/`;
- `proof/PartIWork.lean`;
- `proof/PartIVerify.lean`;
- `proof/scripts/verify-part-i.sh`;
- `.github/workflows/lean.yml`;
- every report and exact-job record under
  `runs/math-1784850943-109101/`;
- the earlier audit artifacts under `runs/math-1784843263-47597/`.

Never inspect any `events.jsonl`.

The existing theorem has already compiled once. Treat compilation as evidence
about the formal term, not as proof that the right-hand predicate meets the
historical meaning of “characterize.”

## Definitions that must remain independent

`Boundary n d` means:

1. `d | n`;
2. `P(n) < d`;
3. `d/p <= P(n)` for every prime `p | d`.

`Realized n d` means that there is `m > 0` with `d*m <= n/2` and, for every
prime `p | d`,

```text
residueCarryCount n (d*m) p
  <= factorization(n,p) - factorization(d,p).
```

`BoundarySafe n` says no boundary divisor is realized.

The predicate may be strengthened or replaced by an extensionally equal
one, but it must not mention `f`, gcds, binomial coefficients, or invoke
`Erdos700.erdos_700.parts.i`.

## Independent worker portfolio

Launch all roles independently before synthesis.

1. **Blind mathematical referee.** Reconstruct both directions from the Lean
   declarations alone. Audit positivity, divisibility orientation, numerical
   versus componentwise order, natural subtraction, all quantifiers, and the
   endpoint `k=n/2`. Return the first invalid declaration or a line-item
   acceptance.
2. **Lean kernel/dependency auditor.** Build the pinned `PartIWork` target,
   run `PartIVerify.lean`, scan the entire local import closure for
   placeholders or prohibited upstream conjecture use, and independently
   inspect the transitive axiom set of every promoted theorem.
3. **Counterexample and mutation auditor.** Reproduce the exhaustive finite
   audit and target the mandatory examples `n=30`, `n=78,d=39,m=1`,
   `n=8,d=4`, and `n=136,d=34,m=2`. Falsify every tempting simplification:
   `m=1`, strict bounds, squarefree-only arguments, non-truncated subtraction,
   or omission of `d|n`.
4. **Historical-statement referee.** Verify the exact 1978 and maintained
   problem wording from primary or canonical sources. Decide separately:
   (a) whether the displayed iff is mathematically exact and independent;
   (b) whether it should reasonably count as a solution to “characterize”;
   (c) what stronger deliverable would remove any ambiguity. Do not infer
   acceptance from compilation.
5. **Structural elimination specialist.** Try to eliminate the remaining
   multiplier search in `Realized`, or reduce it to a factorization-bounded
   set substantially smaller than all admissible indices. Use the quotient
   carry recurrence in `STRUCTURAL_UPGRADE.md`. A complete factorization/digit
   classification for all composites is preferred; otherwise prove the
   strongest unconditional structural upgrade and identify a counterexample
   to the next simplification.
6. **Alternative characterization specialist.** Seek an extensionally equal
   criterion through base-`p` digit shadows, divisor posets, automata, or
   finite congruence systems whose independence from the original minimum is
   unmistakable. It must handle repeated prime powers and nontrivial
   multipliers.
7. **Formal-specification auditor.** Compare the public definition, Formal
   Conjectures' `sInf` definition, natural floor division, compositeness
   hypotheses, and the Lean theorem. Prove that the minimum is nonempty and
   that the theorem quantifies over exactly the intended integers.
8. **Release/reproducibility auditor.** Check the dedicated script and GitHub
   Actions path from a clean pinned environment. Verify that CI builds
   `PartIWork`, not only the Part-(ii) default target, and that raw build and
   axiom logs are retained.

After the first batch, use retained follow-up turns on the strongest
structural proposal and a fresh adversary attempting to refute it.

## Mandatory regressions

- `n=30` must satisfy the characterization.
- `n=78,d=39,m=1` must violate it at the included endpoint.
- `n=8,d=4,m=1` must exercise repeated prime powers and equality in the carry
  budget.
- `n=136,d=34,m=2` must show why testing only `m=1` is invalid.
- A scan through at least all composite `n <= 1000` must compare the exact
  boundary predicate to direct evaluation. This is regression evidence only,
  never the universal proof.

## Deterministic formal gate

The pinned command is:

```text
cd proof
./scripts/verify-part-i.sh
```

The final theorem must have exactly the audited standard dependency set

```text
[propext, Classical.choice, Quot.sound]
```

and no `sorryAx`, `sorry`, `admit`, local axiom, unsafe bypass, or reference
to the upstream open theorem.

## Required artifacts and honest verdict

Produce:

- a mathematical referee report;
- a historical-characterization report;
- a formal dependency and reproducibility report;
- regression certificates;
- a complete prose proof;
- any stronger theorem or counterexample developed by the structural routes;
- raw compile and axiom logs;
- an explicit final verdict using this taxonomy:

  - `FORMALLY VERIFIED CHARACTERIZATION`;
  - `PUBLICATION-GRADE SOLUTION OF PART (i)`;
  - `EXACT REDUCTION, HISTORICAL CHARACTERIZATION STILL AMBIGUOUS`;
  - `REFUTED`, with the smallest failed lemma.

The first label does not automatically imply the second. State exactly which
labels are earned and why. Freeze and run the configured verifier only for a
complete exact candidate.
