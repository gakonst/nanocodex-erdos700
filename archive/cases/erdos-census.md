# Erdős problem census

## Scope

The strict discovery window is 22 April through 22 July 2026. The principal
source is the community-maintained
[AI-contributions tracker](https://github.com/teorth/erdosproblems/wiki/AI-contributions-to-Erd%C5%91s-problems),
which stopped updating on 30 June. July additions were checked against current
problem pages, proof-claim pages, public repositories, and expert discussion.

The tracker itself is provisional. A green entry means the maintainers regarded
it as a full resolution or stronger solution; it is not equivalent to a
refereed publication. Literature novelty, statement correctness, and proof
correctness remain separate questions.

## Tracker-green results through 30 June

Twenty-eight unique problem IDs received a green full/stronger result in the
window. Problem #90 had independent OpenAI and Claude solutions but is counted
once.

### AI-led or standalone

`38, 90, 619, 694, 1014`

### AI building on a known partial result

`948, 1197`

### Significant human–AI collaboration

`42, 202, 283, 326, 330, 346, 351, 690, 696, 750, 863, 865, 888, 896, 953, 986, 1092, 1138, 1151, 1190`

### Stronger result after an earlier resolution

`1148`

For any ID `N`, the canonical source is `https://www.erdosproblems.com/N`.
Per-run web-search and tool metadata are usually absent from the tracker. Do not
infer “web off,” “one shot,” or “no tools” from that absence.

## July accepted additions

### #793: 2-primitive sets

GPT‑5.6 Sol Ultra, prompted by Przemek Chojecki, proved

\[
F(n)=\pi(n)+\left(\frac{27}{2}+o(1)\right)
\frac{n^{2/3}}{(\log n)^2}.
\]

The method is described as a short explicit refinement of Erdős's 1938
argument. It upgrades matching-order upper and lower bounds to an asymptotic
with exact leading constant. The [canonical page](https://www.erdosproblems.com/793)
is marked solved. The general web-search setting, transcript, and specialized
tool use have not been published.

### #119: products on the unit circle

GPT‑5.6 Pro and Samuel Korsky proved

\[
\sum_{k\le N}M_k \gg \frac{N^{5/4}}{\sqrt{\log N}},
\]

resolving the strongest question and implying infinitely many
\(M_n>n^{1/4-o(1)}\). The proof writes the logarithm of the product using
\(\log|2\sin \pi x|\), derives low-frequency exponential-sum control, applies
Fejér smoothing, converts prefix maxima into pair energy, and chooses
\(H\asymp\sqrt N/\log N\). The [proof claim](https://www.erdosproblems.com/forum/thread/119/proof-claims#proof-claim-119)
is explicitly accepted as correct. Web-search and computational-tool use were
not reported.

## Not counted as new discoveries

- Results outside the date window, even if their paper appeared inside it.
- Formalizations of previously known theorems.
- Benchmark items whose answers were already known to evaluators.
- Literature rediscoveries unless the model also produced a genuinely stronger
  result.
- White-circle candidate claims and yellow partial results.
- Numerical records unless the original problem asks for a construction or
  bound and the record itself is the research result.

## Current provisional cluster

The largest July cluster is Wang's claimed resolutions of #390, #486, #536,
#788, #1002, and #1038. They remain in [candidates](candidates.md) pending
problem-by-problem acceptance and novelty audits. Erdős #421 is another complete
claim whose canonical page remains open.

## Environment-data gap

The Erdős ecosystem is unusually good at recording outcome and mathematical
discussion but inconsistent about run metadata. A future submission template
should require:

- model, reasoning mode, effort, date, and run duration;
- exact prompt and all steering/follow-up messages;
- web search on/off/restricted and queries/results used;
- code execution, CAS, solver, proof assistant, and version information;
- one-shot, interactive, multi-agent, or autonomous-loop topology;
- generated source, stdout/stderr, certificates, and formal logs;
- human mathematical input after the initial problem statement;
- novelty-search procedure and independent reviewers.
