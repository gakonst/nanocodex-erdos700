# Erdős 700(iii): repeated-prime-power partial-layer selection

## Exact objective

Let

```text
D_n(k) = n / gcd(n, binomial(n,k)),
L = log n,
E(n) = sum_{p^a || n} (a-1) log p.
```

Recover all non-event artifacts from the two retained Part-(iii) campaigns.
Never inspect an `events.jsonl`.

The full-component language is insufficient here: `n=72` shows that partial
prime-power layers can control the optimum. Uniform reflected averaging is
already proved too weak, and bounded-loss/no-reset recursion is refuted by
`n=30` and the family `p(p^2+1)`.

## Target lemma

For every real `A > 1`, prove that there are constants `C_A,N_A,c_A>0`
such that every composite `n >= N_A` satisfying

```text
p^a <= L^A for every exact component p^a || n,
E(n) >= C_A log L,
```

has an admissible `k` with

```text
log D_n(k) >= A log L - c_A.
```

Equivalently, using the checked carry identity,

```text
sum_{p | n}
  [min(v_p(n),v_p(k)) - H_p(n,k)]_+ log p
    >= A log log n - c_A.
```

The constants may depend on `A` only. This target removes the entire regime
with substantial repeated-prime-power mass, leaving a predominantly
squarefree kernel to the separate incidence campaign.

## Independent roles

1. **Exponent-shell architect.** Decompose the excess exponent mass into
   logarithmic shells and prove that one shell has enough selectable weight.
2. **Partial-layer probabilist.** Construct a distribution biased toward
   divisibility by selected powers and prove a rare-tail or factorial-moment
   lower bound. Audit covariance across bases.
3. **P-adic cylinder selector.** Treat preservation of each layer as an
   explicit residue-cylinder condition and seek a local lemma, entropy bound,
   or iterative selection theorem that permits resets.
4. **Adaptive-reset recursion specialist.** Design an amortized recursion
   where catastrophic resets are allowed but their total lost logarithmic
   weight is controlled globally.
5. **Powerful counterfamily constructor.** Seek a family with
   `E(n)/log log n -> infinity` but uniformly small `D(n)`. It must control
   every admissible `k`, not only full-component witnesses.
6. **Clean valuation referee.** Reconstruct the exact valuation formula,
   natural truncations, quantifiers, constants, and conversion to the target.

Use follow-ups on the strongest layer-selection lemma and an adversarial
attempt to construct a scalable counterfamily.

## Failure gates

- `n=72`: binary full-component reasoning is invalid.
- `n=30`: naive multiplicative witness repair loses a previous component.
- `n=p(p^2+1)`: any no-reset invariant with uniformly bounded loss is
  rejected.
- Uniform first moments cannot be recycled without a new tail argument.
- A finite example refutes only proposed constants. To refute the target,
  produce an unbounded family with `E(n)/log log n -> infinity` and failure
  for one fixed `A`.

Computation may falsify a named shell/cylinder formula only. If blocked,
return the exact cross-base partial-layer lemma still missing.
