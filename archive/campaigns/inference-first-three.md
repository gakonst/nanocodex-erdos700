# Inference-first launch slate

Screened on 23 July 2026 for high marginal value from model inference rather
than local search. “No active worker” below means no user was marked as
currently working on the problem at screening time on erdosproblems.com; it
does not prove that nobody is working privately.

## Selection rule

The slate optimizes for the question: where could a model-compute grant change
the research frontier rather than merely buy more conventional CPU time?

Mandatory gates:

1. a current canonical source still marks the exact target open;
2. the target has a precise statement and an independent proof-checking path;
3. the visible field is not crowded with active attempts;
4. a decisive route should be a construction, reduction, or proof idea;
5. small computation can falsify a lemma, but brute-force scale is not the
   proposed source of the breakthrough;
6. there is a concrete prior framework to improve rather than only a famous
   one-line conjecture.

Scores are 1–5, with 5 best. “Neglect” measures visible lack of activity, not
mathematical importance.

| Rank | Target | Neglect | AI conceptual leverage | Existing foothold | Verification | Brute-force resistance |
|---|---|---:|---:|---:|---:|---:|
| 1 | Erdős 700(ii), strict binomial-gcd family | 4 | 5 | 5 | 5 | 5 |
| 2 | Erdős 156, small maximal Sidon sets | 5 | 4 | 5 | 4 | 5 |
| 3 | Erdős 579, octahedron-free dense graphs | 5 | 4 | 4 | 4 | 5 |

All three Lean statements are present at
`google-deepmind/formal-conjectures@e751934294a381afd2d5fc1124c5953c8e25f9fa`.
They were formalized after the early-February 2026 snapshot used for the
353-problem AlphaProof Nexus sweep, so they were not part of that public sweep.
This is a useful saturation signal, not evidence that the problems are easy.

## 1. Erdős 700(ii)

Find infinitely many composite integers `n` for which

`min_{1 < k <= n/2} gcd(n, binomial(n,k)) > sqrt(n)`.

The original paper gives prime-square equality, while the current discussion
records conditional-looking families and explicitly identifies the second
subproblem as the plausible one. The discovery bottleneck is an unconditional
infinite family plus uniform `p`-adic control over every admissible `k`, not a
larger table of examples. No user was marked as currently working on it.

Primary material:

- <https://www.erdosproblems.com/700>
- <https://www.erdosproblems.com/forum/thread/700>
- <https://www.renyi.hu/~p_erdos/1978-46.pdf>
- <https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/700.lean>

## 2. Erdős 156

Construct maximal Sidon subsets of `[1,N]` of size `O(N^(1/3))`. Ruzsa's 1998
construction has the remaining factor `(log N)^(1/3)`. The page had zero
comments and no active worker. The useful work is to redesign the covering
construction or its alteration argument so the logarithmic union-bound loss
disappears. Exhaustively finding small maximal Sidon sets does not resolve the
asymptotic target.

Primary material:

- <https://www.erdosproblems.com/156>
- <https://doi.org/10.1023/A:1009757824153>
- <https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/156.lean>

## 3. Erdős 579

Show that every positive-density `K_{2,2,2}`-free graph has a linear-size
independent set. Erdős, Hajnal, Sós, and Szemerédi proved the result above
density `1/8`; the target is to remove that threshold. The page had zero
comments and no active worker. A viable breakthrough is a structural
decomposition, dependent-random-choice refinement, or density-increment
argument. Enumerating finite graphs is not a route to the asymptotic theorem.

Primary material:

- <https://www.erdosproblems.com/579>
- <https://mathweb.ucsd.edu/~erdosproblems/erdos/newproblems/TuranOctahedron.html>
- <https://www.renyi.hu/~p_erdos/1983-09.pdf>
- <https://github.com/google-deepmind/formal-conjectures/blob/e751934294a381afd2d5fc1124c5953c8e25f9fa/FormalConjectures/ErdosProblems/579.lean>

## Launch allocation

Each campaign gets long Pro inference and web/GitHub access, but only six
host-supervised exact jobs total, two concurrently, and one per clean worker.
An exact job must declare a hypothesis, the information it will add, a decision
rule, and a bounded pilot. Generic enumeration is not an accepted job purpose.

The first closure target is a complete natural-language argument with an exact
gap map. Lean is the authoritative endpoint when the current library can
express the proof; a failed elaboration is diagnostic feedback, not evidence
against the mathematics. A campaign without a verified result continues
through materially different representations until its host budget ends.
