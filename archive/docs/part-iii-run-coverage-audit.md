# Part (iii) persisted-run coverage audit

Date: 2026-07-28, reconciled from `dev-georgios` on 2026-08-03

This is the source-coverage companion to
`docs/part-iii-exploration-map.md`. Its purpose is narrower than the
mathematical synthesis: it records which persisted campaign directories were
actually inspected, what kind of evidence each contains, and where that
evidence is represented in the canonical map. Local Codex and Brave history
is inventoried separately in `docs/part-iii-session-coverage-audit.md`.

## Audit verdict

The retained corpus has **105 top-level run directories**:

- 16 concern Part (i) or Part (ii), not Part (iii);
- 3 are Part-(iii) launch prompts with no returned mathematical artifact;
- 84 contain some Part-(iii) material, ranging from a finite diagnostic or
  worker-only batch to a completed lead report.
- 2 are operational-only artifacts: one pre-sync documentation backup and
  one trace-only directory with no claim-bearing report.

No directory contains a complete unconditional proof of Part (iii), a
verified unbounded counterfamily to the original target, or a target-aligned
accepted verifier result. No `CLAIM_SOLVED`, `STATUS: SOLVED`, accepted target
candidate, or equivalent terminal marker survived a direct filtered-corpus
search.

This does **not** justify the literal claim that no conceivable idea was ever
mentioned and lost. It supports the narrower, checkable claim that every
persisted run directory and every claim-bearing summary or worker-only batch
in the recovered corpus has a disposition below. Raw recorder
`events.jsonl`, telemetry, snapshots, credentials, and build trees were
deliberately excluded.

## Evidence labels

| Label | Meaning |
|---|---|
| `P` | Unconditional partial theorem or exact identity |
| `F` | Exact finite or infinite falsifier of a named method or auxiliary lemma |
| `C` | Conditional implication or explicit open bottleneck |
| `D` | Diagnostic computation only; no asymptotic inference |
| `Q` | Claim retained only in quarantine pending a stronger source/proof audit |
| `I` | Initialization, orchestration, or prompt only |
| `X` | Outside Part-(iii) scope |

The labels concern the content of a run, not the quality of the target
statement. A run may legitimately have more than one label.

## Outside Part-(iii) scope

| Run | Disposition |
|---|---|
| `math-1784840756-35224` | `X`: Part (i), equality cases |
| `math-1784843263-47597` | `X`: Part (i), equality characterization |
| `math-1784850943-109101` | `X`: Part (i), boundary antichain |
| `math-1784853673-138164` | `X`: Part (ii) release-audit prompt only |
| `math-1784859934-190817` | `X`: Part (i), publication release |
| `math-1784861746-211574` | `X`: Part (i), 1978 formulation |
| `math-1784917925-3501879` | `X`: Part (i), structural classification |
| `math-1784923227-3523152` | `X`: Part (i), borrow-tableau formalization |
| `math-1784925707-3532247` | `X`: Part (i), projection theorem |
| `math-1784928184-3622565` | `X`: Part (i), projection theorem |
| `math-1784930103-3681859` | `X`: Part (i), projection theorem |
| `math-1784930588-3685475` | `X`: Part (i), refinement-tree reset |
| `math-1784934017-3704661` | `X`: Part (i), Lean borrow-sum repair |
| `math-1784934017-3704662` | `X`: Part (i), Lean selector fields |
| `math-1784934017-3704663` | `X`: Part (i), Lean boundary/deletion bridge |
| `math-1784934017-3704664` | `X`: Part (i), Lean digit/borrow fields |

## Part-(iii) launches with no returned work

These directories contain `campaign.json` and `problem.md`, but no report,
worker report, proof note, result note, or claim-bearing computation. They are
evidence that a direction was assigned, not that it was explored.

| Run | Assigned direction |
|---|---|
| `math-1785014059-3701` | Vertical prime-power mass |
| `math-1785014416-4588` | \(1<A\le2\) inverse-to-sparsity reset |
| `math-1785021986-135407` | Ten-way new-path reset |

## Maintained and controller runs

