# Changelog

## 0.2.1

All analysis code now lives in `scripts/`. Shared functions are collected in
`00_utils.R`, alongside `00_config.R` and the numbered execution stages. The
runner, tests, formatting commands, and README use the simpler layout.

## 0.2.0

Numbered preparation, estimation, figure, and table stages share configuration
in `scripts/00_config.R`. Reusable functions live in `R/`. Fixed paper/deposit
benchmarks live in `data/benchmarks.csv`; all generated estimates and tables
live in `tabs/`, and figures in `figs/`. Benchmark comparisons match metric
names, so changing row order cannot attach an estimate to the wrong benchmark.
The README is generated from `docs/README.in.md` and the current estimates.

## Current analysis

The maintained checkpoint replaces the deposited implementation instead of
keeping a second copy beside it. Relative to `dataverse-original`, it:

- uses the public `guess` 0.8.0 API at commit `3458ce8`;
- handles don't-know responses explicitly;
- retries the LCA estimator from three documented starting values;
- calculates reliability with `ltm::cronbach.alpha()`;
- uses tidyverse and `purrr` for data work;
- checks input contracts with `assertr`;
- writes tidy CSV output and `knitr`/`kableExtra` tables; and
- pins the R environment with `renv` and tests it locally and in CI.

The current data files retain the version-controlled deposited contents. Git
normalizes CSV line endings to LF, and `data/manifest.csv` records checksums of
those portable files.

## Numerical changes

| Quantity | Paper | Deposit | Current |
|---|---:|---:|---:|
| Mean T1 alpha | .495 | .4953 | .4952 |
| Mean T2 alpha | .561 | .5606 | .5607 |
| Polls with higher T2 alpha | 18 | 18 | 18 |
| Mean raw learning | .158 | .1579 | .1579 |
| Mean LCA learning | .210 | .2103 | .2102 |
| Mean standard-correction learning | .182 | .1824 | .1824 |
| Items where LCA learning exceeds raw | 78.5% | 80.8% | 80.2% |
| Items classified as fitting the LCA | 83.1% | 83.1% | 75.1% |

The last two rows are the material discrepancies. Gender-gap estimates retain
the paper's direction and magnitude after aligning its male-minus-female sign
convention. `tabs/paper_comparison.csv` is the authoritative comparison.
