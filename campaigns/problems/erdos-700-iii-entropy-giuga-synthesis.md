# Erdős 700(iii): entropy–Giuga inverse synthesis

## Goal

Prove the subpower Carmichael bridge

```text
lambda(n) <= D(n)^(C L3(n)/log L3(n))
```

for absolute `C` and all sufficiently large composite `n`, or isolate and
attack the single exact inverse theorem needed to prove it. Here

```text
D_n(k) = n/gcd(n,binomial(n,k)),
D(n)   = max_{2<=k<=floor(n/2)} D_n(k),
L3(n)  = log log log n.
```

This bridge, together with the audited Erdős–Pomerance–Schmutz lower bound for
`lambda`, proves Erdős 700(iii).

## Mandatory recovery

Use compact artifacts only. Never inspect `events.jsonl`, snapshots,
credentials, or telemetry. Recover and audit:

- `runs/math-1784949501-3806030/worker-reports/agent-1-variable-depth-martingale-architect.md`
- `runs/math-1784949501-3806030/worker-reports/agent-3-entropy-increment-specialist.md`
- `runs/math-1784949501-3806030/worker-reports/agent-10-adversarial-proof-auditor.md`
- `runs/math-1784949501-3806030/worker-reports/agent-5-counterfamily-designer.md`
- `runs/math-1784949501-3806028/worker-reports/agent-5-threshold-optimizer.md`
- `runs/math-1784949501-3806029/worker-reports/agent-4-exact-greedy-realization-specialist.md`
- `runs/math-1784947385-3800908/worker-reports/agent-3-carmichael-atom-transfer.md`
- `runs/math-1784947385-3800908/worker-reports/agent-8-blind-independent-solver.md`

Reprove every inherited identity used.

## Exact starting point

Write `n=product_i p_i^a_i`, `W=log lambda(n)`, and assign each maximal
Carmichael atom once to an attaining component. Split the owner weight into
front-loaded actual layer weights `w_alpha`, with probability mass
`pi_alpha=w_alpha/W`. Let

```text
S_alpha = {k in K_n : the corresponding actual D-layer survives at k}.
```

For a probability law `nu` on the actual finite set `K_n`, define

```text
Phi_n(pi) = min_nu sum_alpha pi_alpha log(1/nu(S_alpha)).
```

The recovered entropy-selection theorem is

```text
max_k log D_n(k) >= W exp(-Phi_n(pi)).
```

Its exact dual is over weights `x_alpha>=0` satisfying

```text
sum_{alpha: k in S_alpha} x_alpha <= 1   for every actual k in K_n.
```

With `h=ceil(L3/log L3)`, it is enough in the hard branch
`log Q < W/(16h)` to prove, for some legitimate owner assignment,

```text
Phi_n(pi) <= log(16h).
```

Do not merely rename this assertion. Prove it, weaken it while retaining the
subpower implication, or derive the narrowest exact arithmetic obstruction.

## Required inverse attack

The falsifier campaign proved for squarefree `n`, with

```text
h_p = v_p(n/p - 1),
```

the exact common-index inequality

```text
sum_{p supported at k} (h_p+1) log p <= log(k(n-k)) <= log(n^2/4).
```

It also showed that an attempted counterfamily with many large `h_p` becomes a
higher-order Giuga system

```text
n/p = 1 mod p^H,
```

whose sequential Dirichlet construction is killed by the product of its CRT
moduli.

Prove an inverse theorem connecting these facts:

> If every legitimate ownership has entropy cost larger than `log(Ah)`, then a
> quantitatively large owner-weight subset has sufficiently deep, mutually
> coherent support exclusions to yield high-order Giuga/control congruences.
> Multiplying those congruences, together with the hard-load condition
> `lambda(n)>Q^(Ah)`, must contradict `n`, or else give an explicit
> unconditional counterfamily with an all-index certificate.

The implication from large entropy to congruence depth is the main new work.
It must use actual common-cell floor phases, not abstract incidence alone.

## Required decomposition

1. Prove the squarefree horizontal-atom case first, including exact endpoints.
2. Treat vertical atoms and nonsquarefree partial layers separately. Use the
   exact right-closed block formula
   `d_i(k)=(v_p(k)-v_p(binomial(n/q_i-1,floor((k-1)/q_i))))_+`.
3. Use the easy large-component branch before invoking the inverse theorem.
4. Explore the complementary-unitary-divisor reduction:
   if `n=de` is unitary and
   `G_n(d)G_n(e)<=Qn/lambda(n)`, then three actual rows already prove the
   cubic bridge. Determine whether entropy failure forces such a split.
5. Attack every proposed inverse lemma on `15`, `90`, `7293`, `183744`,
   `493955`, and `23*29*47*59`.

## Worker portfolio

Launch independent inference workers for:

1. entropy-dual inverse theorem;
2. squarefree support-depth/Giuga extraction;
3. weighted congruence-product contradiction;
4. nonsquarefree partial-layer extension;
5. vertical/horizontal Carmichael-atom separation;
6. common-cell phase inverse theorem;
7. unitary complementary-split route;
8. explicit arithmetic counterfamily adversary;
9. constants, rates, and EPS implication audit;
10. blind proof reconstruction and hostile referee.

Each worker must attack one exact lemma from both directions. No generic
census, unproved prime constellation, abstract set-system substitution,
marginal multiplication, fixed multiplier list, deletion of components, or
separate-index witness may count as proof.

## Deliverable

Return one of:

1. a complete paper-level proof of the subpower bridge with explicit constants
   and threshold;
2. an unconditional unbounded all-index counterfamily, with a precise audit of
   whether it refutes only the bridge or Erdős 700(iii);
3. the single narrowest false-or-unproved inverse lemma, all proved arrows
   around it, and an explicit next prompt that attacks only that lemma.

Do not create `candidate.json` or start Lean until the complete original
Part (iii) chain is proved. No `sorry`, new axioms, finite evidence, or model
agreement counts as completion.
