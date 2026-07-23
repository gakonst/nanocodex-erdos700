# Repository instructions

This repository is both a source-backed knowledge base and an experimental
Nanocodex consumer for AI-assisted mathematics.

- Keep factual claims traceable to primary sources in `sources/` or the source
  links on a case card.
- Distinguish accepted results, executable certificates, formal proofs,
  literature rediscoveries, partial results, and unverified claims.
- Never upgrade a social-media proof claim to “solved” without recording the
  independent evidence that justifies the change.
- Store reusable prompt patterns as abstractions. Link to public full prompts
  and transcripts instead of copying large third-party documents.
- Treat Lean acceptance as proof of the encoded proposition, not automatic
  evidence that the proposition matches the intended theorem or is novel.
- Runtime experiments write only beneath `runs/`; retained research artifacts
  are not committed by default.
- Build against the dedicated adjacent `../nanocodex-latest` worktree. Refresh
  it explicitly from `origin/master` and preserve unrelated work in
  `../nanocodex`.
- Keep batch scheduling, budgets, deadlines, candidate freezing, verifiers, and
  novelty policy application-owned; lessons from `../nanocodex-rlm` are
  evidence, not an upstream scheduler requirement.
- The Rust harness is an application-level orchestrator. Do not add scheduling
  abstractions to Nanocodex core as part of work in this repository.
- Use the pinned Nix flake for campaign tools. Keep the default shell practical;
  put unusually large proof assistants and CAS distributions in named shells.
  Capture `math-env-report` output in retained campaign artifacts whenever a
  result depends on external compilers or solvers.
