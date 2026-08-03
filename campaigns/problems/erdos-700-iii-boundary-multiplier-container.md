# Erdős Problem 700(iii): boundary-multiplier container

## Immutable target

For

```text
D_n(k) = n / gcd(n, binomial(n,k)),
D(n) = max_{2 <= k <= n/2} D_n(k),
L_x = lcm(1,...,floor(x)),
```

prove the exact uniform statement equivalent to Erdős 700(iii):

```text
for every A > 0, D(n) >= c_A (log n)^A
for every sufficiently large composite n.
```

Constants may depend on `A`, but never on `n`.

This is a narrow parallel continuation. Recover every report and exact-job
result from:

```text
runs/math-1784843263-47602/
runs/math-1784854035-150609/
```

Never inspect an `events.jsonl`.

Also read:

- `proof/PartIWork/BoundaryAntichain.lean`;
- `proof/PartIWork/boundary-antichain.md`;
- `proof/PartIWork/STRUCTURAL_UPGRADE.md`;
- the current Part-(iii) campaign prompts.

Do not repeat a retained route unless you are repairing its precise failed
lemma.

## Exact target lemma

For real `x >= 2` and `n | L_x`, define the overweight boundary

```text
B_x(n) = {
  d | n :
  x < d and
  d/p <= x for every prime p | d
}.
```

Prove or refute the following **polynomial-multiplier boundary container**:

> For every `epsilon > 0` there exist
> `B_epsilon, C_epsilon, x_epsilon > 0` such that, whenever
> `x >= x_epsilon`, `n` is composite, `n | L_x`, and
>
> ```text
> log n > C_epsilon * x^epsilon,
> ```
>
> there are `d in B_x(n)` and an integer `m` satisfying
>
> ```text
> 1 <= m <= x^B_epsilon,
> 2 <= d*m <= n/2,
> d | D_n(d*m).
> ```

It is acceptable to strengthen `x^B_epsilon` to a smaller bound or weaken it
to `exp(x^o(1))` if the resulting quantified theorem still closes
`H(x)=x^o(1)`. It is not acceptable to silently set `m=1`.

Using the checked carry formalism, the last condition should be audited
against the exact family of inequalities

```text
residueCarryCount n (d*m) p
  <= factorization(n,p) - factorization(d,p)
```

for every prime `p | d`.

A proof gives `D(n)>x`, hence

```text
H(x) = max { log n : n composite and D(n) <= x } = x^o(1),
```

which proves Part (iii). A refutation of this target lemma is not
automatically a refutation of Part (iii).

## Independent first-pass roles

Launch all six roles independently before synthesis.

1. **Boundary-antichain architect.** Reconstruct the exact reduction from an
   overweight witness to a divisibility-minimal `d`, retaining the multiplier
   `m`. Determine the structure and total weight of `B_x(n)` when `n | L_x`.
2. **Carry-cylinder/container specialist.** Regard the conditions for each
   `(d,m)` as intersections of explicit p-adic residue cylinders. Seek an
   entropy, container, covering, or forbidden-configuration theorem forcing
   a feasible pair when `log n` is large.
3. **Multiplier-scale specialist.** Bound the least feasible multiplier from
   the exact carry inequalities. Adaptive enlargement, resets, cofactor-scale
   information, and partial layers are allowed. The already-refuted
   bounded-loss/no-reset recursion is not.
4. **Extremal-lcm specialist.** Use
   `v_p(n) <= floor(log_p x)` and `log n > C*x^epsilon` to derive a dense
   exponent configuration. Seek a forbidden configuration inside the divisor
   lattice without assuming monotonicity of `D`.
5. **Adversarial constructor.** Try to build an unbounded family `n | L_x`
   for which every overweight boundary divisor has an enormous least feasible
   multiplier. Separate a counterexample to a proposed constant, a
   counterexample to the target lemma, and a genuine disproof of Part (iii).
6. **Blind implication referee.** Reconstruct the implication from the target
   lemma to Part (iii), including all constants, quantifier order, the
   half-interval, prime powers, and small exceptions. Attempt to falsify every
   load-bearing statement before accepting it.

After first-pass synthesis, use retained follow-ups on the strongest proposed
container/multiplier lemma and on a fresh adversary specifically instructed to
refute it.

## Mandatory failure certificates

Every proposal must survive:

- `(n,x)=(60,10)`: multiplier-one compression is false; `d=15,m=2`
  detects the overweight witness.
- `n=72`: partial prime-power layers matter; a binary full-component argument
  is invalid.
- `n=858,k=338`: useful witnesses need not divide `n`.
- `45 | 90` and `72 | 144`: neither direction of naive divisor-lattice
  monotonicity is available.
- `n=30` and `n=p(p^2+1)`: bounded-loss/no-reset recursion is unavailable.

To refute the polynomial-multiplier lemma, produce one fixed `epsilon > 0`
and an unbounded family defeating every permitted choice of
`B_epsilon,C_epsilon`. A single finite example refutes only the proposed
proof or constants.

Do not claim Part (iii) false without an unbounded family satisfying both

```text
D(n) <= x
log n is not x^o(1).
```

## Computation and completion policy

Inference is the main compute. Any exact job must test a named multiplier or
container claim, use the smallest distinguishing family, specify both
decision outcomes, and stop at the first obstruction. No generic census.

If the target lemma is proved, write a complete proof with explicit constants
and launch correctness, quantifier, and novelty audits before formalization.
If it is refuted, retain the smallest rigorous obstruction and state the
strongest multiplier bound that remains possible. If still blocked, return
one exact next lemma rather than a menu of ideas.
