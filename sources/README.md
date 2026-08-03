# Primary source index

Prefer the mathematical paper, exact prompt/transcript, source repository, and
formal or executable evidence over press coverage. Social posts are useful for
provenance and timing but are not sufficient proof evidence.

## Erdős Problem 700

- P. Erdős and G. Szekeres, “Some number theoretic problems on binomial
  coefficients,” *Australian Mathematical Society Gazette* 5 (1978), 97–99:
  [archival PDF](https://www.renyi.hu/~p_erdos/1978-46.pdf).
- [Maintained Erdős Problems card](https://www.erdosproblems.com/700) and
  [discussion thread](https://www.erdosproblems.com/forum/thread/700).
- [Pinned Formal Conjectures encoding](https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/700.lean).
- Repository reviewer packets:
  [Part (i)](../writeups/part-i-complete-solution.tex),
  [Part (ii)](../writeups/part-ii-infinite-family.tex), and
  [Part (iii)](../writeups/part-iii-frontier.tex).

## OpenAI and model-produced proofs

- Planar unit distance: [official account](https://openai.com/index/model-disproves-discrete-geometry-conjecture), [proof](https://cdn.openai.com/pdf/74c24085-19b0-4534-9c90-465b8e29ad73/unit-distance-proof.pdf), [trace](https://cdn.openai.com/pdf/1625eff6-5ac1-40d8-b1db-5d5cf925de8b/unit-distance-cot.pdf), [commentary](https://arxiv.org/abs/2605.20695).
- Cycle Double Cover: [prompt](https://cdn.openai.com/pdf/04d1d1e4-bc75-476a-97cf-49055cd98d31/cdc_prompt.pdf), [proof](https://cdn.openai.com/pdf/04d1d1e4-bc75-476a-97cf-49055cd98d31/cdc_proof.pdf), [Lean](https://github.com/openai/cdc-lean).

## Papers with explicit AI methodology

- [Pairwise-independent correlation gap](https://arxiv.org/abs/2606.19663).
- Dinitz–Garg–Goemans steering provenance: [prompt reconstruction](https://x.com/oscar__2025/status/2079969641775149243) and [widely quoted completion prompt](https://x.com/willdepue/status/2079973929448509612).
- [Benjamini–Hochberg FDR](https://arxiv.org/abs/2607.12208) and [code](https://github.com/dobriban/BH).
- [QAOA FGG conjecture](https://arxiv.org/abs/2606.29687), [Lean](https://github.com/urikol/QuantumOptimization), [LeanScriber](https://github.com/urikol/leanscriber).
- [Zeroth-order convex optimization](https://arxiv.org/abs/2607.13335) and [Lean](https://github.com/PhillipKerger/zero-order-bounds-lean-verification).
- [Gaussian Completely Monotone](https://arxiv.org/abs/2605.11656).
- [Fisher-information log-convexity](https://arxiv.org/abs/2605.18081).
- [Talagrand convexity](https://arxiv.org/abs/2605.10908).
- [AlphaProof Nexus](https://arxiv.org/abs/2605.22763) and [results](https://github.com/google-deepmind/alphaproof-nexus-results).
- [EinsteinArena](https://arxiv.org/abs/2606.10402) and [repository](https://github.com/vinid/einstein-arena).

## Expert and community records

- [Gowers on GPT‑5.5 Pro and sumset diameter](https://gowers.wordpress.com/2026/05/08/a-recent-experience-with-chatgpt-5-5-pro/).
- [Buzzard on group schemes, Jacobian, and formalization](https://xenaproject.wordpress.com/2026/07/20/human-mathematicians-are-being-outcounterexampled/).
- [ProblemsILike Frobenius-amplitude case](https://www.problemsilike.com/forum/thread/6?order=oldest).
- [ProofAtlas Collatz evidence](https://www.proofatlas.ai/formalizations/natural-density-log-time-collatz/).
- [Erdős AI-contributions tracker](https://github.com/teorth/erdosproblems/wiki/AI-contributions-to-Erd%C5%91s-problems).
- [Erdős #119 proof claim](https://www.erdosproblems.com/forum/thread/119/proof-claims#proof-claim-119).
- [Erdős #793](https://www.erdosproblems.com/793).
- Wang campaign: [root thread](https://x.com/Qiaoqiao2001/status/2080003441821163958), [problem selection](https://x.com/Qiaoqiao2001/status/2080003446602600756), [prompt method](https://x.com/Qiaoqiao2001/status/2080003454165295403), [autonomous duration](https://x.com/Qiaoqiao2001/status/2080003459248755141), [research loop](https://x.com/Qiaoqiao2001/status/2080003461517549887), and [artifacts/formalization status](https://x.com/Qiaoqiao2001/status/2080003463660925129).

## Public transcripts

- [BH FDR](https://chatgpt.com/share/6a541c6f-a2d0-83ea-bb2f-782271a103ca).
- [Zeroth-order initial](https://chatgpt.com/share/6a55aa50-b484-83ea-85c0-c7e7b4bda41c) and [refinement](https://chatgpt.com/share/6a55ad10-7644-83ea-859e-5483d2e0dff0).
- [Talagrand](https://chatgpt.com/share/69fae923-68f8-83e8-9dea-aceba3639524).
- [Gaussian Moments candidate](https://chatgpt.com/share/6a612803-a264-83ed-9175-9c23c7da5765).
- [Knuth exercise](https://chatgpt.com/share/6a3b9009-0098-83e8-b502-4c59de0b4e30).

## Audits and methodological context

- [AlphaProof Nexus formal-search methodology](https://arxiv.org/html/2605.22763v1).
- [AxProverBase: compiler feedback, theorem retrieval, web search, and memory](https://arxiv.org/html/2602.24273v3) and [repository](https://github.com/Axiomatic-AI/ax-prover-base).
- [AlphaProof “nine became eight” novelty audit](https://hedegreenresearch.com/articles/nine-became-eight/index.html).
- [Open problems solved by LLMs? survey](https://aclanthology.org/2026.bigpicture-main.2/).
- [MathOverflow examples and discussion](https://mathoverflow.net/questions/502120/examples-for-the-use-of-ai-and-especially-llms-in-major-mathematical-development/503575).

## Source-entry policy

For each new case retain:

- the original problem source;
- the earliest AI claim with date;
- full prompt and transcript if public;
- paper or complete proof;
- repository and immutable commit when possible;
- verifier/formal evidence;
- independent expert or novelty audit;
- explicit note when web/search/tool settings are unknown.
