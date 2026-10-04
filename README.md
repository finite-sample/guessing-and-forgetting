# Cor and Sood (2016) replication

This repository reanalyzes the item-level data for Cor and Sood's *Guessing
and Forgetting: A Latent Class Model for Measuring Learning* with the current
[`guess`](https://github.com/finite-sample/guess) package.

The Git history is the version boundary:

1. [`dataverse-original`](https://github.com/finite-sample/guessing-and-forgetting/tree/dataverse-original)
   is the unedited Harvard Dataverse deposit, with `data/` and `scripts/` at
   the repository root.
2. `main` replaces the deposited scripts at those paths with the maintained
   analysis. The current tree does not keep old and new implementations side
   by side.

The repository follows the same broad organization as the quota projects:

- `ms/main.pdf`: public author manuscript;
- `data/`: deposited inputs and checksum manifest;
- `R/`: shared analysis functions;
- `scripts/`: numbered pipeline stages;
- `output/`: machine-readable estimates;
- `tabs/`: rendered `knitr`/`kableExtra` tables;
- `evidence/`: paper and deposit benchmarks used for comparison;
- `docs/`: the detailed paper comparison.

The current code uses tidyverse verbs and `purrr`, validates data contracts
with `assertr`, and calculates alpha with `ltm::cronbach.alpha()`. Don't-know
responses are scored as incorrect for raw scores and as a separate observed
category in the latent-class model, matching the paper's convention.

## Run

```sh
Rscript -e 'renv::restore()'
make ci
```

The equivalent containerized check is:

```sh
make ci-docker
```

## Results

The central results hold. Across 23 polls, mean alpha rises from .495 at T1 to
.561 at T2, with an increase in 18 polls. Mean raw, LCA, and standard-corrected
learning are .158, .210, and .182.

Two item-level diagnostics differ. The paper reports that LCA learning exceeds
raw learning for 78.5% of items; the deposited workflow gives 80.8% and the
current package gives 80.2%. Acceptable LCA fit is 83.1% in the paper/deposit
and 75.1% with the current package. See
[`docs/paper-comparison.md`](docs/paper-comparison.md) and
[`output/paper_comparison.csv`](output/paper_comparison.csv).

## Provenance

The source is the Harvard Dataverse deposit
[doi:10.7910/DVN/HZHVCU](https://doi.org/10.7910/DVN/HZHVCU). Deposited material
is CC0 1.0; new code is MIT licensed. The maintained analysis pins `guess`
0.8.0 at commit `3458ce8`.

Cor, Ken and Gaurav Sood. 2016. “Guessing and Forgetting: A Latent Class Model
for Measuring Learning.” *Political Analysis* 24(2): 226–242.
[doi:10.1093/pan/mpw010](https://doi.org/10.1093/pan/mpw010).
