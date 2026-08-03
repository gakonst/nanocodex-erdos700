You are the lead mathematician for a single all-in campaign on Erdős Problem 700(iii).
Turbo recursive task tools are enabled. Use them aggressively and correctly:

1. In Code Mode, call `context()` to inspect only the information actually available to you.
2. Immediately call `tools.task_batch` with 16 genuinely diverse clean-room tasks and a strict shared JSON output schema. Do not merely propose the batch in prose.
3. Retain the returned task IDs. Use `tools.task_continue` for at least two adversarial repair rounds on every candidate that claims a theorem, counterexample, or quantitatively sufficient bridge.
4. Run a second independent verifier/referee batch on the best surviving candidates. A verifier must reconstruct the argument rather than vote on it.
5. Recursion is available to depth 4 and up to 64 active tasks. Delegate exact bounded lemmas to children, but keep one explicit implication ledger at the root.
6. Continue until you either have a complete proof/counterproof of the original statement, or can name the single narrowest exact missing lemma after exhausting serious proof and falsification attempts. Long responses are useful; preserve their mathematics in compact artifacts.

## Original target

For composite n and 2 <= k <= floor(n/2), define

    D_n(k) = n / gcd(n, binomial(n,k)),
    D(n)   = max_{2 <= k <= floor(n/2)} D_n(k).

Prove Erdős 700(iii): for every real A > 0, there is c_A > 0 and N_A such that every composite n >= N_A satisfies

    D(n) >= c_A (log n)^A.

The completed Part (i) and Part (ii) material is context only. Do not confuse proving an auxiliary Carmichael bridge with proving the original statement. Every final implication and quantifier must be audited.

## Workspace and evidence discipline

Work in:

    /home/ubuntu/campaigns/erdos700-research/nanocodex-erdos700

Start from the immutable objective and compact reports in that repository. You may use ordinary safe file reads and web search. Never read or summarize `events.jsonl`, session snapshots, credentials, `.env`, or telemetry. Do not launch a broad CPU-bound census. Tiny exact computations are allowed only to falsify a named lemma or check a compact certificate, with a declared hypothesis and kill rule.

Recover and rederive, rather than blindly trust, the strongest compact artifacts from:

    campaigns/problems/erdos-700-iii.md
    campaigns/problems/erdos-700-iii-final-stretch.md
    campaigns/problems/erdos-700-iii-entropy-giuga-synthesis.md
    campaigns/problems/erdos-700-iii-annular-carry-compression.md
    runs/math-1784951581-3832265/
    runs/math-1784951908-3834501/
    loops/loop-1784948761-3803975/

Inspect only compact reports, implication maps, verifier sources, and small declared artifacts. Locate additional compact descendants as needed.

## Exact proved/recovered frontier to audit

The current route seeks the subpower Carmichael bridge

    lambda(n) <= D(n)^(C L3(n)/log L3(n)),
    L3(n) = log log log n,

for an absolute C and sufficiently large composite n. Together with the already audited uniform lower bound for Carmichael's function, this would imply the original Part (iii). Reprove the bridge-to-target implication, including constants and thresholds.

Known exact reductions that must be checked:

1. Entropy selection. After assigning maximal Carmichael atoms to attaining components and splitting into actual layer weights w_alpha with pi_alpha=w_alpha/W, W=log lambda(n), define actual support sets S_alpha over the finite admissible index set K_n and

       Phi_n(pi) = min_nu sum_alpha pi_alpha log(1/nu(S_alpha)).

   The recovered selection theorem is

       max_k log D_n(k) >= W exp(-Phi_n(pi)).

   In the hard branch it is enough at h=ceil(L3/log L3) to show Phi_n(pi) <= log(16h), yielding an explicit bridge constant near 22 after all losses. The missing step is an arithmetic inverse theorem on actual common cells, not an abstract set-system assertion.

2. Annular carry compression. For a sponsored component p^a || n, with requested retained depth b_p,

       L_p     = floor(log_p(n/p^a)),
       delta_p = max(0, b_p + L_p - a),
       mu_p    = p^(a+delta_p).

   The robust zero-block theorem says

       mu_p | K and 0 < K < n  =>  p^b_p | D_n(K).

   Next-fit gives a zero-duplication certificate with at most

       3 + (2/log n) sum_p delta_p log p

   rows. With the known defect annuli, the desired bridge follows if actual common rows cover owners while the total residual Z satisfies

       #rows + (2/log n) sum_{p in Z} delta_p log p
           = O(L3/log L3).

   Squarefree components make zero-block moduli overpay; any closure must use exact nonzero common-cell phases, signed prefixes, entropy, a congruence-product contradiction, or a rigorously adequate alternative.

