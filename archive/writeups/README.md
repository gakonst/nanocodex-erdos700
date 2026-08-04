# Mathematical write-ups

These are the standalone LaTeX sources for the three compiled PDFs at the
repository root. Each file states its own claim boundary.

| Part | Document | Status | What it contains |
| --- | --- | --- | --- |
| (i) | [`part-i-complete-solution.tex`](part-i-complete-solution.tex) | Exact finite criterion, kernel-checked; direct classification open | The boundary-antichain reduction and compact synchronized selector/prefix/digit/borrow compiler, with both the maintained largest-prime and literal 1978 greatest-prime-power corollaries |
| (ii) | [`part-ii-infinite-family.tex`](part-ii-infinite-family.tex) | Complete, kernel-checked; no novelty claim | The full Lucas-theorem structural lemma and the unconditional prime-number-theorem construction of infinitely many examples |
| (iii) | [`part-iii-frontier.tex`](part-iii-frontier.tex) | Open | The exact reduction, strongest retained partial results, routes ruled out, and the current same-row synchronization bottleneck |

The corresponding Lean entry points are
[`../../lean-part1/PartIVerify.lean`](../../lean-part1/PartIVerify.lean) for
Part (i) and
[`../../lean-part2/Erdos700PNT.lean`](../../lean-part2/Erdos700PNT.lean) for Part (ii). Part
(iii) has no claimed proof or Lean candidate.

For the route-by-route research history, including superseded attempts and
counterexamples to methods, continue to
[`../../MAP.md`](../../MAP.md). For exact historical evidence labels and
publication boundaries, see [`../docs/status.md`](../docs/status.md).
