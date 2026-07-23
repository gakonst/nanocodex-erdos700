# Flagship and certificate-backed cases

## Planar unit-distance conjecture

**Result.** An OpenAI internal general-purpose reasoning model disproved the
1946 Erdős conjecture by constructing configurations whose unit-distance count
violates the predicted asymptotics.

**Execution environment.** The exact web-search policy and complete outer
harness were not disclosed. The published reasoning trace shows a sustained
mathematical derivation rather than a literature-search answer. The decisive
idea imported algebraic-number-theory structure into discrete geometry.

**Verification.** OpenAI published the model proof, reasoning trace, and a
companion paper with extensive expert commentary. Boris Alexeev and GPT‑5.6 Sol
later produced a very large Lean formalization. Formal code was sandboxed before
inspection because generated proof-assistant code is executable software.

**Sources.** [Official account](https://openai.com/index/model-disproves-discrete-geometry-conjecture),
[proof](https://cdn.openai.com/pdf/74c24085-19b0-4534-9c90-465b8e29ad73/unit-distance-proof.pdf),
[reasoning trace](https://cdn.openai.com/pdf/1625eff6-5ac1-40d8-b1db-5d5cf925de8b/unit-distance-cot.pdf),
[human commentary](https://arxiv.org/abs/2605.20695).

## Cycle Double Cover conjecture

**Result.** GPT‑5.6 Sol Ultra produced a proof that every finite bridgeless
loopless multigraph has a cycle double cover.

**Execution environment.** The full prompt explicitly allowed web search only
for ordinary background and named theorems. It forbade searching for a solution
to CDC or merely reporting that the conjecture was open. The harness used 64
parallel subagents and assigned separate discovery and adversarial-checking
roles. It encouraged route diversity by withholding the currently favored route
from many workers.

**Prompt mechanics.** The target and graph conventions were exact. Partial
results, reductions to open problems, state-of-the-art summaries, and optimistic
status reports did not count. The prompt enumerated likely failure modes such as
confusing closed trails with cycles and accidentally introducing bridges.

**Verification.** The accompanying Lean repository pins dependencies, checks
the endpoint theorem, scans for prohibited proof shortcuts, and reports only
standard axioms. A remaining epistemic task is statement-alignment review:
machine acceptance proves the encoded theorem, not the historical wording by
itself.

**Sources.** [Prompt](https://cdn.openai.com/pdf/04d1d1e4-bc75-476a-97cf-49055cd98d31/cdc_prompt.pdf),
[proof](https://cdn.openai.com/pdf/04d1d1e4-bc75-476a-97cf-49055cd98d31/cdc_proof.pdf),
[Lean repository](https://github.com/openai/cdc-lean).

## Pairwise-independent correlation gap

**Result.** GPT‑5.5 Pro disproved the conjectured universal (4/3) bound using
a five-element coverage function.

**Execution environment.** The paper reports essentially one direct
prove-or-disprove prompt. Whether general web search was enabled is not stated.
The model spent its first minutes attempting a proof and then switched to
disproof. It generated Python programs using SciPy's `linprog` and HiGHS,
searched OR, cardinality, uniform-matroid, coverage, budget-additive, and
facility-location functions, and varied the marginals.

Public discussion also reconstructs a short steering sequence for the general
non-planar Dinitz–Garg–Goemans form: request a structured counterexample,
continue toward a complete unconditional object, stop accumulating partials,
and adopt a strategy based on deeper structure. This is useful provenance for
the run's persistence policy, but the mathematical paper and exact LP
certificate—not the meme prompt—establish the result.

**Certificate transition.** The floating-point discovery was not the final
evidence. The successful instance was rationalized; the unrestricted numerator
received a primal distribution, and the pairwise-independent denominator was
bounded by a dual/quadratic certificate.

**Lesson.** A short prompt can work when the model has a programmable
environment and the problem admits a finite optimization representation. The
essential loop is semantic formulation → computational search → exact witness.

**Sources.** [Paper, prompt, and certificate](https://arxiv.org/abs/2606.19663),
[steering reconstruction](https://x.com/oscar__2025/status/2079969641775149243).

## Benjamini–Hochberg FDR

**Result.** GPT‑5.6 Sol Pro constructed a dependent Gaussian model for which
the Benjamini–Hochberg procedure exceeds its nominal false-discovery rate.

**Execution environment.** The public account says the model was initially
given only the mathematical definition and asked to prove or disprove. General
web-search use is not reported. A one-shot run took about 90 minutes, after
earlier long multi-agent attempts with another model had failed. Follow-up turns
were used for simulation, related work, and figures.

**Tools.** The model generated code for simulations and for a rigorous
outward-rounded interval certificate using Arb/python-flint. The proof combines
an empirical-CDF limit with an explicit Gaussian factor model and a certified
strict inequality.

**Sources.** [Paper](https://arxiv.org/abs/2607.12208),
[repository](https://github.com/dobriban/BH),
[transcript](https://chatgpt.com/share/6a541c6f-a2d0-83ea-bb2f-782271a103ca).

## QAOA ring-of-disagrees conjecture

**Result.** Claude Fable 5 completed the missing proof that depth-(p) QAOA
achieves the conjectured optimal ratio ((2p+1)/(2p+2)).

**Execution environment.** The web policy is not reported. Humans first built
the quantum and QAOA infrastructure and froze the exact Lean target before the
model saw it. Fable received LeanScriber, which supports a loop of
natural-language planning, Python numerical tests, Lean editing, compilation,
open-goal inspection, and repair.

**Discovery.** The model found a hidden dynamical symmetry, a bridge to quantum
signal processing, and an explicit construction. The theorem statement was not
editable, making “solving the wrong theorem” harder.

**Sources.** [Paper](https://arxiv.org/abs/2606.29687),
[formal repository](https://github.com/urikol/QuantumOptimization),
[LeanScriber](https://github.com/urikol/leanscriber).

## Zeroth-order convex optimization

**Result.** GPT‑5.6 Sol Pro obtained a deterministic exact-value lower bound
near (d^2/\log d), closing the classical (O(d^2)) gap up to logarithms.

**Execution environment.** The prompt supplied known baselines and explicitly
warned that exact real values can encode infinite information. Independent web
use is not documented. Earlier interactive 5.4/5.5 attempts failed; the 5.6
runs lasted roughly 148 and 230 minutes.

**Harness.** This is the closest public reproduction of the CDC research-manager
style outside OpenAI: numerous independent approach families, exact completion
criteria, forbidden model changes, separate proof and precision ledgers,
adversarial checklists, and a freeze-and-audit phase. The current repository
formalizes the sharper lower bound but intentionally does not claim every result
in the surrounding paper.

**Sources.** [Paper and prompt appendix](https://arxiv.org/abs/2607.13335),
[Lean repository](https://github.com/PhillipKerger/zero-order-bounds-lean-verification),
[initial transcript](https://chatgpt.com/share/6a55aa50-b484-83ea-85c0-c7e7b4bda41c),
[refinement](https://chatgpt.com/share/6a55ad10-7644-83ea-859e-5483d2e0dff0).

## Gaussian counterexamples

### Completely monotone conjecture

GPT‑5.5 Pro found an explicit atomic probability measure disproving the
Gaussian Completely Monotone conjecture and related Gaussian-optimality claims.
The original prompt and web policy are not public. The human paper includes a
SageMath/Arb 256-bit ball-arithmetic verification with exact rational atoms and
weights. [Paper](https://arxiv.org/abs/2605.11656).

### Fisher-information log-convexity

GPT‑5.5 Pro found a small hexagonal perturbation on a triangular torus,
disproving the Cheng–Geng claim in two dimensions and hence, by tensorization,
all dimensions at least two. The web/tool transcript is not public; the paper
gives the explicit Fourier/numerical construction and proof.
[Paper](https://arxiv.org/abs/2605.18081).