| Run | Evidence and terminal disposition | Canonical coverage |
|---|---|---|
| `controller-loop-1784939454-3767068` | `P/C/F`: first-wave implication and dead-end synthesis; no new target result | hard-sequence, Carmichael, boundary-container, and packet branches |
| `erdos700-iii-beyond-a1-reset-20260726` | `P/C`: \(D(n)\ge H_2(n)^2/36\) on the high-height branch; no squarefree-dominant closure | “What was proved before the hard branch” |
| `erdos700-iii-exceptional-row-20260726` | `P/F/C`: sharp concentration staircase, all-order literal phase law, signed factorial detector, and arbitrary-cofactor obstruction | “Averaging, moments, and exceptional rows”; K23, K25, K32 |
| `erdos700-iii-height-uniform-20260726` | `P/F/C`: height-uniform bounded-menu reset and exact transfer limitations | “Direct component and multiplier constructions”; K02, K07, K12, K26, K47 |
| `erdos700-iii-m2-egrs-inverse-route-closure-20260725` | `F`: correct-scale affine inverse theorem, one-sided orientation, and EGRS tuner route closed; \(1<A\le2\) remains open | K14–K16, K40 |
| `erdos700-iii-new-paths-20260725` | `P/F`: adaptive local peeling refuted; adjacent identity proved; diffuse moments, coefficient-unit synchronization, and local recurrence ascent closed | `(ADJ)`; K23, K26, K48 |
| `erdos700-iii-robust-digit-box-20260725` | `P/F/C`: robust prefix-fibre theorem, sharp singleton-escape families, BC-SEC, exact packet adapter, and open `RWER` | “Digit-box and affine routes”; expanded theorem record in the canonical map |
| `erdos700-iii-short-packet-20260726` | `P/F/C`: linked packet-gcd inequality; Wu specialization refuted; determinant and finite-difference routes saturated; no short packet constructed | packet GCD, Pascal/Smith, and punctured-window entries; K38, K55 |
| `erdos700-iii-square-subproduct-20260726` | `P/C`: exact full-depth \(S\)-row classification, adaptive square-subproduct endpoint, two-layer transfer, and open `AU_m`/`EMCC` | “Pair, packet, and balanced-square routes” |
| `erdos700-iii-uhfl-adaptive-cofactor-sum-phase-capacity-20260725` | `P/F/C`: literal adaptive moment rows, homogeneous block extraction, CRT no-go, and open `RAMPC` | UHFL and first-failure phase entries; K27, K29 |
| `erdos700-iii-upper-half-first-layer-frontier-20260725` | `P/C`: hard-sequence classification and exact `UHFL(A)` reduction; original target open for \(A>1\) | hard-sequence theorem and K27 |
| `erdos700-iii-weighted-tuner-20260725` | `D`: exact finite extremal search; no theorem or asymptotic counterfamily | K25 |
| `extremal-lab-20260725` | `D`: exact finite residual-family search; no theorem or asymptotic inference | K25 |
| `outer-loop-1784948761-3803975` | `P/C/F`: synthesis of MR, LAMI, recursive batching, and the adaptive-multiplier gate | `(OWN)`, `(OWN-F)`, LAMI and balanced-square sections |

## Late `dev-georgios` reconciliation

These eight directories were newer than the first 97-directory audit. Only
terminal reports, checks, and compact result files were inspected. Raw
`events.jsonl` and `trace.jsonl` files were not read.

| Run | Evidence and terminal disposition | Canonical coverage |
|---|---|---|
| `audit-sync-backup-20260727` | `I`: pre-sync copy of an older exploration map; no independent mathematical claim | operational artifact only |
| `erdos700-iii-weighted-exchange-20260725` | `I`: trace-only directory with no report or compact claim artifact | no mathematical evidence promoted |
| `erdos700-iii-packet-capacity-20260727` | `P/F/C`: exact packet regressions, support identities, capacity countermodels, and an open signed same-row target; no asymptotic result | “Packet-capacity fork”; K28–K45 |
| `erdos700-iii-audited-max-20260727` | `P/F/C`: alternating-block and constant-cofactor obstructions plus smooth-core extraction `(SCE)`; `(MSLR)` and atom-product charging remain open | “Top-component mass and depth iteration audit”; K66–K69 |
| `erdos700-iii-tm-proof-20260728` | `P/F/C`: verifies the `(TM)` transfer, refutes the proposed depth iteration with a scalable actual-CRT family, and leaves `(FDCR)` open | “Top-component mass and depth iteration audit”; K66–K68 |
| `erdos700-iii-tm-adversary-20260728` | `P/F/C`: proves `(TM)` is equivalent up to constants to the first `log log n` sublevel advance; finds no genuine counterfamily | “Top-component mass and depth iteration audit”; K67–K68 |
| `erdos700-iii-r2-gateway-20260728` | `P/F/C`: exact canonical `R=2` gateway, central-capacity correction, full-support packing no-go, and finite exclusions; dichotomy open | “Canonical single-atom R=2 audit”; K59–K60 |
| `erdos700-iii-r2-representation-20260728` | `P/F/C`: primitive-partition dictionary and inequality `(PPI-S)`, native-theorem transfer audit, and scalable stable carry obstruction; no prime packet family | “R=2 representation-theorem reset”; K61–K65 |

