# Provisional and unverified claims

These cases are useful for harness design precisely because their evidence is
incomplete. They should not enter the accepted-discovery count.

## Wang's six Erdős claims

Shouqiao Wang reported candidate resolutions of #390, #486, #536, #788,
#1002, and #1038 after attempting thirteen problems with GPT‑5.6 Sol. Runs used
a CDC-style problem specification, long autonomous Codex sessions, local files,
multiple repair/audit passes, and Python or Lean for selected cases. The exact
web-search use is not uniformly documented per run and should be recorded as
unknown unless a prompt or rollout establishes it.

The public thread makes the operator contribution unusually concrete. Wang
first filtered for problems with active mathematical interest while avoiding
ones entangled with famous hard conjectures. Each generated problem prompt
restated the target, defined proof/disproof acceptance, listed non-solutions and
problem-specific traps, kept incompatible approaches alive, demanded
counterexample search against intermediate lemmas, and treated a reduction to a
comparably hard statement as blocked. Codex then ran against local files for
roughly six to thirty-two hours. The reported internal loop was attempt,
failure diagnosis, new route, proof draft, adversarial audit, and repair. This
is a 6/13 claim yield, not a validated 46% theorem-solving rate.

The repository is unusually transparent, but two formalized cases do not make
the remaining four formal, and AI audits are not expert acceptance. Thomas
Bloom also notes that #1038 emerged after extended public collaborative work,
making a single-agent credit story misleading.

[Repository](https://github.com/ShouqiaoW/erdos),
[announcement](https://x.com/Qiaoqiao2001/status/2080003441821163958),
[problem-selection post](https://x.com/Qiaoqiao2001/status/2080003446602600756),
[prompt-method post](https://x.com/Qiaoqiao2001/status/2080003454165295403),
[run-loop post](https://x.com/Qiaoqiao2001/status/2080003461517549887),
[Bloom caution](https://x.com/thomasfbloom/status/2080052621562233235).

## Erdős #421

GPT‑5.6 Sol Ultra proposed a “gap-greedy” construction over consecutive prime
gaps for a density-one sequence with distinct interval products. The claim uses
a witness forest, curve point-counts, multiplier sharing, scale contraction,
and Li's theorem. The canonical page remains open and says no associated expert
has examined the proof claim. Web and tool details are not public.

[Proof claim](https://www.erdosproblems.com/forum/thread/421/proof-claims).

## Two-dimensional Gaussian Moments Conjecture

A public 24-minute GPT‑5.6 run was prompted to find either a sparse
counterexample or a structural identity. It proposed a proof using complex
Gaussian contraction, constant-term factorization, Newton polygons,
Duistermaat–van der Kallen, and (p)-adic isolation. The web setting is not
reported, and the available checking is mainly by other models.

[Transcript](https://chatgpt.com/share/6a612803-a264-83ed-9175-9c23c7da5765).

## Caccetta–Häggkvist (r=6)

The root request was effectively “solve a maths problem; make no mistakes.”
Codex later produced a claimed (r=6) solution. The operator explicitly stated
that neither he nor much of the audience had read or understood it. No accepted
expert audit, executable certificate, or formal proof has been located.

[Claim thread](https://x.com/jjpcodes/status/2079972608997486706).

## Knuth Fascicle 8A Exercise 210

GPT‑5.5 Pro produced a finite counterexample to a knight-tour denominator claim
using a public prompt template. Codex and Claude Code reportedly reran the
source successfully. That gives stronger evidence than model agreement, but no
expert mathematical acceptance has been located.

[Author's report](https://www.kylekabasares.com/blog/2026/6/24/did-i-just-get-chatgpt-to-solve-an-unsolved-math-problem),
[repository](https://github.com/kylekaba/knuth-fasc8a-ex210),
[transcript](https://chatgpt.com/share/6a3b9009-0098-83e8-b502-4c59de0b4e30).
