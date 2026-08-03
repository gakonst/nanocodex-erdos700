# Lean proof: Erdős 700(i)

This is the independent end-to-end Lean project for the complete Part (i)
solution. It proves both the maintained largest-prime theorem and the literal
1978 greatest-prime-power theorem, including the compact synchronized
integer/Boolean compiler.

The reader-facing proof is
[`../part-i-complete-solution.pdf`](../part-i-complete-solution.pdf).

## Verify

With Lean/Elan available:

```bash
./scripts/verify.sh
```

Or enter the pinned Nix shell first:

```bash
nix develop
./scripts/verify.sh
```

The verifier updates pinned dependencies, downloads the Mathlib cache, builds
the full `PartIWork` library, rejects proof placeholders and `sorryAx`, audits
the promoted theorem dependency sets, and checks all composite integers
through $n=1000$ independently.

The public formal surface is [`PartIVerify.lean`](PartIVerify.lean). The final
compiler theorem is
`Erdos700PartI.ExplicitG.explicitG_iff_factorTableauFeasible`.

## Layout

- `PartIWork/` — complete proof modules and close mathematical notes.
- `PartIWork.lean` — library root.
- `PartIVerify.lean` — theorem and axiom audit surface.
- `scripts/verify.sh` — deterministic end-to-end gate.
- `lakefile.toml`, `lake-manifest.json`, `lean-toolchain` — pinned project.