## Chronological Part-(iii) campaign matrix

### Foundational and first residual campaigns

| Run | Evidence and terminal disposition | Canonical coverage |
|---|---|---|
| `math-1784840756-35227` | `I/D`: initialization plus a small primorial pilot; no lead theorem | finite diagnostics only; K25 |
| `math-1784843263-47602` | `P/F/C`: explicit \(A=1\), bounded-\(\omega\), exact carry formulas, fixed-depth CRT isolation, marginal and Giuga no-go results | pre-hard-branch results; K01–K03, K08, K10, K24 |
| `math-1784854035-150609` | `P/F/C`: `UDL(r)` conditional closure and exact global-gap/falsifier package | pair/common-row and fixed-depth entries; K01–K04, K22 |
| `math-1784861421-197355` | `P/F/C`: boundary saturation, depth envelope, Pascal renewal, and open boundary multiplier container | minimal overweight divisors, `(DE)`, `HPCM`; K20 |
| `math-1784862756-235913` | `P/F/C`: scalable endpoint obstruction to SCLO; no bounded compatibility-rank family | deep-prefix and short-interval entries; K02–K04 |
| `math-1784862756-235918` | `P/F/C`: repeated-prime exponent spectrum and complement-divisor failures, including \(n=132\) and an infinite family | all-height spectrum and complement-row entries; K11, K12 |
| `math-1784862756-235920` | `P/C`: central-binomial \(r=1\), ballot-divisor construction, and open uniform carry-loss lemma | central-binomial counterfamily laboratory; K25, K51 |
| `math-1784873765-3291519` | `P/F/C`: rational-cut energy, exact staircase/prefix-lcm identities, changing-centre and finite-stencil obstructions | `(RC)`; K26, K46, K48 |
| `math-1784909933-3467057` | `P/F/C`: dense squarefree reduction, proportional-depth CRT no-go, carry programmability, and packet-rank barriers | mixed-depth, APD, and packet entries; K03, K29 |
| `math-1784913529-3482687` | `P/F/C`: robust BG impossibility, mixed-depth least representative, bounded-index packing, and actual-pattern determinant cover | `(APD)`, mixed-depth gate, K29, K56 |
| `math-1784924875-3528501` | `P/C`: first DFC/fractional-cover batch and deepest-layer reduction; no lead closure | deepest-support cover LP; K06 |
| `math-1784928184-3622566` | `P/F/C`: exact deepest-support LP/minimax theorem and explicit failure of phase-free closure | deepest-support cover LP; K06, K31 |
| `math-1784930103-3681860` | `P/F/C`: lossy boundary/dual capture and `ODHEGC` worker batch; merge/strip preservation remains false or open | `ODHEGC`; K06, K26 |
| `math-1784930103-3681861` | `P/F/C`: upper-band shadow and actual-pattern determinant audit | `(APD)`; K09, K29 |
| `math-1784930588-3685474` | `P/F`: representation reset; quotient descent, primitive-active-product, Newton/LCD, entropy, and Carmichael-square routes attacked | `AQG`, `H_prim`, K49, K51–K54 |

### Carmichael, atom, pair, and auxiliary-bridge campaigns

| Run | Evidence and terminal disposition | Canonical coverage |
|---|---|---|
| `math-1784935021-3712996` | `P/C`: exact Carmichael lcm identities, rank-four/PC4 reduction, and hard-load accounting | fixed-cubic bridge and PC4; K17, K22 |
| `math-1784935021-3712997` | `P/F`: quotient-transference identities and exact `AQG_100` falsifier | rotating descent and `AQG`; K49, K52 |
| `math-1784935021-3712998` | `F`: exact finite counterexamples to `H_prim` | `H_prim`; K53 |
| `math-1784940116-3770583` | `P/F/C`: Carmichael atom cover, fixed divisor-tail alphabet no-go, and fixed-support exponent-ray gates | actual-row Carmichael aggregation; K50, K56 |
| `math-1784940116-3770584` | `P/F/Q`: claimed unbounded squarefree full-support-rank-one family; finite consequences are exact, asymptotic lift remains quarantined | quartet/H-lambda note; K17 |
| `math-1784940116-3770585` | `P/C`: exact six pair systems and PC4 reductions; no proof or asymptotic falsifier in this run | PC4 and pair-language entries; K22 |
| `math-1784941744-3780886` | `F/Q`: exact finite \(H_\lambda\) counterexample plus a claimed prime-tuple lift; the lift is quarantined | finite quartet/fixed-cubic entry; K17 |
| `math-1784941744-3780887` | `F`: exact four-prime PC4 counterexample | finite quartet; K17, K22 |
| `math-1784941744-3780888` | `F/Q`: Maynard-based unbounded \(H_\lambda\) counterfamily claim; primary-source transfer checked and six internal audits passed, but not externally/formally verified | finite quartet and quarantined infinite lift; K17 |

