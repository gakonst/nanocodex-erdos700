# Erdős 700(i): structural classification beyond the multiplier scan

## Research posture

You are closing a classification problem for publication, not merely verifying
an existing formal equivalence. A correct Kummer expansion already exists. The
single objective is to replace its raw scan over admissible multipliers by a
community-legible structural theorem.

Do not spend the first wave reproving the checked boundary-antichain theorem,
rerunning a generic finite census, or renaming the multiplier condition.
Every worker must attack the coupled cross-base feasibility problem itself.

## Immutable mathematical targets

For composite `n > 1`, define

```text
f(n) = min_{1 < k <= n/2} gcd(n, binomial(n,k)).
```

The original 1978 formulation uses

```text
Q(n) = max { p^a : p^a exactly divides n },
```

the greatest exact prime-power component of `n`, and asks to characterize the
composite integers satisfying

```text
f(n) = n / Q(n).                                      (H)
```

The maintained Formal Conjectures formulation instead uses the largest prime
divisor `P(n)` and asks for

```text
f(n) = n / P(n).                                      (M)
```

These are different (`n=12` separates them). The publication target is (H).
Any modern result for (M) must be labeled separately. Ideally derive both from
one parameterized structural theorem.

## Audited starting point

The repository already contains a kernel-checked modern theorem

```lean
Erdos700PartI.f_eq_div_iff_boundarySafe :
  Erdos700.f n = n / Erdos700.P n ↔ BoundarySafe n
```

for composite `n>1`, with no `sorryAx`. Its right side uses divisibility-minimal
`d|n` above the baseline and asks whether there exists

```text
1 <= m <= floor(n/(2d))
```

such that simultaneous prime-power carry inequalities hold at `k=d*m`.
This is an exact finite Kummer/boundary normal form. It is not yet accepted as
the intended historical classification because it still scans the full
multiplier interval and repackages the original all-index obstruction.

The historical prime-power witness has only been partially formalized. Do not
silently replace `Q(n)` by `P(n)`.

## Mandatory recovery

Use `inspect_research_artifacts`; never read any `events.jsonl`.

Read every source and audit under:

- `proof/PartIWork/`
- `proof/PartIWork.lean`
- `proof/PartIVerify.lean`
- `proof/scripts/verify-part-i.sh`

Recover the directly relevant retained reports and exact certificates from:

- `runs/math-1784843263-47597/`
- `runs/math-1784850943-109101/`
- `runs/math-1784859934-190817/`

Treat prior model prose as candidate evidence only. The checked Lean
declarations and independently recomputed certificates are the trusted base.

## What counts as structural progress

The unresolved predicate is:

> For a minimal threshold divisor `d`, does one common multiplier `m` satisfy
> simultaneous shortened carry constraints in the different prime bases
> dividing `d`?

A promoted characterization must do at least one of:

1. decide realizability directly from the prime-power factorization and digit
   geometry without enumerating all `m <= n/(2d)`;
2. reduce realizability to a canonical finite automaton, residue-cylinder
   intersection, or finite congruence object whose state graph is described
   directly from the factorization and whose nonemptiness is decided
   symbolically rather than by the original multiplier scan;
3. give a recognizable exhaustive taxonomy of the equality cases, possibly
   stratified by prime-power pattern, with a proof that all composites fall
   into the stated classes.

Merely defining `GoodMultiplier`, `Realized`, `CarrySafe`, an equivalent SAT
instance with one variable per multiplier, or a set whose nonemptiness restates
the original search does not count. A complexity or certificate-size bound
relative to the factorization input is strongly preferred.

## Ten-worker clean batch

Launch exactly ten independent workers concurrently. Each must return an exact
quantified theorem with proof, a counterexample to a proposed simplification,
or one smallest explicit unproved implication.

1. **Factorization-classification architect.** Seek a closed theorem in terms
   of the ordered exact prime-power components. Handle (H) first and derive (M)
   separately. Explain how the theorem decides every composite integer.

