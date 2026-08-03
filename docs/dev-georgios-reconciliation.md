# `dev-georgios` recovery and reconciliation

Date: 2026-08-03

This records the recovery sweep requested after the original work had been
performed on `ubuntu@dev-georgios` but not consistently committed. It makes
the boundary between promoted research, retained raw provenance, and separate
upstream runtime work explicit.

## Recovered host state

The primary remote checkout was
`/home/ubuntu/campaigns/erdos700-research/nanocodex-erdos700`. It contained
105 top-level run directories and roughly 39 GB of run data. The Git branch
had no unpushed commits; the valuable missing work lived mainly in ignored
`runs/` directories and in a dirty working tree.

The source-tree comparison showed that almost every durable harness,
documentation, and orchestration change had already reached this repository
or had been superseded by a stronger local version. In particular, the local
artifact reader and campaign lessons are newer than their remote copies.
Remote Cargo changes that pointed at a campaign-specific Nanocodex checkout
were deliberately not copied because this project is required to build
against the adjacent `../nanocodex-latest` worktree.

## Material promoted into this repository

- The complete modern and historical Part (i) release, including seven exact
  finite formulations and the explicit integer/Boolean compiler.
- Two independent historical proofs found only in the dedicated Ubuntu run:
  gcd/carry-weight order duality and the finite carry maximum.
- Compact proof narratives, source/statement/referee/dependency/adversarial
  audits, verification records, novelty searches, and regression
  certificates.
- A complete [Part (i) run audit](part-i-run-coverage-audit.md).
- The reconciled 105-run [Part (iii) audit](part-iii-run-coverage-audit.md),
  69-entry no-retry ledger, and detailed exploration map.
- A compact Part (iii) diagnostic certificate formerly present only as
  `route3-verification/results.json`.

Part (ii)'s final PNT proof was already canonical locally. The one interleaved
Ubuntu Part (ii) run was only a release prompt with no returned result.

## Deliberately not copied into Git

- Raw `events.jsonl` and `trace.jsonl` streams.
- Session snapshots, telemetry, exact-job envelopes, credentials, and campaign
  controller state.
- Lean build products, Nix/Cargo caches, downloaded duplicate papers, PDFs,
  tar archives, and frozen duplicate source trees.
- Generated sync staging, logs, and loops.

These exclusions avoid turning the repository into a transcript/cache dump.
They do not omit a distinct terminal mathematical claim: compact reports,
unique source, and exact certificates were inspected and either promoted or
mapped to a canonical local result.

## Separate Nanocodex runtime work

The host also has dirty changes in
`/home/ubuntu/campaigns/erdos700-research/nanocodex-erdos-runtime` (11 files,
329 insertions and 45 deletions at reconciliation time), with overlapping
edits in `nanocodex-latest`. They concern:

- disabling the event-idle timeout for Pro reasoning;
- retaining paired call IDs so late custom notifications can replay;
- zero-timeout receive behavior in native and WASM hosts;
- associated service/context tests.

Those are upstream Nanocodex changes, not Erdős 700 application changes. The
11 remote file contents were preserved byte-for-byte in the isolated local
worktree `../nanocodex-dev-georgios-recovery`, on branch
`recovery/dev-georgios-runtime` at the remote base commit
`11308a9d02ffb9a40c4b3ba1a561e053ca0ca6c5`. They are staged but uncommitted,
intentionally not mixed into this repository, and still require their own
upstream review and test/commit decision.

Recovery verification passed `cargo fmt --all -- --check`,
`cargo test -p nanocodex-service -p nanocodex` (105 Rust tests passed, one
proxy child ignored), and the complete generated-WASM JavaScript package test,
typecheck, and package audit (11 tests passed).

## Canonical navigation

- Current claims: [status](status.md)
- All three problems and lessons: [research map](research-map.md)
- Complete Part (i) release: [release record](part-i-release/README.md)
- Open Part (iii) frontier: [bottleneck brief](erdos700-iii-bottleneck-brief.md)
- Every persisted Part (iii) run: [run coverage audit](part-iii-run-coverage-audit.md)