### Worker-only ten-route wave

These ten directories have no terminal lead report. Their
`worker-reports/*.md` files were inspected directly; later controllers
correctly retained only the theorem-level items below.

| Run | Worker-batch disposition | Canonical coverage |
|---|---|---|
| `math-1784942909-3786141` | `P/F/C`: random permutation analogue solved; deterministic profile/median transfer refuted at \(7293\) and abstractly | phase-free averaging; K01, K32 |
| `math-1784942909-3786142` | `P/F/C`: coupled zero-sum encoding exact; Davenport/Kneser/Olson lose the common quotient or miss density | zero-sum/fibre entries; K22, K42 |
| `math-1784942909-3786143` | `P/F/C`: adelic-cylinder formulation; positive-volume/nonconvex and Blichfeldt-difference routes refuted | fibre and geometry-of-numbers entries; K14, K42 |
| `math-1784942909-3786144` | `P/F`: `E3` determinant/Smith bridge refuted at \(n=12\) and on odd semiprimes; localization no-go proved | Smith/exterior entry; K54 |
| `math-1784942909-3786145` | `F`: complete-row moment/AM–GM bridge refuted by rare-row dilution | moment entries; K23, K32 |
| `math-1784942909-3786146` | `P/F/C`: exact block compression; cross-\(n\) and componentwise-envelope descent refuted at \(n=90\); restricted \(\omega\le3\) bridge | block/transfer entries; K07, K26 |
| `math-1784942909-3786147` | `P/F/C`: exact S-unit/polynomial translation; standard fixed-data theorems have wrong moving arity, height, and \(S\)-dependence | pair and source-transfer entries; K22, K40 |
| `math-1784942909-3786148` | `P/F/C`: exact layer cake and full/partial distinction; pair-free top support does not force penultimate overlap | partial-layer and PC4 entries; K17, K22 |
| `math-1784942909-3786149` | `P/F/C`: exact joint carry operator; pressure/counting bound remains absent and scalar recursions fail | carry recursion and moments; K23, K36 |
| `math-1784942909-3786150` | `P/F/C`: ensemble/Fourier inverse theorems for selected completions; deletion and every-cofactor transfers fail | character/ensemble entries; K37, K40 |

### Four-prime bridge closure and first outer-loop wave

| Run | Evidence and terminal disposition | Canonical coverage |
|---|---|---|
| `math-1784947385-3800906` | `P/F/C`: \(A\le1\), hard-sequence classification, all-row gcd/lcm/product identities, carry polynomials, and balanced digit obstruction | hard-sequence and global-invariant entries |
| `math-1784947385-3800907` | `P/F/C`: corrected private-load split and hostile cyclotomic/auxiliary-prime constructions; no exact E4 quartet here | PC4 and auxiliary-prime gates; K17, K22 |
| `math-1784947385-3800908` | `P/F`: `CI` refuted by the exact quartet; direct-divisor continuation remains partial | finite quartet and divisor routes; K17 |
| `math-1784947385-3800909` | `F`: `HL6` refuted by the exact quartet | finite quartet; K17 |
| `math-1784949501-3806028` | `P/D/C`: exact threshold fallback and optimizer diagnostics; no counterfamily or MR obstruction | largest component and K25 |
| `math-1784949501-3806029` | `P/F/C`: multi-row arithmetic compression, owner-row bound, balanced-square Landau analysis, and open MR | `(OWN)`, square-prime support, K31 |
| `math-1784949501-3806030` | `P/F/C`: WCIL, endpoint descent, and a succession of explicitly retired scalar closures | Carmichael aggregation and endpoint entries; K23, K31 |
| `math-1784949501-3806031` | `P/F/C`: recursive batching, exact singleton classification, order/cyclotomic allocation, and unresolved actual-row overlap | `(FS)`, `(S1)`, `(S2)`; K51 |

