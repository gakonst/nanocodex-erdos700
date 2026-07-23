# Reusable prompt patterns

These are abstractions distilled from public runs. They are intended to be
filled with the exact problem and domain-specific verification tools.

## 1. Direct prove-or-disprove

```text
Prove or disprove the following statement exactly as written.

[definitions and statement]

A disproof must give an explicit witness satisfying every hypothesis and an
exact or rigorously bounded verification. A proof must identify every external
theorem used and check its hypotheses. Search both directions before committing.
```

This worked unexpectedly well for the correlation-gap conjecture because the
model invented an LP search and exact certificate without being told to do so.

## 2. Research-manager / conjecture campaign

```text
Resolve the target completely. Partial results, literature summaries, and
reductions to comparably difficult open problems do not count.

Restate the exact completion criteria. Launch independent routes from several
mathematical families. Preserve a ledger of failed lemmas and incompatible
approaches. Search for counterexamples throughout. When a candidate appears,
freeze it and assign fresh adversarial auditors. Do not terminate until the
candidate passes the stated checks or the campaign is honestly blocked.
```

The CDC prompt further enumerated likely graph-theoretic traps and told the
system to continue for many hours before considering failure.

## 3. Frozen Lean target

```text
The theorem declaration is immutable. You may add definitions and helper
lemmas, but you may not weaken or edit the target. After every change, compile.
Treat compiler errors and open goals as the next search state. The final result
must contain no sorry/admit, introduce no project-specific axioms, and pass the
statement-alignment audit.
```

Add test lemmas for initial sequence values or finite examples when the formal
definition itself may be mistranslated. AlphaProof used this against OEIS
misformalization.

## 4. Computational discovery and certification

```text
Translate the claim into a finite parameterized search where possible. Explore
small instances and several natural object families. Floating-point output is a
lead only. Rationalize or algebraize the best witness, then produce an exact,
interval, primal/dual, or exhaustive certificate that can be checked without
trusting the search process.
```

## 5. Independent novelty audit

```text
Assume the candidate theorem and proof are correct. Determine whether the exact
statement, a stronger theorem, or a short corollary already exists. Search by
mathematical ingredients and implications, not only by the problem's current
name. Return exact citations and explain the logical implication.
```

This is necessary because several apparent AI discoveries were already implied
by old results: AlphaProof's Erdős #846, the Tango-bundle example, and the
Laguerre-tessellation proposition.

## 6. Adversarial proof audit

```text
Try to invalidate the candidate. Do not improve its exposition until you have
tested every quantifier, limiting step, dependency, global compatibility
condition, exceptional case, and numerical-to-exact transition. Produce the
smallest failing instance for any defect. If it survives, output a dependency
graph and the strongest remaining uncertainty.
```

## 7. Completion-pressure steering

A public Dinitz–Garg–Goemans counterexample run reportedly received four short
steers after the initial assignment:

```text
Construct a counterexample to the general non-planar case. Find a structured
counterexample, not merely numerical evidence.

Continue the research and find a complete unconditional counterexample.

Continue the search. Replace local patching with a strategy derived from a
deeper understanding of the problem structure.

Enough partial results. Finish with a complete unconditional counterexample.
```

The verbatim final sentence became a meme, but the reusable operation is more
specific than “try harder”: switch from exploration to closure, reject
conditional reductions, require an explicit witness, and spend the remaining
budget on satisfying a frozen acceptance predicate.

Use a safety-qualified version in production:

```text
Enter closure mode. Partial results remain valuable in the ledger but do not
count as resolution. Attempt to complete one exact unconditional candidate and
submit it to the required checker. Do not increase confidence or claim success
unless the checker passes. If no route can meet the gate within the remaining
budget, return blocked with the strongest verified partial result.
```

This preserves completion pressure without creating pressure to fabricate
closure. Sources: [prompt reconstruction](https://x.com/oscar__2025/status/2079969641775149243)
and [contemporary quotation](https://x.com/willdepue/status/2079973929448509612).
