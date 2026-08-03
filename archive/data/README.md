# Data

`cases.jsonl` is the normalized case catalog. Each non-empty line validates
independently against `case.schema.json`.

The execution environment is deliberately explicit. `not-reported` means the
public record is insufficient; it must not be normalized to `disabled`.
Likewise, `proof_assistant: null` means no proof assistant is documented for
the result, not that no later formalization can exist.

When updating a case:

1. update the relevant narrative card;
2. update the JSONL object;
3. add or update primary sources;
4. record why any status/evidence/novelty field changed;
5. validate every JSONL line and all internal links.
