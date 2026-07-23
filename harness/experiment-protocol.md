# Experiment protocol

## Purpose

Evaluate the complete model–harness system while preserving enough evidence to
distinguish autonomous discovery, assisted discovery, literature retrieval,
formalization, and verification.

## Before the run

1. Archive the exact problem source and date.
2. Record whether the result was believed open and by whom.
3. Freeze the exact target and acceptance tests.
4. Choose and record a web policy.
5. Pin model mode/effort, prompts, tools, solver/prover environments, budgets,
   and random seeds.
6. Decide whether the experiment measures independent discovery or practical
   problem resolution. The appropriate search policy differs.
7. Pre-register which human interventions are allowed.

## During the run

- retain all turns, steering, tool calls, search queries/results, and artifacts;
- do not silently restart from a favorable partial answer;
- record every model instance and branch lineage;
- keep failed routes and verifier failures;
- enforce tool timeouts, bounded output, and process cleanup;
- sandbox generated proof and computation code;
- require exact status transitions.

## After a candidate

1. Freeze the candidate bundle.
2. Run blind mathematical audits.
3. Run the appropriate exact/formal/computational verifier.
4. Compare formal and natural-language statements.
5. Run a separate novelty/literature audit.
6. Record operator contributions and any repair prompts.
7. Publish denominator statistics: total problems, attempts, candidate rate,
   verified rate, rediscoveries, false proofs, and cost.

## Recommended ablations

- web disabled versus novelty-only versus full research;
- one long agent versus portfolio plus critics;
- clean spawn versus contextual fork;
- direct prompt versus research-manager prompt;
- exploratory-only versus a pre-registered closure-mode steer;
- model-authored `Promise.all` versus host-owned bounded batch fan-out;
- unrestricted shell versus typed domain tools;
- informal-only versus compiler-in-loop;
- model self-review versus clean audit versus exact checker;
- shared prompt cache on/off for cost, not correctness;
- different problem-selection policies.

## Metrics

### Scientific outcome

- exact resolution, stronger theorem, partial lemma, counterexample, record;
- correctness tier;
- novelty classification;
- expert significance assessment.

### Process

- time to first useful lemma and first candidate;
- number and diversity of routes;
- correction rate after adversarial review;
- verifier/compiler iterations;
- search queries and external sources used;
- human interventions;
- tokens, model calls, tool time, and monetary cost.

### Reliability

- false-complete rate;
- statement-drift rate;
- rediscovery rate;
- unproved-load-bearing-lemma rate;
- reproducibility from the retained package.
