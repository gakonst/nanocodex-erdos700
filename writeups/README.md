# Mathematical write-ups

This directory is the shortest reviewer path through the mathematics in this
repository. Each file is standalone LaTeX and states its own claim boundary.

| Part | Document | Status | What it contains |
| --- | --- | --- | --- |
| (i) | [`part-i-complete-solution.tex`](part-i-complete-solution.tex) | Complete, kernel-checked | The full solution: boundary-antichain reduction followed by the compact synchronized selector/prefix/digit/borrow compiler, with both the maintained largest-prime and literal 1978 greatest-prime-power corollaries |
| (ii) | [`part-ii-infinite-family.tex`](part-ii-infinite-family.tex) | Complete, kernel-checked; no novelty claim | The full Lucas-theorem structural lemma and the unconditional prime-number-theorem construction of infinitely many examples |
| (iii) | [`part-iii-frontier.tex`](part-iii-frontier.tex) | Open | The exact reduction, strongest retained partial results, routes ruled out, and the current same-row synchronization bottleneck |

The corresponding Lean entry points are
[`proof/PartIVerify.lean`](../proof/PartIVerify.lean) for Part (i) and
[`proof/Erdos700PNT.lean`](../proof/Erdos700PNT.lean) for Part (ii). Part
(iii) has no claimed proof or Lean candidate.

For the route-by-route research history, including superseded attempts and
counterexamples to methods, continue to
[`docs/research-map.md`](../docs/research-map.md). For exact evidence labels
and publication boundaries, see [`docs/status.md`](../docs/status.md).
