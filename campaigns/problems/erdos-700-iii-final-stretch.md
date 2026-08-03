# Erdős 700(iii): Carmichael final stretch

## Mission

Work only on the exact remaining obstruction for Part (iii). This is a
closing campaign, not a new broad brainstorm.

For composite `n`, define

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n)   = max_{2 <= k <= n/2} D_n(k).
```

The target is

```text
for every A > 0 there is c_A > 0 such that
D(n) >= c_A (log n)^A
```

for every composite `n`.

The surviving sufficient hypothesis is

```text
H_lambda: lambda(n) <= D(n)^3
```

where `lambda` is the Carmichael function. The retained minimal-order theorem
for `lambda`, with its uniform finite-exception audit, makes `H_lambda` imply
the target. Recheck that implication before using it.

## Mandatory recovery

Use `inspect_research_artifacts`; never inspect `events.jsonl`, snapshots,
credentials, or telemetry. Recover:

- all worker reports from `math-1784935021-3712996`;
- especially reports 3, 5, 9, and 12--19;
- the compact dead-end maps and ledgers under
  `math-1784930588-3685474`;
- only directly relevant predecessor artifacts referenced by those reports.

The two sibling campaigns in the same old batch are route-falsification
evidence:

- `math-1784935021-3712997`: `AQG_100` is false at
  `n=20806=2*101*103`; full-row convolution preserves primewise/LCD
  information but does not choose one coefficient carrying many primes.
- `math-1784935021-3712998`: the cubic primorial support hypothesis has exact
  finite falsifiers at `59#` and `61#`; no unbounded family was proved.

Do not relaunch either hypothesis.

## Audited starting identities

For `B = binomial(n-1,k-1)`,

```text
D_n(k) = k / gcd(k,B),   D_n(k) | k,   D_n(k) | n.
```

If `q_i=p_i^a_i || n` is an exact prime-power component, then

```text
q_i | D_n(k)
iff
k=q_i*t and t is digitwise dominated by n/q_i in base p_i.
```

For multiprime `n`,

```text
lambda(n)
  = lcm_{2 <= k <= n/2} lambda(D_n(k)).
```

Prime powers are a separate easy case. `H_lambda` is already proved for
`omega(n) <= 3`.

Assign every maximal prime-power atom of `lambda(n)` to one exact component
that realizes it. If those owned atoms can be covered by three actual Lucas
supports `S(k)={i:q_i|D_n(k)}`, then `H_lambda` follows. Abstract set-cover or
lcm data do not imply this: report 15 gives a seven-component abstract
obstruction, while reports 16 and 17 give exact arithmetic falsifiers to
naive three-row and fractional-cover strengthenings.

## The exact first test case

For four exact components

```text
q_1 <= q_2 <= q_3 <= q_4=P,
n=q_1*q_2*q_3*q_4,
```

the first unresolved statement is:

```text
PC4:
if lambda(n) > P^3, then there are i<j and
1 <= t <= (n/(q_i*q_j))/2 such that

q_j*t is digitwise dominated by q_j*n/(q_i*q_j) in base p_i,
q_i*t is digitwise dominated by q_i*n/(q_i*q_j) in base p_j.
```

Equivalently, some admissible `k=q_i*q_j*t` has two full components in
`D_n(k)`. For squarefree four-prime `n`, a falsifier of PC4 is an actual
falsifier of `H_lambda`. Direct products (`t=1`) are known false, including an
unconditional infinite family; PC4 allows adaptive `t`.

## Required three-route portfolio

Launch exactly three independent campaigns in one host-owned batch. Do not
launch cosmetic variants.

### Route 1: PC4 proof/disproof

Prove PC4 using the simultaneous two-base Lucas system, or produce an explicit
unbounded family of four exact components satisfying `lambda(n)>P^3` for which
all six systems are empty. A finite search is only a falsifier/regression
test. Search for a theorem that uses the strong arithmetic content of
`lambda(n)>P^3`: private prime-power atoms in the `q_i-1` or
`lambda(q_i)`, multiplicative order, least simultaneous digit-submask
representatives, or a product-formula/determinant obstruction.

The report must include:

- the exact implication from PC4 to the four-component case;
- an exact reformulation as six finite digit systems;
- the first failed inference and its smallest certificate;
- either a proof with constants or an unbounded all-six-empty family.

### Route 2: global weighted Lucas cover

Attack `H_lambda` directly. Let `L_i` be the pairwise-coprime owned atom load
of component `q_i`, so `product L_i=lambda(n)` and `L_i|lambda(q_i)`.
Prove one of:

```text
LC3:
the loaded components partition into three sets, each contained in an actual
Lucas support S(k);
```

or the weaker sufficient statement:

```text
if product L_i > X^3, some actual support S(k) contains a subset B with
product_{i in B} q_i > X.
```

The theorem must exploit arithmetic residue/digit structure and must survive
the exact counterexamples in reports 15--18. Abstract hypergraph cover,
fractional cover, marginal density, pairwise gluing, or a renaming of DFC is
not progress. If the statement is false, produce an unbounded arithmetic
family and an all-index support certificate.

### Route 3: adversarial H_lambda counterexample

Try to refute `H_lambda` itself, not an auxiliary strengthening. Construct an
unbounded family with

```text
lambda(n) > D(n)^3
```

and prove the required upper bound on `D_n(k)` for every admissible `k`.
Prioritize structured many-component families suggested by private Carmichael
atoms, but reject any construction that supplies only finite data, abstract
support incidence, or selected-index checks. If no family survives, derive a
rigorous structural theorem excluding the broadest attempted family and feed
that theorem back into Route 2.

## Dead routes

Do not use any of the following without a new theorem that explicitly escapes
its retained counterexample:

- AQG, scaled-index quotient descent, or direct coefficient lifting;
- cubic primorial support/cardinality bounds;
- fixed `t`, fixed rational stencils, or fixed multiplier packets;
- marginal-to-common-index or primewise-LCD-to-one-coefficient inference;
- divisor-only or pairwise witness gluing;
- deletion monotonicity (`D(90)<D(45)`);
- naive three-row cover, universal weighted fractional three-cover, or
  unweighted Lucas probability;
- mean rational-cut energy, bounded-loss transport, generic VC/Helly/container
  arguments, or broad BG packets already killed by determinant obstructions;
- finite census without an unbounded mechanism.

## Adaptive synthesis and completion gate

After the three first-wave reports:

1. Build one implication graph with proved, false, and open nodes.
2. Independently audit every claimed exact identity.
3. Select the single weakest surviving quantified lemma.
4. Use follow-ups in matched pairs: one proof attempt and one explicit
   falsification attempt against exactly the same statement.
5. A failed auxiliary hypothesis is useful but is not a candidate solution.
6. Hand off immediately if a complete proof or counterexample appears.

Completion requires a self-contained proof or counterexample for the original
Part (iii) quantifiers, independent statement/quantifier audits,
`research-note.md`, `route-map.md`, `source-audit.md`, `candidate.json`, and a
no-hole `solution.lean` accepted by the host verifier. Lean may begin only
after the mathematical argument is complete enough to state exactly. No
`sorry`, `admit`, local axioms, target-theorem import, model consensus, or
finite experiment counts as success.

If the host budget ends without a solution, preserve the strongest proved
uniform theorem, the exact first remaining lemma, and every new falsifier.
