# Hardware-synthesis game selection

Screened on 23 July 2026. These are proposed research games, not claims that a
bounded campaign will set a record.

## Capital-allocation question

The useful question is not simply whether a field is theoretical or commercial:

> Where can roughly $50,000 of additional model, solver, and CPU compute have
> the largest marginal effect on a verified research result?

Theory can be commercially neglected while still lying on a densely worked
academic efficient frontier. Conversely, commercially important hardware
problems may be poorly explored in the open because industrial tools, designs,
PDKs, and results are proprietary. The target should therefore be selected on
marginal compute leverage rather than field labels.

## Hard gates

The first six extend the mathematical campaign gates. The last four are
hardware-specific.

1. Success is a finite circuit, controller, synthesis program, or independently
   checkable certificate.
2. The verifier and scoring rule can be frozen before discovery.
3. The benchmark, baseline, and best-known result are public and versioned.
4. A phase-one run has a bounded artifact, compute budget, and kill rule.
5. At least three materially different search representations are available.
6. Correctness, score, novelty, and significance are audited separately.
7. The score is deterministic or its noise can be bounded by a preregistered
   repeated-measurement protocol.
8. A candidate cannot win by changing the specification, undefined behavior,
   parser quirks, timing constraints, cell library, or tool version.
9. Verification is materially cheaper than discovery.
10. More compute expands a useful search frontier rather than merely repeating
    an experiment blocked on proprietary data, fabrication, or human review.

## Marginal-compute score

Each dimension is scored from 1 (poor) to 5 (excellent):

- `V`: exactness and independence of verification;
- `E`: elasticity of useful search with more compute;
- `N`: neglect and realistic distance from the efficient frontier;
- `O`: openness of benchmarks, tools, and baseline artifacts;
- `T`: transfer of a win beyond one benchmark;
- `P`: credible publication, competition, or upstream-recognition channel.

| Rank | Game | V | E | N | O | T | P | Total | Main risk |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| 1 | Exact Boolean/LUT synthesis records | 5 | 5 | 3 | 5 | 5 | 5 | 28 | Benchmark specialization |
| 2 | Reactive controller synthesis | 5 | 4 | 4 | 5 | 4 | 5 | 27 | Requires solver-level innovation |
| 3 | Cryptographic arithmetic circuits | 5 | 4 | 3 | 4 | 5 | 4 | Baseline fragmentation |
| 4 | Quantum/reversible circuit optimization | 4 | 5 | 4 | 4 | 3 | 4 | Near-term significance is uneven |
| 5 | Open RTL-to-GDS PPA optimization | 3 | 4 | 3 | 4 | 5 | 4 | Tool noise and benchmark overfitting |
| 6 | Formally checked RISC-V core optimization | 4 | 3 | 2 | 4 | 5 | 4 | $50K is small relative to design complexity |
| 7 | Analog/mixed-signal synthesis | 2 | 3 | 4 | 2 | 5 | 3 | PDK, simulation, and fabrication bottlenecks |

The ordering deliberately penalizes applied games where the scarce input is
proprietary design context or fabrication rather than compute.

## 1. Exact Boolean and LUT synthesis

### Why it is the first choice

The [EPFL combinational benchmark suite][epfl] maintains public best-known
LUT-6 implementations and invites improved BLIF submissions. EPFL performs
combinational equivalence checking before publishing a result. The
[`v2025.1` record artifacts][epfl-release] are recent rather than abandoned:
between the 2023 and 2025 releases, records improved across arithmetic and
control benchmarks through exact subcircuit synthesis, information-graph
resubstitution, mixed structural representations, reinforcement learning, and
tuned ABC scripts.

This is a rare combination:

- a candidate is a compact circuit;
- correctness and LUT count are machine-checkable;
- evaluation can be seconds or minutes rather than a fabrication cycle;
- the search space supports scripts, rewrites, decompositions, SAT/QBF exact
  synthesis, and direct structural construction;
- the record repository and IWLS provide an external recognition channel.

The weakness is significance: a one-LUT record is real, but a transferable
synthesis method is more important than a benchmark-only artifact. The
campaign must therefore retain the discovered program or rewrite and evaluate
it on a preregistered holdout set.

### Recommended first record game

**Target:** improve the EPFL LUT-6 *size* record for `priority`, currently 92
LUT-6 cells in release `v2025.1`.

**Success artifact:** one BLIF circuit with:

1. exactly the reference primary-input and primary-output interface;
2. no sequential state, black boxes, unsupported directives, or don't-care
   specification changes;
3. every logic node having fan-in at most six;
4. fewer than 92 LUT nodes;
5. equivalence to the frozen EPFL `priority` reference accepted by two
   independent checking routes;
6. a complete, replayable derivation from a frozen seed and toolchain.

**Why `priority` first:**

- the record moved from 93 to 92 between the 2023 and 2025 releases, so it is
  neither obviously abandoned nor changing only through massive infrastructure;
- the artifact and evaluator are small enough for a high-throughput first run;
- priority encoders have exploitable hierarchy and decomposition structure;
- even failure can produce exact lower bounds for selected subcircuits or a
  reusable search method.

**Secondary portfolio:** run the same method on `voter` size (1165 LUTs) and
`multiplier` size (4314 LUTs). `voter` emphasizes symmetric threshold
structure; `multiplier` emphasizes arithmetic structure and commercial
transfer. A record on any one is a campaign success, but method claims require
the frozen holdout evaluation.

### Frozen verifier

