# Constructive exact Ramsey campaign: R(3,10)

Produce an explicit simple undirected graph on the labelled vertex set
`{0,...,39}` that is triangle-free and has no independent set of size ten.
Write the final witness as `candidate.json` with exactly this schema:

```json
{"n": 40, "edges": [[0, 1], [0, 2]]}
```

Every edge must be a two-element list `[u,v]` with `0 <= u < v < 40`;
edges must be unique. A host-owned verifier is frozen before discovery. Success
means that the lead freezes exactly one `candidate.json` and `verify_candidate`
accepts its frozen manifest. Model confidence, a heuristic independence-number
calculation, or a worker's private checker never counts as success.

The mathematical endpoint is a constructive lower bound `R(3,10) >= 41`.
Together with the published exact-computation upper bound `R(3,10) <= 41`, an
accepted witness establishes `R(3,10) = 41`. Treat the current interval and all
prior graph claims as source-sensitive: use web/literature search and record
sources, but keep discovery logically independent of any unverified artifact.

Use the available parallelism aggressively and diversify representations. In
particular, investigate structured circulant or block-circulant graphs,
extensions and mutations of known `(3,9)` and `(3,10)` Ramsey graphs, SAT/CP-SAT
encodings with symmetry breaking, triangle-free edge-switch local search, and
degree/neighborhood constraints. Search public graph databases and papers for
machine-readable seeds or construction methods, but provenance and license must
be recorded and every imported graph must pass the frozen host verifier.

Do not launch an unstructured exhaustive search over all 780 possible edges.
Exact jobs must be bounded, resumable, and artifact-producing. Each long search
must checkpoint a versioned state including its parameter shard, seed, best
score, graph, and a hash of the search program; it must read and validate that
state on restart and self-test restart before a long run. A useful failure must
return the exact searched family, objective, best graph, triangle count,
independence witness or certified alpha bound, and enough state for a follow-up.

Recommended division of labor:

1. A source-and-seed miner locates reproducible graph data and construction
   details, checking vertex numbering and graph complements carefully.
2. A structural theorist derives degree and common-neighborhood constraints and
   reduced parameterizations.
3. Independent search engineers implement genuinely different SAT and
   local-search/exact-search routes using the installed tools.
4. An adversarial auditor independently checks any promising graph and attacks
   the candidate format before it is frozen.

Continuously detect mathematical failure. A candidate with a triangle or an
independent ten-set is a failed candidate: retain the witness, update the route,
and continue. A stalled solver, exhausted shard, infeasible ansatz, broken
checkpoint, or heuristic score plateau is also route evidence, not campaign
success. Reallocate to the strongest live route and keep going until the host
verifier accepts or the caller-owned campaign budget expires.
