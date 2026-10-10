# Paper comparison

The public author manuscript is at [`ms/main.pdf`](../ms/main.pdf). Its MD5 is
`3e80da54bdfaba3d5c7f9fa3a4303b4a`; the source was
<https://gsood.com/research/papers/guess.pdf>.

`scripts/02_estimate.R` combines values transcribed from pages 16--24,
the results produced by the deposited workflow, and the maintained analysis.
The transcribed paper and deposit values live in `data/benchmarks.csv`.
The complete generated comparison is `tabs/paper_comparison.csv`, with an
HTML rendering in `tabs/paper_comparison.html`.

The paper's mean T1/T2 alpha values (.495/.561), 18 of 23 increases, and mean
raw/LCA/standard learning (.158/.210/.182) reproduce after rounding. The
gender-gap results also reproduce after using the paper's male-minus-female
sign convention.

Two quantities differ:

- The paper says LCA learning exceeds raw learning for 78.5% of items. The
  deposited code produces 80.8%; current `guess` produces 80.2%.
- The paper/deposit reports acceptable LCA fit for 83.1% of items. Current
  `guess`, using its present goodness-of-fit implementation and optimizer,
  gives 75.1%. This changes the fit diagnostic, not mean learning.

The abstract's roughly 13% aggregate adjustment and page 18's nearly 30%
item-level comparison are different aggregations and should not be treated as
the same estimand.