2. **Cross-base digit-feasibility specialist.** Analyze simultaneous carry
   inequalities as intersections of base-`p` digit cylinders. Prove a
   nonemptiness/emptiness theorem that avoids scanning the multiplier interval.

3. **Automata and logic specialist.** Build a canonical product automaton,
   Presburger-style system, or transducer for the common multiplier. Prove
   exactness, a state/certificate bound, and a symbolic emptiness criterion.
   Reject an automaton that simply has one state per candidate multiplier.

4. **Divisor-poset and antichain specialist.** Exploit minimal threshold
   divisors and monotonicity between their prime-power supports. Seek a finite
   obstruction basis or dominance theorem reducing the number of boundaries
   and multiplier patterns that must be considered.

5. **CRT/residue-cylinder closer.** Convert shortened carries into explicit
   modular intervals and prove a Helly-, CRT-, or lattice-type intersection
   theorem using structure forced by the common integer `n`. Audit all
   wraparound and half-range conditions.

6. **Squarefree three-prime classifier and lifting specialist.** Complete the
   strongest current three-prime stratum as a clean iff, then determine whether
   it lifts by induction, component merging, or a minimal-counterexample
   argument. Return the first exact obstruction if lifting fails.

7. **Repeated-prime-power and historical-baseline specialist.** Complete the
   `Q(n)` witness, prime-power exception, and parameterized boundary theorem.
   Then use repeated-power structure to simplify multiplier feasibility rather
   than merely formalizing the old scan.

8. **Certificate-complexity specialist.** Seek short positive and negative
   certificates for boundary realizability whose size is polynomial or
   otherwise explicitly bounded in the factorization encoding length. Prove
   soundness and completeness.

9. **Adversarial no-go/refinement specialist.** Attack every tempting closed
   criterion on `12,18,30,78,136,195`, repeated powers, and purpose-built
   cross-base examples. If no simple taxonomy can survive, prove a precise
   lower-bound or coupling theorem that tells the other workers what a valid
   characterization must retain.

10. **Blind closer and community referee.** Starting only from the exact
    statement and checked weight identity, seek an independent classification.
    Separately judge whether proposed outputs are genuinely more informative
    than Kummer-expanded exhaustive search.

## Adaptive synthesis

After all ten reports:

1. Build an implication tree separating proved, falsified, and open nodes.
2. Collapse equivalent repackagings and reject renamed multiplier scans.
3. Select the strongest structural proposal.
4. Use at least three retained follow-ups to prove its smallest missing lemma
   and three fresh follow-ups to falsify exactly that lemma.
5. If it fails, pivot representations materially.
6. Maintain the historical `(H)` and modern `(M)` statements separately in
   every synthesis.

Model inference is the primary compute. Exact jobs may falsify named lemmas or
verify a completed criterion but may not substitute a larger census for the
universal theorem.

## Mandatory regressions

- `n=12`: historical equality holds while the modern equality fails.
- `n=8`: historical equality fails because `Q(8)=8` but `f(8)=2`.
- `n=18`: repeated prime-power component with nontrivial coprime cofactor.
- `n=30`: equality case.
- `n=78,d=39,m=1`: included-endpoint obstruction.
- `n=136,d=34,m=2`: refutes testing only `m=1`.
- `n=195`: refutes divisor-only witnesses and independent primewise choices.

A finite scan through composite `n<=1000` is a regression gate only.

## Completion gate

A successful campaign must produce:

1. a self-contained structural iff for the historical target (H);
2. a proof that the criterion eliminates the raw multiplier enumeration or a
   rigorous argument that its canonical compact object is the classification;
3. the corresponding modern statement (M), clearly separated;
4. complete Lean formalization with no `sorry`, `admit`, local axioms, unsafe
   bypass, or invocation of the upstream open theorem;
5. independent mathematical, statement-alignment, and community-value audits;
6. `candidate.json`, `candidate.md`, `research-note.md`, `source-audit.md`, and
   successful deterministic verification.

Do not freeze or verify the already-known `BoundarySafe` theorem by itself.
If the structural gate remains open, preserve the strongest unconditional
upgrade and state the single first missing theorem precisely.
