# Repository instructions

This repository has a small public proof surface and a retained experimental
Nanocodex archive for AI-assisted mathematics.

- Keep factual claims traceable to primary sources in `archive/sources/` or the source
  links on a case card.
- Distinguish accepted results, executable certificates, formal proofs,
  literature rediscoveries, partial results, and unverified claims.
- Never upgrade a social-media proof claim to “solved” without recording the
  independent evidence that justifies the change.
- Store reusable prompt patterns as abstractions. Link to public full prompts
  and transcripts instead of copying large third-party documents.
- Treat Lean acceptance as proof of the encoded proposition, not automatic
  evidence that the proposition matches the intended theorem or is novel.
- Runtime experiments write only beneath `archive/runs/`; retained research artifacts
  are not committed by default.
- Build against the dedicated adjacent `../nanocodex-latest` worktree. Refresh
  it explicitly from `origin/master` and preserve unrelated work in
  `../nanocodex`.
- Keep batch scheduling, budgets, deadlines, candidate freezing, verifiers, and
  novelty policy application-owned; lessons from `../nanocodex-rlm` are
  evidence, not an upstream scheduler requirement.
- The Rust harness under `archive/` is an application-level orchestrator. Do not add scheduling
  abstractions to Nanocodex core as part of work in this repository.
- Keep `lean-part1/` and `lean-part2/` independently reproducible with their
  own Lake manifests, toolchains, Nix shells, and verification scripts.
- Do not place partial Part (iii) work in `lean-part3/` without labeling its
  exact status; that directory must not imply a complete proof while Part (iii)
  remains open.
- Keep the repository root limited to the reader-facing README, PDFs, Lean
  packages, map, archive, and standard repository metadata.
- Use the pinned Nix flake under `archive/` for campaign tools. Keep the default shell practical;
  put unusually large proof assistants and CAS distributions in named shells.
  Capture `math-env-report` output in retained campaign artifacts whenever a
  result depends on external compilers or solvers.