The host verifier should:

1. parse and canonicalize BLIF itself before invoking external tools;
2. reject latches, black boxes, don't-cares, mismatched ports, excessive
   fan-in, duplicate names, and unsupported syntax;
3. count LUT nodes independently;
4. run pinned Berkeley ABC combinational equivalence checking against the
   immutable reference;
5. run a second miter through pinned Yosys/EQY plus an independent SAT solver;
6. record tool revisions, commands, exit status, logs, artifact hashes, and
   resource use;
7. require strict improvement over the frozen `v2025.1` threshold.

Random simulation is a cheap screen, never the acceptance gate.

### Search representations

1. Evolve ABC command programs, with a content-addressed population and
   correctness checks after every mutation.
2. Mine high-cost cones and use SAT/QBF exact synthesis or resubstitution on
   bounded subcircuits.
3. Reconstruct the priority encoder from hierarchical Boolean decompositions
   and optimize the decomposition tree.
4. Switch among AIG, XAG, MIG, and LUT-network representations before mapping.
5. Learn route selection from failed and successful local rewrites without
   allowing a learned scorer to replace equivalence checking.

### Phase-one budget and kill rule

- Reproduce the three frozen records and both verification paths first.
- Spend at most 48 wall-clock hours or a preregistered candidate-evaluation
  budget on the first campaign.
- Stop any route after its local score has not improved for its assigned
  mutation budget.
- If no record is found, report the best verified non-record circuits, exact
  subcircuit bounds, cross-benchmark transfer, unique candidates evaluated,
  and cost. Do not relabel a tied score as a breakthrough.

## 2. Reactive controller synthesis

[SYNTCOMP][syntcomp] is an annual open competition for synthesizing reactive
systems. Solutions in synthesis tracks are circuits and are model checked;
the [rules][syntcomp-rules] specify AIGER outputs and independent checking.
The 2026 LTL synthesis track still had a meaningful coverage frontier: the
leading configuration solved 1,248 of 1,505 selected instances, while solution
quality was scored separately.

This is arguably the best *grant* target. It is theory-adjacent, dominated by
formal-methods researchers rather than semiconductor capital, has hidden
competition selections to resist benchmark overfitting, and converts better
algorithms and compute into verified controllers. A $50K grant could support:

- portfolio and route-selection training;
- decomposition and unrealizability-certificate research;
- smaller winning-strategy synthesis;
- focused attacks on families unsolved by all public solvers.

It ranks below EPFL for an immediate Nanocodex campaign because the decisive
artifact is usually a better solver, not a single small circuit.

## 3. Cryptographic arithmetic circuits

Candidate games include exact area/depth optimization of AES S-boxes, Keccak
round logic, NTT butterflies, and finite-field multiplication used by proof
systems. They offer exact bit-vector specifications and strong transfer value.
The main prerequisite is a frozen, source-backed baseline table: different
papers often use incomparable gate libraries, latency assumptions, or
technology mappings. No campaign should begin until those conventions are
normalized.

## 4. Quantum and reversible circuits

Fault-tolerant quantum compilation has exact resource objectives such as
T-count and two-qubit-gate count. Recent work continues to improve T-count
algorithms, and [Quartz][quartz] exposes an independent circuit-equivalence
verifier. This area is compute-elastic and relatively academic, but the
practical value of a record varies sharply with the gate set and hardware
model. It should be treated as a separate domain pack rather than mixed into
the classical RTL verifier.

## Deferred games

### RTL-to-GDS parameter search

[OpenROAD Flow Scripts][orfs] provides an open RTL-to-GDS flow, public
platforms, test designs, restartable stages, and PPA reports. It is valuable
for transfer testing after a logic-level win. It is not the first record game:
placement and routing introduce run-to-run and tool-version sensitivity, and
many apparent wins are benchmark-specific parameter tuning.

### RISC-V core optimization

[`riscv-formal`][riscv-formal] and Yosys/SymbiYosys provide a credible
correctness layer, while OpenROAD can measure PPA. The search space and
verification burden are much larger than the LUT game, and a $50K campaign is
unlikely to match the integrated knowledge of commercial CPU teams. Revisit it
after the harness demonstrates transfer on combinational and reactive
synthesis.

### Analog and mixed-signal synthesis

This may be genuinely neglected in open research, but simulator models,
proprietary PDKs, corners, layout parasitics, and fabrication make verification
slow and contestable. It fails the present “verification cheaper than
discovery” gate.

## Grant strategy

If the objective is ecosystem leverage rather than only an internal record,
fund a paired program:

1. an open compute pool for exact logic and reactive synthesis teams;
2. required publication of failed routes, tool revisions, evaluation scripts,
   and candidate artifacts;
3. a small independent verifier and benchmark-maintenance budget;
4. bonus allocation for methods that improve a hidden holdout or a second
   representation, not merely one public instance.

This avoids paying only for leaderboard hill-climbing and makes the compute
grant produce durable open infrastructure even when no record falls.

[epfl]: https://www.epfl.ch/labs/lsi/page-102566-en-html/benchmarks/
[epfl-release]: https://github.com/lsils/benchmarks/releases/tag/v2025.1
[syntcomp]: https://www.syntcomp.org/syntcomp-2026-results/
[syntcomp-rules]: https://www.syntcomp.org/rules/
[quartz]: https://github.com/quantum-compiler/quartz
[orfs]: https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
[riscv-formal]: https://github.com/YosysHQ/riscv-formal