### Entropy, annular, dense-square, and boundary campaigns

| Run | Evidence and terminal disposition | Canonical coverage |
|---|---|---|
| `math-1784951581-3832265` | `P/F/C`: entropy selection, multi-row reduction, and open phase-sensitive `TPRI` | entropy/token partition entry; K18 |
| `math-1784951908-3834501` | `P/F/C`: promotion-tail reduction, exact CRT/Fourier cell criterion, hybrid cover, and open `UTC` | `(UTC)` and annular entries; K21, K46 |
| `math-1784960218-3851368` | `P/C`: \(A\le1\), all-height spectrum/rough-dense reduction, and bounded-depth common-index gate | pre-hard-branch spectrum; K12, K24 |
| `math-1784964679-3910229` | `P/C`: PMBC elementary chain, minimal overweight divisors, phase extraction, and open `HPCM` | minimal overweight divisors/HPCM; K20 |
| `math-1784968025-4002967` | `P/F/C`: exact interval-prime-square all-row analysis, one-prime means, global dynamics, punctured windows, and rotating descent | `(PP)`, square-prime and K49 entries |
| `math-1784972255-4031899` | `P/F/C`: interval-square subproduct and packet-row identities; exact remaining linked-prefix obstruction | packet GCD and square-subproduct entries |
| `math-1784987750-4084057` | `P/F/C`: dense-branch actual-row owner theorem, universal owner-expression falsifier, and open `R_dense` | `(OWN)`, `(OWN-F)`, dense Carmichael bridge |

### Matched outer-loop campaigns

| Run | Evidence and terminal disposition | Canonical coverage |
|---|---|---|
| `math-1784994375-4111086` | `P/F/C`: exact Landau orbit and target-sized exceptional/resonant bounds; nonresonant support remains open | interval-square support entry |
| `math-1784994375-4111087` | `P/F/C`: LAMI refuted on every co-divisor row by a Maynard/geometric-shift family; arbitrary adaptive multipliers remain open | LAMI and adaptive-multiplier gate |
| `math-1784994375-4111088` | `P/F/C`: all-scale balanced signed-digit equivalence and resource bounds; no growing supported row | balanced-square/signed-digit entry |
| `math-1784994375-4111089` | `P/F/C`: balanced private-atom core and near-star/auxiliary-prime route separated; factorization control remains missing | Carmichael owner/auxiliary-prime entry |

### UHFL and late source-transfer campaigns

| Run | Evidence and terminal disposition | Canonical coverage |
|---|---|---|
| `math-1785005284-4146901` | `P/C`: canonical variable first-failure capacity and selectable-block reduction | first-failure phase entry |
| `math-1785005284-4146902` | `P/C`: exact proper-face factorial moment reduction; signed arithmetic positivity remains open | moments and exact surviving target; K23 |
| `math-1785005284-4146903` | `P/F/C`: balanced-square phase steering and no-go for a proposed UHFL counterfamily | balanced-square and exceptional-row entries |
| `math-1785005284-4146904` | `P/C`: audited conditional general transfer from homogeneous packet rows to UHFL | UHFL transfer; K27 |
| `math-1785006659-4151481` | `P/F`: primary-source \(A=1\) reconstruction; literal iteration refuted | K10, K24 |
| `math-1785009968-4160866` | `P/F/C`: exact tail conductor and local support lower bound; packet-average deep-tail inequality remains open | deep-tail and sparse-box entries; K43, K44 |
| `math-1785010372-4161735` | `P/F/C`: worker-only source/automaton/Fourier audit; fixed-base theorems and uniform bounded-state spectral decay do not transfer | source-transfer and carry-automaton entries; K40 |
| `math-1785012022-4186125` | `P/F/C`: worker-only smooth-cofactor/S-unit/resultant/divisor-lattice attacks; no variable-modulus smooth-residue exclusion | smoothness/global-lock entries; K19, K45 |
| `math-1785012022-4186126` | `P/F/C`: worker-only exact signed-cutoff Fourier/factorial-moment expansions; cancellation estimate remains open | exact surviving signed target; K35, K37 |
| `math-1785012022-4186127` | `P/F/C`: worker-only bounded-depth global-lock algebra; unit-lock exclusion is insufficient, full hypergraph lock remains | global lock and fixed-depth algebra; K29, K45 |
| `math-1785014061-3746` | `I/P/C`: radical-packet-gcd setup and exact packet inequality; no full linked-prefix bound or terminal report | short-packet gcd route |

