# Erdős Problem 700(i): boundary-antichain characterization

## Immutable target

Strengthen the already kernel-checked residue-carry equivalence into the
smallest structural all-factorization characterization currently justified.
Work entirely in the remote repository and its pinned Lean environment.

For composite `n > 1`, let `P(n)` be its largest prime factor and let
`W_n(k)` be the complementary residue-carry weight already defined in
`proof/PartIWork/ResidueCarry.lean`. Define the boundary antichain to consist
of the divisibility-minimal divisors of `n` that are numerically larger than
`P(n)`:

```text
Boundary(n) = {
  d : d | n, P(n) < d, and
  d / p <= P(n) for every prime p | d
}.
```

Define `Realized(n,d)` independently of `f`, gcds, and binomial coefficients:
there is a positive multiplier `m` with `d*m <= n/2` such that, for every
prime `p | d`,

```text
residueCarryCount n (d*m) p
  <= factorization(n,p) - factorization(d,p).
```

Prove and formalize the exact theorem

```text
f(n) = n / P(n)
  iff
no d in Boundary(n) is Realized.
```

The right-hand side may be adjusted to an extensionally equal Lean-friendly
definition, but it must remain a genuine boundary-antichain predicate and
must not quantify over all binomial coefficients, gcd values, or restate
`f(n) = n/P(n)`.

## Existing checked foundation

Read every file under `proof/PartIWork/` before opening a new route. In
particular, the remote build already checks:

- `residueCarryCount_eq_factorization_choose`;
- `residueCarryWeight_exact`;
- `largestPrime_gcd_choose`;
- `largestPrime_witness`;
- `f_eq_div_iff_residueCarrySafe_complete`.

Do not reprove or replace these results. Build the structural reduction on
top of them.

Also read:

- `proof/PartIWork/ADVERSARIAL_AUDIT.md`;
- `proof/PartIWork/STRUCTURAL_UPGRADE.md`;
- the completed reports in
  `runs/math-1784843263-47597/worker-reports/`.

Never inspect any `events.jsonl`.

## Required mathematical bridge

Prove, rather than assume, the following steps.

1. For admissible `k`, `W_n(k)` divides `k`.
2. `W_n(k) > P(n)` iff `W_n(k)` contains a divisibility-minimal divisor
   `d | n` above `P(n)`.
3. Such a minimal `d` lies in `Boundary(n)`.
4. For `k=d*m`, `d | W_n(k)` is equivalent to the displayed carry-layer
   inequalities at every prime dividing `d`.
5. Combine these with the checked residue-carry iff to prove both directions
   of the boundary theorem.

Repeated prime powers are mandatory. A squarefree-only or pairwise-only
result is partial.

## Regressions and adversarial audit

- `n=30` must satisfy the boundary predicate.
- `n=78`, `d=39`, `m=1` must violate it, recovering
  `gcd(78, choose(78,39))=2 < 78/13`.
- Include a repeated-prime-power example.
- Audit positivity, truncated subtraction, divisibility orientation,
  `1 < k`, and `k <= n/2`.
- Search for the first counterexample to every simplified intermediate
  statement before promoting it.

## Lean and environment

Use:

```text
nix --extra-experimental-features "nix-command flakes" develop .#lr
```

The flake now supplies `elan`; `proof/lean-toolchain` pins Lean 4.27. Do not
replace it with nixpkgs' unpinned `lean4`.

Add the main formalization as:

```text
proof/PartIWork/BoundaryAntichain.lean
```

and import it from `proof/PartIWork.lean`.

The final build must be:

```text
cd proof
lake build PartIWork
```

No `sorry`, `admit`, new axioms, or
`Erdos700.erdos_700.parts.i`. Record `#print axioms` for every promoted final
theorem.

## Completion artifacts

Produce:

- `proof/PartIWork/BoundaryAntichain.lean`;
- `proof/PartIWork/boundary-antichain.md`, with complete prose proof;
- `proof/PartIWork/boundary-audit.md`;
- a successful retained build log and axiom log;
- a precise assessment of whether this is sufficiently structural to answer
  the historical “characterise” request, clearly separated from the formal
  equivalence itself.

If blocked, return the smallest exact missing Lean lemma and a compiling
formalization of every preceding bridge.
