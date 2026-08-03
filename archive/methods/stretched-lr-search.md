# Stretched Littlewood–Richardson search

This note records the reusable methodology from the live bounded search. It is
not a solution claim. A triple is successful only after it is frozen and the
preapproved verifier accepts it.

## Certificate target

For partitions of maximum length `n`, use the hive degree bound
`D = (n - 1)(n - 2)/2`. Reconstruct the polynomial from `D + 1` exact positive
stretch values, not from an assumed value at zero, and check at least two fresh
positive stretches. The reconstructed ordinary-basis constant must be exactly
one and at least one ordinary coefficient must be strictly negative. Keep all
integers and rational coefficients exact.

Calibrate the lrcalc argument order before every campaign with

- `c^(2)_(1),(1) = 1`;
- `c^(1,1)_(1),(1) = 1`;
- `c^(3,2,1)_(2,1),(2,1) = 2`.

The final verifier receives only a content-addressed frozen manifest and
`candidate.json`. Search-generated checkers rank candidates but never replace
that verifier.

## Rigorous filters

- Reject malformed, unbalanced, or out-of-bound partitions.
- Set the ambient rank separately for every triple to the maximum of all three
  partition lengths. A Schur product may produce an outer partition longer
  than either input; a degree bound inherited from only the inputs is unsound.
- Reject base coefficient zero. Saturation makes all positive stretches zero,
  so inserting `P(0) = 1` would manufacture a false interpolation polynomial.
- Reject base coefficient one: the multiplicity-one theorem makes the stretch
  polynomial constant one.
- Reject exact hive dimension at most two. A negative ordinary coefficient
  requires dimension at least three.
- Length at most three is automatically positive. Length four is not removed
  by generic Ehrhart theory; it reduces to the exact cubic inequality
  `2 P(3) - 9 P(2) + 18 P(1) < 11` for a counterexample.
- Canonicalize the two inner partitions, determinant twists, and common gcd
  scaling. Do not use conjugation as a stretch symmetry.
- The conjugation warning has a small exact certificate. The triples
  `([6,4,2]; [4,2], [4,2])` and its transpose
  `([3,3,2,2,1,1]; [2,2,1,1], [2,2,1,1])` agree at `t=1` with value 3 but
  give 5 versus 6 at `t=2` and 7 versus 10 at `t=3`, matching `2t+1` and
  `(t+1)(t+2)/2`. Conjugation preserves a fixed LR coefficient, but
  `(t lambda)'` is generally not `t (lambda')`.
- Timeout, crash, memory exhaustion, and cancellation mean `unknown`, never a
  coefficient value of zero.

## Progressive exact evaluation

Every potentially blocking lrcalc call runs in a killable process or under a
tested interrupt plus an outer process deadline. A robust default is:

1. compute `P(1)` with a short deadline;
2. compute `P(2)` and rank delayed growth without drawing a conclusion;
3. compute only as many further values as a proved degree or exact dimension
   requires;
4. reconstruct over `QQ` and check a fresh positive stretch;
5. spend a larger, still finite deadline only on frozen finalists;
6. run the independent preapproved verifier.

After every partial set of exact values, one may solve the rational feasibility
problem `y_i = sum_j c_j t_i^j`, `c_j >= 0`, under the certified degree bound.
Infeasibility is already a rigorous negative-coefficient certificate when
accompanied by an exact Farkas vector `z` satisfying
`sum_i z_i t_i^j >= 0` for every power and `sum_i z_i y_i < 0`. Feasibility is
not a rejection rule; later values can still force a negative coefficient.

The reusable fork-per-call implementation is retained as
`bounded_eval.sage` in the campaign directory. It escalates terminate to kill,
records timeout and crash separately, and emits completed evidence
incrementally so an outer cancellation does not erase prior results.

For the discovery funnel, prefer the pinned Python `lrcalc` binding over a full
Sage process. In the live continuation it screened 1.6 million low-base
supported triples in 4.4 seconds and four million generic rank-seven triples in
26 seconds. Sage remains valuable as an independent reconstruction and final
verification path. Eight generic six-by-six inner-partition candidates then
exceeded 900 seconds when evaluated blindly through `t=18`; those timeouts are
unknowns and show that higher-stretch work needs incremental checkpoints,
finite-difference/Farkas stopping, or a hive/polyhedral algorithm.

## Search distributions

Naively selecting the largest base LR coefficients from random Schur products
biases toward large early Hilbert-numerator mass and repeatedly produces
positive polynomials. Better distributions include:

- small positive `P(1)` with anomalously large `P(2)`;
- uniform support sampling inside explicit base-multiplicity strata;
- normalized triples one lattice unit inside several Horn facets rather than
  triples exactly on factorizing facets;
- guaranteed-feasible hive or Pieri-atom mutations;
- disconnected-row/Kostka families as a finite control family;
- exact rank-four cubic screening before assuming rank five is minimal.

When ranking ordinary coefficients, exclude both the leading and
next-to-leading coefficients: Ehrhart theory forces both positive. Score only
degrees `1 .. d-2`. A tiny positive next-to-leading coefficient is not useful
counterexample pressure.

## Live evidence so far

The run `runs/math-1784772124-33565` retained the following negative results:

- eight literature- and structure-derived priority candidates were evaluated
  exactly through stretch 18; all had positive ordinary coefficients;
- all 3,129 bounded disconnected-row/Kostka cases were visited;
- 2,511 supported cases completed exact interpolation and held-out checks in
  the original sweep;
- the 28 original Kostka timeouts were subsequently repaired with an
  independent horizontal-strip dynamic program. All 28 completed in 193
  seconds, matched `lrcalc` at stretches 1 and 2, passed held-out evaluations
  at stretches 16 and 17, and had no negative ordinary coefficient;
- none of the completed Kostka cases had a negative coefficient.
- a continuation screened 1.6 million primitive low-base supported triples;
  exact interpolation of its 400 global elites found no negative coefficient;
- a separate four-million-candidate generic rank-seven screen retained 400
  full-rank six-by-six inputs, but its first eight complete-interpolation jobs
  exceeded their 900-second deadlines and remain explicitly undecided.

The first uniform-support search completed 40,000 exact polynomials across four
low/mixed multiplicity shards with 44 per-call timeouts and no negative
coefficient. Four high-multiplicity shards emitted no checkpoint before their
1,500-second outer deadlines, so their partial work is unknown and contributes
nothing to the negative-result denominator. These censuses refute routes and
bounded sampled subfamilies, not the immutable open problem.

## Operational lessons

- Pro reasoning silence is not a transport failure. Nanocodex applies no
  application-event idle timeout in Pro mode; caller-owned worker and campaign
  deadlines still bound the work.
- A genuine socket send or receive failure remains retryable and replays
  committed history on a replacement socket.
- `spawn_math_batch` returns an object with `items`, `succeeded`, and `failed`;
  it is not itself iterable. Full event recording made one misuse recoverable,
  but consumers should read `batch.items` directly.
- Long exact searches need both local call bounds and an outer shard deadline.
  A shard that produces no completed cases for a configured interval should be
  cancelled as an unproductive stratum and its remaining work marked unknown.
- Run those shards through `run_exact_job`, emit a JSON checkpoint or update a
  declared heartbeat after each bounded block, and let the host enforce both
  total and no-progress deadlines with full process-group cleanup. A
  `no-progress` result is search censorship, not negative evidence; change the
  decomposition, local timeout, or algorithm before retrying.