## High-risk re-audit findings

### Reportless directories

The initial filename-only audit called several directories “reportless.” A
content audit splits them as follows:

- `erdos700-iii-robust-digit-box-20260725` is not empty. Its four Markdown
  artifacts contain a substantial local theorem package and an explicit open
  fixed-\(n\) adapter.
- `erdos700-iii-weighted-tuner-20260725` contains only an exact finite
  diagnostic report and JSON.
- `controller-loop-1784939454-3767068` and
  `outer-loop-1784948761-3803975` are controller syntheses, not independent
  proof runs.
- `math-1784853673-138164`, `math-1785014059-3701`,
  `math-1785014416-4588`, and `math-1785021986-135407` contain no returned
  mathematical work.

### Worker-only directories

The ten `math-1784942909-*` runs and the late
`math-1785010372-*`/`math-1785012022-*` runs cannot be certified from a lead
report because none exists. Their worker reports were therefore inspected
directly. The durable results are the exact route closures recorded above:
profile transfer, zero-sum/adelic, determinant/Smith, moment, block descent,
source-transfer, carry-operator, smooth-residue, signed-cutoff, and
global-lock routes. None contains a worker conclusion that closes the target.

### Target-marker false positives

A direct phrase sweep finds several superficially positive strings. Their
surrounding scopes were checked rather than inferred from the matching line:

- `math-1784940116-3770584/candidate.md` really does claim an unconditional
  unbounded counterfamily, but only to `WS3` and `H_lambda`; its scope section
  explicitly excludes Erdős 700(iii), and \(D(n)\asymp n^{1/4}\).
- `math-1784951908-3834501/candidate.md` calls one implication a
  “counterfamily gate,” then immediately says the required prime sequence and
  converse capacity theorem were not proved and marks the result partial.
- worker reports using “unconditional counterfamily” refer to a named local
  mechanism such as zero-prefix budgeting, not to the original asymptotic
  statement.
- `math-1784951581-3832265/verification.md` says the implication chain to
  Part (iii) is proved, but in the same sentence records `TPRI` as open and
  the target verifier as unaccepted.
- `math-1784994375-4111089/verification.md` explicitly records both the
  unbounded counterfamily and fixed-\(A\) target disproof as “not obtained.”

Thus none of the positive-looking phrase hits is a hidden terminal solution.

### Quarantined asymptotic claims

Several reports present an unbounded squarefree four-prime family refuting
the fixed cubic Carmichael bridge. A single exact finite quartet already
refutes the universal bridge, so the original target does not depend on the
asymptotic lift. The exact use of Maynard's admissible-tuple theorem was
checked against the published primary source, and six independent retained
internal audits found no mathematical defect in the final argument. The lift
is still kept as `Q`: it has no formalization or external review, all retained
audits are internal, and its \(D(n)\asymp n^{1/4}\) scale is irrelevant to
the Part-(iii) target.

The browser-only sparse-shadow theorem `(PSR)` and bounded-deletion
cyclotomic argument `(CY)` remain similarly quarantined pending independent
source and line-by-line audits. The broad `(PSR)` thread was reopened in the
second pass through Brave; its terminal answer explicitly stops at the
large-box, high-conductor phase-cancellation obstruction and claims neither a
global proof nor an infinite counterfamily. Even if both browser arguments
are correct, they enlarge individual Lucas boxes or exclude one sparse-tail
mechanism; neither creates a same-row intersection.

## Coverage assertion and residual uncertainty

The directory-level coverage assertion is now mechanically checkable: the
105 run basenames in this file equal the 105 top-level directories on the
reconciled `dev-georgios` host. This audit is stronger than a keyword search
because it distinguishes prompts, controller summaries, lead reports,
worker-only batches, finite diagnostics, conditional reductions, and
quarantined claims.

The remaining uncertainty is not a known unindexed campaign. It lies in:

1. forbidden raw recorder streams that were intentionally not treated as
   mathematical evidence;
2. browser claims whose external theorem use has not received a clean
   primary-source audit;
3. internal asymptotic lifts explicitly marked `Q`;
4. the possibility that an informal worker aside contains an undeveloped
   idea not elevated to a theorem, counterexample, or named missing lemma.

Those qualifications are why the defensible conclusion is “no persisted
claim-bearing path is currently unaccounted for,” not the absolute statement
“zero ideas could possibly have been missed.”
