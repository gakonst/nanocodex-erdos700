# Erdős 700(iii): annular carry-compression closure

## Goal

Close the subpower Carmichael bridge

```text
lambda(n) <= D(n)^(C L3(n)/log L3(n))
```

by proving the annular carry-compression lemma isolated below. A complete
bridge proves Erdős 700(iii) using the already audited uniform lower bound for
the Carmichael function.

## Mandatory compact recovery

Never inspect `events.jsonl`, snapshots, credentials, or telemetry. Recover,
rederive, and adversarially audit:

- `runs/math-1784949501-3806031/worker-reports/agent-2-recursive-batching-architect.md`
- `runs/math-1784949501-3806030/worker-reports/agent-1-variable-depth-martingale-architect.md`
- `runs/math-1784949501-3806030/worker-reports/agent-3-entropy-increment-specialist.md`
- `runs/math-1784949501-3806030/worker-reports/agent-5-counterfamily-designer.md`
- `runs/math-1784949501-3806030/worker-reports/agent-10-adversarial-proof-auditor.md`
- `runs/math-1784949501-3806029/worker-reports/agent-4-exact-greedy-realization-specialist.md`
- `runs/math-1784949501-3806029/worker-reports/agent-3-squarefree-counterfamily-scout.md`

## Exact proved starting theorem

Fix maximal Carmichael-atom sponsors. For a sponsored component
`p^a || n`, let `b_p` be the largest requested retained depth and set

```text
L_p     = floor(log_p(n/p^a)),
delta_p = max(0, b_p + L_p - a),
mu_p    = p^(a+delta_p).
```

The robust zero-block theorem is proved:

```text
mu_p | K and 0<K<n  ==>  p^b_p | D_n(K).
```

Consequently any group `B` with

```text
product_{p in B} mu_p < n
```

has one actual common witness

```text
k_B=min(product mu_p, n-product mu_p).
```

Next-fit gives an exact zero-duplication certificate with at most

```text
3 + (2/log n) sum_p delta_p log p
```

rows. This is a theorem, not a target.

Let `Delta=max delta_p`, `h=log log Delta`, and form defect annuli by

```text
Delta_{j+1}=Delta_j^(1/log log Delta_j),
h_{j+1}=h_j-log h_j.
```

The number of annuli is

```text
O(L3(n)/log L3(n)).
```

Thus the bridge closes if, after a suitable legitimate sponsor choice, every
annulus can be covered by `O(1)` actual common rows, or has

```text
sum_{p in annulus} delta_p log p = O(log n).
```

## Main target

Prove the weakest exact version of:

> Annular carry-compression. There are absolute constants `A,D0` such that for
> every sufficiently large multiprime `n`, maximal atoms admit sponsors for
> which each defect annulus above `D0` is covered by at most `A` actual rows,
> each row satisfying the exact Kummer conditions for all sponsored demands
> assigned to it.

If the literal statement is false, weaken the annulus, allow a total
`O(number of annuli)` budget, or replace zero-block witnesses with exact
nonzero common-cell witnesses, while preserving
`O(L3/log L3)` total rows.

## Required new mechanism

Zero-block moduli alone overpay squarefree components:
for `a=b=1`, `delta_p log p` is nearly `log(n/p)`. Use at least one of:

1. signed residue choices `K=0` or `n` modulo controlled prime-power prefixes;
2. the exact entropy dual on actual layer-support sets;
3. an inverse theorem turning failure of annular compression into a
   high-order Giuga/control system `n/p=1 mod p^H`;
4. multiplication of the resulting CRT moduli to contradict the hard-load
   branch;
5. an exact common-cell phase or complementary-unitary-divisor theorem.

You must connect the mechanism to `delta_p`; a generic incidence or entropy
statement is insufficient.

## Decomposition requirements

1. Solve squarefree horizontal sponsors first.
2. Handle vertical atoms and nonsquarefree partial layers separately.
3. Use the easy largest-component branch before the annular argument.
4. Preserve one common integer per row and the exact half interval.
5. Audit `15`, `90`, `7293`, `183744`, `493955`, `23*29*47*59`, and the
   infinite forced-row family `10*3^a`.

## Worker portfolio

Launch independent inference workers for:

1. direct annular compression proof;
2. signed-prefix CRT batching;
3. entropy dual specialized to one defect annulus;
4. Giuga inverse extraction from annular failure;
5. squarefree proof;
6. prime-power/vertical extension;
7. complementary unitary split;
8. symbolic counterfamily and size-tax auditor;
9. recurrence/constants/EPS implication;
10. blind hostile reconstruction.

Every worker attacks one exact lemma from both directions. Do not use a
generic census, unproved prime patterns, deletion of components, abstract
set cover, marginal multiplication, fixed multiplier lists, or separate-index
witnesses.

## Deliverable

Return a complete proof with constants; an unconditional unbounded all-index
counterfamily; or the single narrowest surviving annular lemma with all proved
implications and exact falsifiers. No `candidate.json` or Lean until the
complete original Part (iii) chain is mathematically closed. No `sorry`,
new axioms, finite evidence, or model agreement counts.
