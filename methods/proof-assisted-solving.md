# Proof-assisted solving

Proof assistance is most valuable as an interactive search environment, not as
a ceremonial final translation after the informal proof is declared done.

## Three workflows

### Formalization-first

1. A human or trusted translator freezes the exact theorem statement.
2. Add small test lemmas that validate definitions against known examples.
3. The agent decomposes the target into helper lemmas.
4. Every edit is compiled immediately.
5. Open goals and type errors become the next prompts.
6. The final dependency closure is scanned for unfinished proof steps and
   unexpected axioms.

Best when the domain already has strong libraries and statement drift is a
major risk. AlphaProof Nexus and the QAOA project use variants of this pattern.

### Informal discovery, formal audit

1. Model or human develops an informal candidate.
2. Freeze both an exact natural-language statement and the proof draft.
3. A separate formalizer encodes the theorem and dependencies.
4. Compiler failures identify missing lemmas or incorrect generality.
5. A statement-alignment reviewer compares the final declaration with the
   original target.

Best when representation work would otherwise consume the entire search budget.
The Grothendieck counterexample and unit-distance follow-up illustrate this.

### Hybrid numerical–formal

1. Use Python/CAS/solver tools to search and test conjectured identities.
2. Export a compact exact witness or lemma set.
3. Check finite algebraic components by reflection/native decision procedures
   only when those procedures are inside the trusted policy.
4. Prove the analytic or structural bridge in Lean.

Best for explicit counterexamples, extremal constructions, or inequalities.

## Recommended agent topology

```text
statement curator
      │ freezes target + examples
      ▼
proof architect ──► lemma dependency graph
      │
      ├── formal workers: independent helper lemmas
      ├── computational worker: examples and counterexamples
      └── library scout: existing declarations and theorem hypotheses
      │
      ▼
integration agent ── compile after every patch
      │
      ├── axiom/shortcut auditor
      ├── statement-alignment auditor
      └── informal mathematician audit
```

The statement curator and final alignment auditor should not be the same agent
that optimized the proof code.

## Compiler loop contract

Each formal worker returns:

- exact theorem or lemma name;
- files changed;
- compiler command and exit status;
- remaining goals/errors verbatim;
- axioms used if the theorem closes;
- whether the target statement changed;
- informal explanation of the proof term.

No worker may replace a hard lemma with an equivalent helper containing
`sorry`, add an axiom, or weaken the target. A validator should compare a hash
or normalized AST of the target declaration before and after the run.

## Suggested Lean tool surface

Expose narrow application tools behind Code Mode rather than unrestricted
shell alone:

```text
lean_check(files, timeout)
lean_goal(file, line, column)
lean_declarations(query)
lean_print_axioms(declaration)
lean_scan_shortcuts(paths)
lean_target_fingerprint(file, declaration)
```

The model can then write JavaScript loops that compile several independent
lemmas concurrently and aggregate structured failures without dumping entire
build logs into model context.

## What Lean establishes

Lean establishes that a term inhabits the encoded proposition under the listed
axioms and trusted kernel. It does not by itself establish:

- that the proposition matches the historical problem;
- that definitions encode the intended objects;
- that imported axioms are acceptable;
- that unsafe/native execution was allowed by the evidence policy;
- that the result is novel;
- that generated build scripts are safe to run outside a sandbox.

Use test lemmas, declaration fingerprints, axiom output, prohibited-token scans,
pinned dependencies, sandboxing, and independent mathematical review.

## Nanocodex implementation

Use a clean `spawn_math_agent` for statement translation and another for final
alignment. Use contextual `fork_math_agent` workers for helper lemmas that need
the current informal proof. Retain formal workers with `prompt_math_agent` so
compiler failures can be repaired without repeatedly reloading the full local
context.

Code Mode should own the loop:

```js
for (let round = 0; round < 8; round++) {
  const checks = await Promise.all(lemmaAgents.map(a =>
    tools.prompt_math_agent({
      agent_id: a.agent_id,
      task: "Compile your lemma, inspect the exact remaining goals, and repair only justified gaps."
    })
  ));
  if (checks.every(x => x.report.includes("KERNEL_CHECKED"))) break;
  text({ round, checks });
  await yield_control();
}
```

The production system should replace string status detection with structured
tool results and a host-side acceptance predicate.
