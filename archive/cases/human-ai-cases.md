# Human–AI and attention-bottleneck cases

## Nathanson/Rajagopal sumset diameter

Tim Gowers gave GPT‑5.5 Pro open questions from Nathanson's additive-number-
theory paper. No specialized tool or web-search use was reported. The model
first found a quadratic-diameter construction for the two-fold sumset problem
in 17 minutes, then improved Isaac Rajagopal's general exponential bound to a
polynomial one through several short prompts.

Rajagopal identified the use of (h)-dissociated sets—“half a geometric series
squeezed into a polynomial interval”—as the genuinely new idea. He regarded it
as the kind of publishable contribution a researcher might be proud to find
after sustained work. Human expertise supplied the source framework and judged
the mathematical significance; the model supplied the construction.

[Gowers's report and linked preprints](https://gowers.wordpress.com/2026/05/08/a-recent-experience-with-chatgpt-5-5-pro/).

## Talagrand convexity

GPT‑5.5 Pro generated a proof of a key Laguerre-tessellation coupling
proposition. The public transcript is available, but whether general web search
was enabled is not established. Hua and Song developed a resolution from the
model's proposition while Tudose independently found a more general human
argument. The main paper uses the human argument and preserves the model result
in an appendix.

Later comparison showed that the model proposition also followed from recent
Laguerre-tessellation literature. This is best classified as an AI-catalyzed
resolution and attention/literature bridge, not a wholly autonomous proof of
the complete theorem.

[Paper](https://arxiv.org/abs/2605.10908),
[transcript](https://chatgpt.com/share/69fae923-68f8-83e8-9dea-aceba3639524).

## Grothendieck finite-flat group schemes

Akhil Mathew posed whether every finite free group scheme of order (n) is
killed by (n). GPT‑5.6 Sol found an order-four counterexample and produced a
mathematical write-up. Claude Fable then autoformalized the result in about four
hours and 1,076 Lean lines. The search/web policy is not reported.

Kevin Buzzard ran generated code in a sandbox, compiled and inspected it, and
the result was merged into mathlib. The sequence—human question, model witness,
separate formalization model, kernel, and community review—is a useful
proof-assisted pipeline.

[Buzzard's account](https://xenaproject.wordpress.com/2026/07/20/human-mathematicians-are-being-outcounterexampled/),
[mathlib PR](https://github.com/leanprover-community/mathlib4/pull/41748).

## Jacobian conjecture in dimension three

Claude Fable 5 returned an explicit polynomial map over \(\mathbb C^3\) with
constant Jacobian determinant \(-2\) and three preimages of the same point. The
prompt details and web-search setting have not been published.

The result has a particularly strong validation shape: symbolic differentiation
and exact substitution check it in seconds, and independent Lean
formalizations record the same finite calculation. Dimension two remains open.

[Original formula](https://x.com/__alpoge__/status/2079028340955197566),
[formalization PR](https://github.com/google-deepmind/formal-conjectures/pull/4474).

## Natural-density logarithmic Collatz descent

AI agents strengthened an almost-all Collatz theorem: for every diverging
threshold, natural-density-one many starts descend below it within an explicit
multiple of \(\log N\). The result has a large Lean evidence package; the
general web/search setup and full agent transcript are not public.

This is not the Collatz conjecture. It permits a density-zero exceptional set,
does not prove arrival at one, and uses different clocks for odd-to-odd Syracuse
steps and raw Collatz steps.

[ProofAtlas result and checked source](https://www.proofatlas.ai/formalizations/natural-density-log-time-collatz/).

## ProblemsILike #6: Frobenius amplitude

GPT‑5.5 Pro, prompted by Thomas Bloom, found a characteristic-two Tango-bundle
counterexample. Codex independently found the same route using an extended
prompt, and public artifacts include its research log and audit. Macaulay2
independently checked initial cohomology cases.

Unlike many one-shot examples, literature search was central here. The
counterexample was implicit in existing work, leading Daniel Litt to describe
the contribution as “literature search + epsilon.” It remains important as an
example of an AI system resolving an attention bottleneck and assembling a
usable proof package.

[Problem page, chats, prompts, logs, and audits](https://www.problemsilike.com/forum/thread/6?order=oldest).
