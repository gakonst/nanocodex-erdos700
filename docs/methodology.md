# Methodology: using Nanocodex as a research harness

This result did not come from asking a chatbot for a proof once. We used
[Nanocodex](https://github.com/gakonst/nanocodex) as a Rust library to build an
evidence-producing mathematical research harness, ran a small portfolio of
problems, and then concentrated the available model and human attention on
Erdős 700(ii) when it produced a promising structural route.

The complete application source is in this repository: the Rust crate begins
at [`src/main.rs`](../src/main.rs), its application-owned tools live alongside
it in [`src/`](../src/), and the prompts, campaign definitions, verifiers,
research corpus, Nix environment, and operational lessons are retained in
their corresponding top-level directories. Generated runs, credentials, build
outputs, and local dependency caches are intentionally excluded.

The process was interactive. AI agents proposed, criticized, repaired, and
formalized ideas; the human operator selected the campaign, reallocated effort,
required exact statement checks, demanded a Lean endpoint, and decided when a
conditional-looking route was not a satisfactory trust boundary. The final
claim rests on the Lean kernel and the statement audit, not on either party's
confidence.

## 1. Build the harness as an application

Nanocodex supplied the owned model session, persistent typed history, Responses
WebSocket, Code Mode runtime, and caller-defined tool interface. The
mathematics application supplied the research policy.

The lead agent used GPT-5.6 Pro with maximum thinking:

```rust
Nanocodex::builder(api_key)
    .reasoning_mode(ReasoningMode::Pro)
    .thinking(Thinking::Max)
```

The important design choice was to make tools correspond to research-state
transitions rather than expose only generic subagents:

- `spawn_math_batch` launched bounded clean-room workers for a route portfolio;
- `prompt_math_agent` continued a useful retained worker through repair turns;
- `run_exact_job` supervised targeted computation and formal compilation;
- `record_evidence` appended typed facts, failures, and checks to a ledger;
- `freeze_candidate` created an immutable, content-addressed audit boundary;
- `verify_candidate` delegated acceptance to a pre-approved checker;
- `inspect_research_artifacts` let later workers reuse retained evidence.

Code Mode let the lead write small JavaScript programs with loops,
conditionals, reductions, and tool calls. The host, however, owned concurrency,
deadlines, cancellation, process cleanup, and result ordering. This division
came from the adjacent
[Nanocodex RLM experiments](https://github.com/gakonst/nanocodex-rlm):
model-written orchestration is useful for adaptive research decisions, but
mechanical scheduling is more reliable as ordinary library code.

The lead could also call Bash through Nanocodex's Code Mode execution tool.
That path was validated against the pinned development environment containing
Lean, Lake, Python, Sage, and solver CLIs. Long deterministic work was moved
behind the supervised exact-job tool so that a yielded model cell could not
orphan the process or lose its terminal record.

## 2. Select games for conceptual leverage

We did not begin with Erdős 700 alone. We screened open problems for places
where additional AI inference might matter more than a large local
computation. The selection gates favored:

1. a current canonical source still marking the exact target open;
2. a precise statement and a credible independent verification path;
3. limited visible crowding;
4. a bottleneck that looked like a construction, reduction, or proof idea;
5. small computations that could falsify ideas without becoming the proposed
   breakthrough;
6. enough existing mathematical structure for an agent to compose.

The initial inference-first slate contained Erdős 700(ii), Erdős 156, and
Erdős 579. Several campaigns could therefore surface independent signals
before we committed the entire budget to one target.

This is the portfolio-to-concentration pattern:

```text
broad problem screening
        ↓
small parallel route portfolios
        ↓
checked signal appears on one problem
        ↓
stop spending attention uniformly
        ↓
concentrate discovery, audit, and formalization on that problem
```

When the 700 campaign surfaced a plausible unconditional three-prime
construction, the operator explicitly stopped treating all selected problems
equally and redirected the research effort to its missing pieces.

## 3. Freeze the exact target before discovery

The campaign copied the historical and formal statements into an immutable
problem package. The acceptance checklist preserved:

- the strict inequality \(f(n)^2>n\), not the easy equality case;
- composite \(n>1\);
- infinitely many examples, not a finite search;
- every \(1<k\le n/2\);
- an unconditional result, not an unproved prime-pattern conjecture;
- a proof independent of the upstream open theorem wrapper.

This prevented an agent from receiving credit for a nearby but easier claim.
It also made later Lean statement alignment a separate check from proof
compilation.

## 4. Use inference first and computation as a falsifier

The lead assigned mathematically different routes rather than many cosmetic
variants of one prompt: \(p\)-adic/Lucas analysis, prime-product families,
proof and disproof attempts, theorem transfer, and targeted counterexample
search.

The decisive structural proposal considered \(n=pqr\) for nearby primes
\(p<q<r\). If their gaps \(a=q-p\) and \(c=r-q\) satisfy

\[
0<a<c,\qquad 4(a+c)^3<p,
\]

then Lucas-theorem digit constraints prevent two primes from being omitted
simultaneously from \(\binom{pqr}{k}\). This forces every relevant gcd to
contain at least two of the three primes.

Targeted exact searches then tried to break that lemma near its weakest
boundaries. They were evidence against simple errors, not the proof of an
infinite statement. The final result does not depend on a large enumeration or
simulation.

The harness was deliberately reoriented during development to reward closed
logical gaps, useful equivalences, and theorem bridges instead of CPU activity.
A computation proposal had to say what hypothesis it tested, why its search
space was enriched, what each outcome would change, and when to stop.

## 5. Treat a promising route as the start of auditing

Two discovery workers independently surfaced a Maynard-style route: use a
fixed admissible tuple with exponentially separated offsets to produce three
primes with asymmetric gaps. That was a strong signal, not an acceptance
event.

The route was split into independently auditable parts:

- exact Maynard theorem and quantifier audit;
- admissibility of the fixed tuple;
- three separate Lucas omission cases;
- the witness proving the exact value \(f(pqr)=pq\);
- infinitude and unboundedness;
- novelty and source search;
- statement alignment.

Completion-pressure steering—of the form “enough partial results; finish a
complete unconditional argument”—was useful as a phase transition. It was
never allowed to turn a partial result into a success label. If a verifier
rejected a candidate, or a turn ended with only a partial result, the retained
lead received the exact failure and had to repair it or change
representation.

## 6. Let formalization change the proof strategy

The Maynard route produced a compelling informal candidate, but a full Lean
proof would have required formalizing a substantial sieve theorem or admitting
it as a new trust boundary. We did not hide that dependency behind an axiom.

Instead, the formalization campaign searched the pinned dependencies and found
a compatible formal prime number theorem. This suggested a simpler
unconditional route:

1. use PNT density in \((8T^3,16T^3]\);
2. partition the interval into boxes of length \(T\);
3. force one box to contain more than \(\log_2 T+2\) primes;
4. use an elementary exponential-gap lemma to find \(p<q<r\) with
   \(r-q>q-p\);
5. feed this triple to the already audited Lucas argument.

This was the key proof-engineering pivot. Formalization was not a ceremonial
translation after discovery; the available trusted library changed which
mathematical route we chose.

The Lean work was decomposed into independently compilable slices:

- PNT interval density;
- asymptotic dominance;
- interval packing;
- the finite asymmetric-gap lemma;
- three pair-omission proofs;
- gcd and exact-\(f\) assembly;
- unboundedness and `Set.Infinite`;
- final statement and dependency audit.

Compiler errors and open goals became structured feedback for the next repair
turn. The final integration imported only compiled slices, pinned every
dependency, scanned local sources for proof placeholders, and ran
`#print axioms` on the exact theorem.

## 7. Keep long reasoning alive, but keep truth checks hard

GPT-5.6 Pro calls can remain silent for several minutes while reasoning. The
campaign configuration therefore did not treat the absence of streamed events
as a transport failure. Restarting such a call would discard uncommitted
reasoning and repeat paid work.

That did not mean unlimited unsupervised execution:

- campaign and route budgets still bounded the overall experiment;
- deterministic jobs had host-owned time, progress, artifact, and
  process-group controls;
- a worker's prose could not mark a candidate verified;
- only a frozen artifact plus an authoritative checker could end a
  verifier-backed campaign successfully.

The distinction is important: patience is appropriate for model inference;
hard liveness and cleanup rules are appropriate for subprocesses; mathematical
acceptance requires independent evidence.

## 8. What the case demonstrates

The useful unit was not “many subagents.” It was a programmable,
evidence-preserving research loop:

```text
select → reason → retain → falsify → concentrate → audit
       → formalize → repair → align → publish
```

Nanocodex's value was library-level control over that loop. We could combine a
long-lived research lead, clean independent workers, local development tools,
durable artifacts, explicit human steering, and a formal endpoint without
putting research policy into the agent SDK itself.

This case should not be read as a one-shot autonomous solution. The strongest
claim supported by the evidence is more useful: a human and AI system used a
programmable Nanocodex harness to discover and refine a route, changed
strategy when the formal trust boundary demanded it, and produced a
reproducible kernel-checked proof package.

## Follow-on work and what happened next

The Part (ii) structural machinery did lead to the Part (i) development. The
repository now proves, for every composite \(n>1\), an exact
boundary-antichain characterization of

\[
f(n)=n/P(n),
\]

where \(P(n)\) is the largest prime factor. It also compiles the semantic
factor tableau into an explicit finite integer/Boolean digit-and-borrow system.
That result is kernel-checked. Its remaining review question is interpretive:
whether the historical request for a characterization demands a shorter
closed factorization taxonomy.

Part (iii) required a much broader campaign and remains open. The exact
weighted objective, hard residual decomposition, and many local identities are
now understood, but no argument has improved the classical uniform
\(D(n)\gg\log n\) bound. Several attractive mechanisms—fixed multiplier
menus, naive witness iteration, independent carry probabilities, abstract
set cover, and a fixed cubic Carmichael bridge—were rigorously refuted.

The durable synthesis is in
[`part-iii-exploration-map.md`](part-iii-exploration-map.md). The methodological
lesson is important: retaining counterexamples and imposing a quantitative
progress gate prevents a large multi-agent campaign from confusing a renamed
open condition with movement on the theorem.
