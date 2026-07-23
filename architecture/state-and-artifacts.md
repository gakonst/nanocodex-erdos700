# State and artifacts

## Campaign manifest

Each run should begin with a host-created manifest:

```json
{
  "campaign_id": "uuid",
  "problem_id": "stable source-derived id",
  "created_at": "RFC3339",
  "model": "current Nanocodex-supported model",
  "reasoning_mode": "pro",
  "thinking": "max",
  "web_policy": "novelty-only",
  "budget": {
    "wall_seconds": 28800,
    "max_children": 16,
    "max_model_calls": 200
  },
  "nanocodex_git_commit": "...",
  "nanocodex_source_sha256": "...",
  "verifier": {
    "executable": "/preapproved/checker",
    "sha256": "...",
    "timeout_seconds": 300
  },
  "target_fingerprint": "sha256:...",
  "status": "intake"
}
```

## Append-only event log

Record model turns, child lifecycle, steering, cancellations, tool calls,
verifier output, artifact hashes, and status transitions as ordered JSONL. The
human-readable ledger is derived from this log; it should not be the only
record.

## Candidate immutability

Freezing a candidate creates a content-addressed bundle containing:

- exact statement;
- proof or construction;
- dependency list;
- generated code and data;
- model and prompt lineage;
- hash of every artifact.

Auditors inspect the frozen bundle. Repairs create a new candidate version
rather than mutating the object under review.

## Branch semantics

- Clean `spawn` workers are independent with respect to conversation history,
  but may still share pretraining, immutable instructions, prompt cache, source
  corpus, and workspace. Record those common causes.
- `fork` workers intentionally inherit the latest safe context and are not
  independent evidence.
- `fork_from(TurnResult)` is useful for preserving a historical route before a
  later conjectural commitment contaminated the main branch.

## Publication bundle

The final export should include:

```text
manifest.json
problem.md
normalized-statement.json
prompt.md
turns.jsonl
ledger.md
candidate/
verification/
novelty/
sources.jsonl
environment.lock
report.md
artifacts.json
```

Public reports may redact credentials but should not omit mathematical prompts,
tool inputs/outputs, failed load-bearing lemmas, or evidence needed to reproduce
the result.
