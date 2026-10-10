# Guessing and Forgetting: A Latent Class Model for Measuring Learning

Ken Cor and Gaurav Sood

[Paper](ms/main.pdf) · [Paper comparison](docs/paper-comparison.md) · [Data deposit](https://doi.org/10.7910/DVN/HZHVCU)

## Question and motivation

How much do people learn when a correct answer can come from guessing, and a
later wrong answer can reflect forgetting? Changes in test scores mix changes
in knowledge with changes in how people answer. That makes the correction
important for studies of political learning and for comparisons between groups.

This repository reproduces Cor and Sood's
[2016 Political Analysis paper](https://doi.org/10.1093/pan/mpw010) with the
maintained [`guess`](https://github.com/finite-sample/guess) package. The model
uses before-and-after responses to distinguish knowledge, guessing, and
“don't know” states, allowing both learning and forgetting.

## Data and research design

The public replication data contain 177 knowledge items across 23 Deliberative
Polls. Each poll supplies paired responses before and after deliberation. The
analysis compares raw score changes, a standard correction using each item's
chance of a lucky guess, and estimates from a latent-class model. These are
measurement comparisons within the participating samples; the before-and-after
design alone does not identify a causal effect of deliberation.

Don't-know responses count as incorrect in raw scores and form a separate
observed category in the latent-class model. The analysis also compares
knowledge-index reliability and gender gaps. It pins `guess` 0.8.0 at commit
`3458ce8`; the data manifest verifies the deposited files before estimation.

## Key findings

The mean learning and reliability estimates reproduce the paper after rounding.
The current item-level mean learning estimate is about 21 percentage points
with the latent-class model, compared with 16 points for raw score changes.
Reliability rises in 18 of the 23 polls. Two diagnostics differ: the share of
items for which model-based learning exceeds raw learning, and the share that
passes the model's goodness-of-fit test.

{{RESULTS_TABLE}}

Learning and item shares are reported as proportions; multiply by 100 for
percentage points of learning or percent of items. Alpha is a reliability
coefficient. Learning means in this table weight each of the 177 items equally.
The table describes estimates and diagnostic shares, without uncertainty
intervals. The [full comparison](tabs/paper_comparison.csv) identifies the
manuscript page for each benchmark and reports gender gaps using the paper's
male-minus-female convention. Poll-specific estimates are in
[tabs/poll_level.csv](tabs/poll_level.csv) and [figs/learning.png](figs/learning.png).

## Reproduce

Use R 4.6 and Pandoc. From the repository root:

```sh
make restore
make check
```

`make restore` installs the versions in `renv.lock`. `make check` lints the code,
rebuilds all estimates, figures, HTML tables and this README, and runs the tests.
`make analysis` rebuilds those outputs without running the checks. `make ci`
is an alias for `make check`. With Docker installed, `make ci-docker` runs the
same checks in `rocker/verse:4.6.0`.

`ms/main.pdf` is the published author manuscript supplied for comparison. The
pipeline does not rebuild it because its source is not part of this repository.
Edit `docs/README.in.md` to change this README; stage 04 supplies the result table.

## Files and pipeline

`R/` contains reusable functions. `scripts/` contains configuration and numbered
execution stages. `scripts/99_run_all.R` loads the helpers, then runs stages
01–04 in order, each in its own environment.

| File or directory | Purpose |
|---|---|
| `data/*.csv`, `data/manifest.csv` | Deposited inputs and their checksums |
| `data/benchmarks.csv` | Fixed values from the paper and deposited workflow, with manuscript page references |
| `data/derived/prepared_data.rds` | Generated, ignored prepared polls and benchmarks |
| `scripts/00_config.R` | Paths, poll labels, guessing probabilities, plot theme, colours, dimensions, and table defaults |
| `scripts/01_prepare_data.R` | Verify and read inputs, then save prepared data |
| `scripts/02_estimate.R` | Estimate learning, reliability, and gender gaps; compare results with benchmarks |
| `scripts/03_figures.R` | Write the poll-level learning figure |
| `scripts/04_tables.R` | Write HTML tables and this README from the estimates |
| `scripts/99_run_all.R` | Run the complete pipeline |
| `R/sources.R`, `R/analysis.R`, `R/paper.R` | Input contracts, estimators, and output writers |
| `tabs/` | Generated CSV estimates and HTML tables; `gender_gaps.csv` uses female-minus-male gaps |
| `figs/` | Generated PDF and PNG figures |
| `tests/testthat/` | Input, benchmark-matching, numerical reproduction, and lint checks |
| `docs/paper-comparison.md` | Explanation of agreements and discrepancies with the paper |

## Provenance

The [Harvard Dataverse deposit](https://doi.org/10.7910/DVN/HZHVCU) is preserved
in the [`dataverse-original` tag](https://github.com/finite-sample/know_guess_forget/tree/dataverse-original).
The main branch contains the maintained analysis; it does not keep a duplicate
historical implementation. Deposited material is CC0 1.0; new code is MIT licensed.

Cor, Ken and Gaurav Sood. 2016. “Guessing and Forgetting: A Latent Class Model
for Measuring Learning.” *Political Analysis* 24(2): 226–242.
[doi:10.1093/pan/mpw010](https://doi.org/10.1093/pan/mpw010).
