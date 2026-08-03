# Erdős 700(iii): ten-worker cross-base obstruction assault

## Immutable target

For composite `n > 1`, define

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n)   = max_{2 <= k <= n/2} D_n(k).
```

Prove or disprove:

```text
for every real A > 0 there is c_A > 0 such that
D(n) >= c_A (log n)^A
```

for every composite `n > 1`. This is exactly Erdős Problem 700(iii), since
`f(n)=n/D(n)`. Do not weaken the quantifiers, replace exact prime-power
components by primes, or prove only a selected family.

## Purpose of this campaign

This is a concentrated continuation, not a fresh brainstorming census. Earlier
campaigns have converged on one shared obstruction: simultaneous compatibility
of carry/Lucas conditions in many changing prime bases. Launch exactly ten
independent clean workers in one host-owned batch immediately, using all ten
concurrency slots. Each role below receives only its delegated task plus
explicit artifact paths. After the batch, synthesize the results and use
retained follow-ups on the strongest proof route and its strongest adversary.

Model inference is the primary compute. Exact jobs are allowed only for a
small symbolic falsifier, identity audit, or candidate verification whose
outcome changes a route. Do not run a larger undirected census.

## Mandatory retained evidence

Before delegating, recover the following compact artifacts with
`inspect_research_artifacts`; never read any `events.jsonl`:

- `math-1784854035-150609/research-note.md`
- `math-1784854035-150609/report.md`
- `math-1784861421-197355/first-pass-synthesis.md`
- `math-1784862756-235913/batch-1-synthesis.md`
- `math-1784862756-235913/batch-2-synthesis.md`
- `math-1784862756-235918/ledger.md`
- `math-1784862756-235920/worker-synthesis-1.md`
- the latest completed worker reports from those runs that directly define
  `UDL(r)`, inequality `(2)`, `FRT(r,B)`, `TCI`, or ballot carry loss.

Treat these as provenance-bearing partial results, not as consensus or proof.
Record an explicit recovery inventory and preserve the immutable target.

## Checked starting point

The campaign may use these only after auditing their proofs:

1. `D_n(k)=k/gcd(k,binomial(n-1,k-1))`.
2. For `q=p^a || n`, `n=qm`, and `k=qs`,
   `v_p(D_n(qs))=[a-v_p(binomial(m,s))]_+`.
3. Simultaneous exact-component survival at `k=Qt` is equivalent to explicit
   scaled digit-containment conditions in the relevant changing bases.
4. Minimal divisors of `n` above `x` form a boundary antichain; if `n|L_x`,
   its lcm covers all but an `x`-factor of `n`.
5. In the dense regime, a reciprocal prime band contains many comparable
   components and reduces the target to explicit simultaneous carry
   inequalities with polynomial multipliers.
6. Full-component marginal density, bounded-density bias, divisor-only
   selection, pairwise compatibility, monotone repair, no-reset recursion,
   and high-order Giuga constructions have explicit failure certificates.
7. Finite examples such as `n=35,42,1001` refute local implications only;
   they neither prove nor disprove the asymptotic target.

## Ten independent roles

Launch all ten at once. Require every report to state one of: a proved theorem
with full quantifiers; a scalable counterfamily with an all-`k` proof; a
smallest exact obstruction to its delegated lemma; or a sharply delimited
unknown with the first unjustified implication exposed.

1. **Uniform diagonal-Lucas prover.** Attack `UDL(r)` directly. Seek a
   changing-base intersection theorem using entropy, polynomial/character
   methods, dependent random choice, containers, or a new deterministic
   selection invariant. It must be uniform in `n`, the interval, bases, and
   exponents. Do not infer joint intersection from marginals.

2. **Uniform diagonal-Lucas adversary.** Try to refute `UDL(2)` or a minimal
   fixed `r` by constructing arbitrarily many comparable exact components of
   one integer whose simultaneous scaled Lucas shadows have no admissible
   multiplier. Prove realizability by a single `n` and all-multiplier
   exclusion. A finite row is only a lemma falsifier.

3. **Boundary-incidence inequality prover.** Prove the exact container
   inequality `(2)` from the boundary synthesis, or replace it with a strictly
   weaker sufficient inequality. Exploit boundary coverage, dense reciprocal
   bands, bounded digit depth, and double counting. Produce the complete
   implication to a polynomial multiplier.

4. **Dense boundary adversary.** Attempt an unbounded family satisfying the
   density hypothesis while defeating every polynomial boundary multiplier.
   Diagnose why the known `n=Pq, x=q` CRT family is too sparse and either
   repair that defect or prove a theorem showing such a repair is impossible.

5. **Growing-depth transversality prover.** Attack squarefree `FRT(r,B)` and
   the hereditary incidence inequalities. Seek a full-shadow cross-base
   transversality theorem at depth comparable to `log n/log X`. Explicitly
   handle endpoint splitting and exceptional first CRT representatives.

6. **Weighted partial-layer probabilist.** Work below full-component
   survival. Construct a distribution on admissible `k` and prove a lower
   tail, factorial-moment, entropy, or energy inequality for
   `log D_n(k)`. Dependence across bases must be bounded rather than assumed;
   test the exact signed covariance obstruction.

7. **Terminal-cylinder/reset packer.** Prove or refute the weighted
   early-crossing/terminal-cylinder statement (`TCI`) or the equivalent
   simultaneous reset-packing lemma. Develop an amortized potential that
   survives cross-base resets, explicitly confronting the `n=81900`
   repair-and-recreation failure.

8. **Powerful-number descent specialist.** Close the repeated-prime-power
   regime via a bounded-multiplier carry-loss theorem or smooth
   last-component descent. Alternatively, turn
   `n_m=lcm(1,...,m)` into a disproof by proving a polynomial all-`k` upper
   bound. Arbitrary helper multipliers must be covered.

9. **Central-binomial ballot specialist.** For
   `N_M=binomial(2M,M)`, prove an aggregate carry-loss bound for a ballot
   witness `K_j`, an averaging replacement over several `K_j`, or a theorem
   transfer that yields `D(N_M)>=M^r` for every fixed `r`. If false, give a
   symbolic obstruction, not merely small computations.

10. **Blind global closer.** Ignore the favored terminology and reconstruct
    the target from the exact valuation identities. Try to splice the best
    unconditional reductions into one proof or construct a genuine
    counterexample. Audit every quantifier and explicitly identify whether the
    shared obstruction is equivalent to the target or leaves real leverage.

## Synthesis discipline

After all ten reports:

1. Build an implication graph separating proved nodes, falsified nodes, and
   open nodes.
2. Merge equivalent formulations of the shared obstruction instead of
   counting them as independent progress.
3. Rank routes by the strength of their proved input and the weakness of their
   remaining lemma.
4. Send at least two retained follow-ups to the leading proof route and two to
   a blind adversary trying to break exactly that lemma.
5. If a worker produces a candidate closure, commission independent
   correctness and quantifier audits before formalization.

The synthesis must regression-test every proposed implication against
`n=30,35,42,60,72,210,252,858,1001,2310`, the interval-primorial family,
and the dense-regime quantifier order. Pair roles `3↔4`, `5↔2`, and `9↔6`
adversarially, then explicitly test whether combining `7+8` or `5+6` closes
the all-fixed-`r` diagonal statement.

## Completion gate

No model consensus or confident prose counts. A complete candidate must include
`candidate.json`, a complete `research-note.md`, `source-audit.md`, and
`solution.lean` proving the exact Formal Conjectures proposition without
`sorry`, `admit`, local axioms, unsafe bypasses, or importing the theorem being
proved. Compile it, audit its axioms, freeze it, and pass the configured host
verifier.

If the target remains unresolved, continue through the available lead turns
and worker budget. Return blocked only at the host-enforced budget boundary,
with the strongest unconditional theorem and the exact irreducible lemma.
