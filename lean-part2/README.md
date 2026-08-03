# Lean proof: Erdős 700(ii)

This is the independent end-to-end Lean project proving that infinitely many
composite $n$ satisfy $f(n)^2>n$. The repository records a complete proof but
makes no novelty or priority claim.

The reader-facing proof is
[`../part-ii-infinite-family.pdf`](../part-ii-infinite-family.pdf).

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
the full proof, rejects local placeholders and `sorryAx`, and checks the final
dependency set.

The final theorem is `Erdos700PNT.erdos_700_ii` in
[`Solution.lean`](Solution.lean), exposed by [`Verify.lean`](Verify.lean).

## Layout

- `StructuralWork/` — the three pair-omission arguments.
- `PNTWork/`, `DominanceWork/`, `PackingWork/` — unconditional prime packing.
- `Assembly.lean`, `Reduction.lean`, `Solution.lean` — final proof chain.
- `docs/` — human proof and statement audit.
- `scripts/verify.sh` — deterministic end-to-end gate.
- `lakefile.toml`, `lake-manifest.json`, `lean-toolchain` — pinned project.