3. Balanced-square stress test. Let

       n = (product_{i=1}^r p_i)^2

   for balanced odd primes. Private atoms can force only depth 2 and concentrate all defects in one annulus. For B subset {1,...,r}, put

       Q_B = product_{i in B} p_i^2,
       R_B = n/Q_B,
       c_i = Q_B/p_i^2.

   A common row of the form k=Q_B t exists exactly when some integer

       1 <= t <= floor(R_B/2)

   satisfies for every i in B the simultaneous Lucas condition

       v_{p_i} binomial(c_i R_B, c_i t) = 0,

   equivalently the relevant base-p_i digitwise submask relation. The bottleneck is to prove the exact all-multiplier cover number

       tau(P) = O(log log r / log log log r)

   uniformly, or produce an unconditional unbounded counterfamily showing that the proposed bridge fails. Complement-row-only reductions are false; arbitrary multipliers t are essential.

4. A tempting converse from support incompatibility to deep Giuga congruences is false: 7293 and 23*29*47*59 exhibit zero-depth incompatible supports. Any inverse theorem must aggregate weighted common-cell phase information, not infer depth from a single missing intersection.

5. There is an exact Newton-identity theorem that no squarefree composite n satisfies

       p^2 | n/p - 1 for every p | n.

   Audit whether weighted or partial variants can give the quantitative contradiction actually needed. Do not silently upgrade this theorem.

6. Known dead ends: abstract set cover or fractional cover; multiplying marginal densities; complement rows only; fixed multiplier stencils; deletion/induction on components; selected-index evidence; separate-index products treated as one row; unproved prime constellations; broad finite searches. LC3 fails at 183744 and the fractional relaxation fails at 493955. Hostile examples include 15, 90, 7293, 183744, 493955, 23*29*47*59, and balanced squares.

## Required first batch

Give the 16 clean workers complementary assignments:

1. reconstruct the complete target implication and locate the first unproved arrow;
2. prove the weighted common-cell phase inverse theorem;
3. falsify the strongest plausible weighted phase inverse theorem and return the weakest survivor;
4. prove balanced-square simultaneous Lucas cover via digit boxes;
5. build an unconditional balanced-square counterfamily or prove a no-go theorem;
6. derive an aggregate Hankel/determinant contradiction from coherent low-digit anchors;
7. derive a product-of-prefix-moduli contradiction with all quantifiers;
8. specialize the entropy dual to one defect annulus and solve it;
9. combine signed-prefix CRT choices with actual half-interval witnesses;
10. prove the squarefree horizontal-atom case;
11. extend a valid squarefree argument to vertical atoms and partial prime-power Kummer layers;
12. exploit complementary unitary divisors with exact common rows;
13. search the literature/web for a directly applicable simultaneous Lucas, digital box, entropy inverse, or covering theorem and map hypotheses exactly;
14. hostile referee: attack all inherited reductions and claimed asymptotics;
15. blind solver forbidden from following named routes, seeking a fundamentally different proof;
16. synthesis architect: derive the weakest theorem that is both plausibly provable and quantitatively sufficient.

Use a shared schema containing at least:

    status: proved | disproved | partial | blocked
    exact_statement
    proof_or_counterexample
    implication_to_original
    assumptions
    first_gap
    hostile_tests
    next_repairs

## Acceptance bar

A proof is complete only if:

- it supplies one actual admissible k for each claimed common row;
- Lucas/Kummer statements include all prime-power and partial-valuation cases used;
- it preserves a common index instead of multiplying separate witnesses;
- all asymptotic constants, equality cases, and sufficiently-large thresholds are stated;
- every external theorem is cited with exact hypotheses;
- a hostile independent verifier can reconstruct every implication;
- the final result proves the original uniform statement, not merely H_lambda or one family.

If the mathematics closes, write a paper-level proof and compact implication audit under a new descriptive directory in `runs/`, then prepare `candidate.json` and a Lean formalization plan. Do not use `sorry`, `admit`, new axioms, or model consensus. If it does not close, write the narrowest exact surviving lemma, proved arrows around it, explicit falsifiers, and the strongest next prompt. Keep pushing with recursive repair rounds before declaring that outcome.
