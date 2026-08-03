# Case catalog

The table records the publicly documented execution environment, not what the
model might have been capable of internally. `Not reported` means the available
paper, transcript, repository, and announcement do not establish whether
general web search was enabled.

Evidence tiers are defined in [verification](../methods/verification.md).

| Case | Status | Web/search environment | Specialized tools and proof assistance | Evidence |
|---|---|---|---|---|
| Planar unit distance | Accepted disproof | Exact web policy not disclosed; model was evaluated on a supplied open problem | General reasoning; later expert review and large Lean formalization | A |
| Cycle Double Cover | Accepted proof | Restricted: ordinary background allowed, searching for an existing CDC solution forbidden | 64 subagents; adversarial audits; later Lean repository and axiom scan | A |
| Correlation gap under pairwise independence | Accepted disproof | Not reported; input was a direct prove/disprove prompt | Python, SciPy `linprog`, HiGHS, randomized LP search, rational primal/dual certificate | A |
| Benjamini–Hochberg FDR | Accepted disproof | Public transcript; general web use not reported; model initially received only the definition | Generated Python; Gaussian-factor simulation; Arb/python-flint interval certificate | A |
| QAOA FGG conjecture | Accepted proof | Not reported | LeanScriber, Lean compiler/kernel loop, Python numerical unit tests | A |
| Zeroth-order convex optimization | Accepted lower bound/near closure | Baselines and traps supplied in prompt; independent web use not reported | Long-horizon GPT run, adversarial ledgers, current Lean formalization | A/B |
| Gaussian Completely Monotone | Accepted disproof | Not reported | SageMath/Arb 256-bit ball arithmetic; exact rational witness | A/B |
| Fisher-information log-convexity | Accepted disproof | Not reported | Explicit Fourier/numerical construction and human proof | B |
| Erdős #119 | Site-accepted proof | Not reported | Harmonic-analysis derivation; human mathematical review | B |
| Erdős #793 | Canonical page marked solved | Not reported | Refinement of Erdős's 1938 construction; no public formalization located | B |
| Nathanson/Rajagopal sumset diameter | Expert-accepted new bounds | No web/tool use reported; short ChatGPT conversations | Human source paper supplied conceptually; model proof; expert author review | B |
| Talagrand convexity | Accepted collaborative resolution | Transcript public; web status not established | Model-generated key lemma; independent human proof; literature comparison | B |
| Grothendieck finite-flat group schemes | Accepted counterexample | Search status not reported | GPT proof, Claude Fable autoformalization, Lean compiler, mathlib review | A |
| Jacobian conjecture in dimension 3 | Explicit accepted counterexample | Not reported | Exact symbolic differentiation/substitution; Formal Conjectures Lean checks | A |
| Natural-density Collatz descent | Accepted strengthening, not full Collatz | Not reported | 182k-line first-party Lean closure; statement/evidence review | A |
| ProblemsILike #6 Frobenius amplitude | Counterexample, largely literature-attention result | Yes/central: model research and literature retrieval were part of the workflow | ChatGPT, Codex research log, Macaulay2 finite checks, later audit | B, rediscovery-adjacent |
| AlphaProof Nexus | Formal discovery campaign | General web not reported as a core tool | Lean, AlphaProof subgoal tool, Gemini agents, population DB, Elo/P-UCB, validators | A with novelty caveats |
| EinsteinArena records | Twelve verifier-accepted records | Arena API/discussion access; general web not required or established | Public Python verifiers, E2B, exact integers, Decimal high precision, shared memory | A for records |
| Wang six Erdős claims | Provisional mixed set | Prompt permits structured research; repository supplies local artifacts; exact web use differs by run/not fully recorded | Codex long runs, Python/Lean on some cases, multiple AI audits | C |
| Erdős #421 gap-greedy | Provisional full claim | Not reported | GPT‑5.6 Sol Ultra, analytic bookkeeping; no accepted formal proof yet | C |
| Gaussian Moments GMC(2) | Provisional proof draft | Public ChatGPT run; web status not reported | Structural/p-adic proof draft; model cross-review only | C |
| Caccetta–Häggkvist r=6 | Unreviewed social claim | Codex workspace likely available; exact tools not documented | Generated paper/screenshots; operator explicitly lacks mathematical review | D |
| Knuth Exercise 210 | Executable candidate counterexample | Not reported | Source code independently run through Codex and Claude Code | C |

Detailed narratives:

- [Flagship autonomous and certificate-backed cases](flagship-cases.md)
- [Human–AI and attention-bottleneck cases](human-ai-cases.md)
- [Formal and verifier-driven platforms](platforms.md)
- [Erdős census](erdos-census.md)
- [Provisional claims](candidates.md)
