# Prompt field guide

The successful prompts in this corpus range from one sentence to ten-page
research programs. Length is not the determining variable. The recurring
advantage is that the prompt matches the expected evidence-producing loop.

## Pattern map

| Pattern | Best for | Public exemplars |
|---|---|---|
| Direct prove-or-disprove | Crisp statements where a model can generate its own computational search | Pairwise correlation gap, BH FDR, Gaussian counterexamples |
| Research-manager / CDC-style | Major conjectures, many plausible routes, long autonomous runs | Cycle Double Cover, zeroth-order optimization, Wang's Erdős experiments |
| Frozen formal target | Lean theorem completion and statement-preserving search | QAOA FGG, AlphaProof Nexus, Grothendieck counterexample |
| Computational discovery → exact certificate | Small explicit counterexamples, extremizers, numerical inequalities | Correlation gap, BH FDR, Gaussian monotonicity, Fisher log-convexity |
| Completion-pressure steering | A mature run with useful partials but no unconditional endpoint | Dinitz–Garg–Goemans correlation-gap counterexample |
| Human framework → missing idea | Improving an existing construction or closing a sharply defined gap | Gowers/Rajagopal sumsets, Talagrand coupling |
| Verifier arena | Optimization records and construction search | EinsteinArena |

See [prompt patterns](patterns.md), the production
[research-manager prompt](research-manager.md), and the
[new-problem template](new-problem.md).

## Prompt design principles

### Preserve the exact problem

Spell out domains, all quantifiers, what constants may depend on, asymptotic
regimes, degenerate cases, and the exact meaning of proof or counterexample.
This is especially important when the model can edit source containing its Lean
target.

### Define unacceptable terminal outputs

Public high-performing prompts explicitly reject:

- “the conjecture is open” as the whole answer;
- partial results presented as resolutions;
- reductions to unproved statements of comparable difficulty;
- empirical evidence without an exact bridge;
- handwaved global compatibility;
- literature summaries in place of proof;
- silently changing the model, oracle, precision, or adversary.

### Separate generators and critics

The same conversation is poorly positioned to notice its foundational mistake.
Use clean workers for independent routes and fresh clean workers for the final
audit. Use contextual forks for local repair after the global direction is fixed.

### Ask for artifacts, not confidence

Useful outputs include source code, an LP dual, a rational witness, an interval
certificate, a Lean file, explicit lemmas, a dependency graph, or a minimal
failing example. Confidence scores and model consensus are weak evidence.

### Separate persistence from truth pressure

Short follow-ups such as “finish with a complete unconditional
counterexample” appear to have helped some long runs continue past partial
results. Treat this as a phase transition, not evidence. The harness should
freeze the target, allocate a closure budget, demand a verifier-backed object,
and still permit an honest `blocked` result. Never couple persistence language
to a requirement that the model announce success.

## Public full-prompt and transcript artifacts

- [Cycle Double Cover full prompt](https://cdn.openai.com/pdf/04d1d1e4-bc75-476a-97cf-49055cd98d31/cdc_prompt.pdf)
- [Zeroth-order optimization initial transcript](https://chatgpt.com/share/6a55aa50-b484-83ea-85c0-c7e7b4bda41c)
- [Zeroth-order optimization refinement transcript](https://chatgpt.com/share/6a55ad10-7644-83ea-859e-5483d2e0dff0)
- [BH FDR transcript](https://chatgpt.com/share/6a541c6f-a2d0-83ea-bb2f-782271a103ca)
- [Talagrand transcript](https://chatgpt.com/share/69fae923-68f8-83e8-9dea-aceba3639524)
- [Gaussian Moments candidate transcript](https://chatgpt.com/share/6a612803-a264-83ed-9175-9c23c7da5765)
- [Knuth exercise transcript](https://chatgpt.com/share/6a3b9009-0098-83e8-b502-4c59de0b4e30)
- [Pairwise correlation-gap exact prompt in the paper](https://arxiv.org/abs/2606.19663)
- [Dinitz–Garg–Goemans short steering sequence](https://x.com/oscar__2025/status/2079969641775149243)
- [AlphaProof Nexus agent prompts in Appendix A.2](https://arxiv.org/abs/2605.22763)
