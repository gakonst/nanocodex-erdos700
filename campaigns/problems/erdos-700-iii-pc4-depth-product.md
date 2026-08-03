# Erdős 700(iii): PC4 product-of-prefix-depths assault

## Target

Let

```text
n=q_1*q_2*q_3*q_4,
q_i=p_i^a_i,
q_1<=q_2<=q_3<=q_4=P.
```

Prove or refute PC4:

```text
lambda(n)>P^3
implies
some admissible k has q_i*q_j | D_n(k) for distinct i,j.
```

Equivalently, for some pair `i<j`, with `M=n/(q_i*q_j)`, there is
`1<=t<=floor(M/2)` satisfying

```text
q_j*t <=_{p_i} q_j*M,
q_i*t <=_{p_j} q_i*M.
```

## Mandatory recovery

Recover compact artifacts from `math-1784940116-3770585` and the new
finite-prefix Dirichlet no-go theorem at
`math-1784940116-3770583/worker-reports/agent-3-dirichlet-construction-designer.md`.
Never inspect `events.jsonl`, snapshots, credentials, or telemetry.

## New attack

Assume all six adaptive systems are empty. For each pair, extract the minimal
base-prefix depths that already certify emptiness on the allowed interval.
Turn emptiness into a lower bound on the corresponding product of prefix
moduli by testing structured multipliers whose truncated digits vanish.

Then multiply the six lower bounds around the complete graph on four
components. Seek a contradiction with `lambda(n)>P^3` using:

- the maximal/private prime-power atoms in the four `lambda(q_i)`;
- the exact formula for `lambda(p^a)`;
- multiplicative orders or product-formula constraints created by deep
  cross-base exclusions;
- the numerical consequences `q_1*q_2>8P` and
  `q_1*q_2*q_3>8P^2`.

The key deliverable is a theorem of the form:

```text
all six systems empty
implies
lambda(n) <= P^3,
```

proved through quantitative prefix depths rather than marginal density.

Launch independent workers for:

1. canonical minimal-depth extraction;
2. product inequality over all six pairs;
3. maximal-atom/order upper bounds on those depths;
4. a determinant or height formulation of the same product;
5. powers-of-two and nonsquarefree boundary cases;
6. an unbounded all-six-empty adversary;
7. blind proof and statement audit.

Direct `t=1`, fixed stencils, pairwise marginal density, and another finite
quartet census are forbidden. Use at most one tiny exact job to falsify a
specific depth inequality.

Return a complete PC4 proof, an unconditional unbounded falsifying family, or
the single narrowest remaining depth-product lemma with a rigorous
implication and exact adversarial audit.
