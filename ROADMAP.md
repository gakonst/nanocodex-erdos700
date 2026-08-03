# Roadmap

The repository has two completed formal developments and one open research
frontier. Work should strengthen those evidence packages rather than expand
the repository into a generic agent platform.

## 1. External review of Part (ii)

- obtain independent review of the natural-language proof;
- obtain an independent Lean build and statement-alignment check;
- complete the novelty and citation-neighborhood audit;
- submit the result to the Erdős Problems maintainers or an appropriate
  mathematical venue;
- record external feedback separately from kernel status.

Gate: reviewers agree that the exact strict infinitude statement is proved and
the repository records the external disposition.

## 2. External review of Part (i)

- review the `BoundarySafe` iff theorem and explicit factor-tableau compiler;
- decide whether the historical word “characterise” accepts an exact finite
  carry/factorization predicate or demands a closed factorization taxonomy;
- if necessary, isolate the smallest remaining structural refinement;
- publish worked strata and regression examples independently of the general
  compiler.

Gate: the claim boundary is accepted by reviewers or narrowed to one explicit
remaining classification theorem.

## 3. Part (iii): cross the first quantitative barrier

The current measurable target is not another equivalent bridge. It is one of:

1. prove
   \[
   D(n)\ge c\log n\,L(\log n)
   \]
   uniformly for an explicit \(L(x)\to\infty\);
2. prove the uniform fixed \(A=2\) case;
3. construct an infinite counterfamily to one of those statements.

Priority global representations:

- the sublevel extremal function \(H(x)\);
- an all-divisor product/max identity for literal rows;
- weighted partial-layer selection with an instance-adaptive multiplier.

Every new route must name the failure certificates in
`docs/part-iii-exploration-map.md` that it escapes.

Gate: an unconditional theorem improves the \(A=1\) bound, or a rigorous
counterfamily changes the mathematical frontier.

## 4. Proof-package maintenance

- keep the Lean and Rust CI green against pinned dependencies;
- retain explicit axiom, placeholder, and statement audits;
- keep runtime artifacts ignored and promote only audited conclusions;
- maintain a compact canonical status page;
- preserve source and model/tool provenance for every public claim.

Gate: a fresh checkout can reproduce both completed proof developments and
understand the Part (iii) frontier without reading terminal transcripts.

## 5. Harness development

Only implement harness changes required by a concrete campaign:

- migrate the application from the pre-`0.3.0` Nanocodex tool/event/builder
  API and restore `cargo test --all-targets` against `../nanocodex-latest`;
- typed route state and explicit progress gates;
- compact evidence retrieval rather than transcript replay;
- reliable continuation of long Pro/Max reasoning;
- host-owned scheduling, cancellation, and artifact limits;
- verifier-first candidate promotion.

Do not add a generic scheduler or provider abstraction to Nanocodex core from
this repository.

Gate: the harness makes false progress harder to report and useful partial
results easier to retain.

## 6. Broader AI-for-science corpus

The case catalog, prompt patterns, and method taxonomy remain useful secondary
assets. Update them when new source-backed cases materially change the
methodology. Keep the repository front door focused on Erdős 700.
