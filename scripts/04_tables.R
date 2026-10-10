reliability <- read_tab("reliability.csv") |>
  dplyr::rename(Poll = poll, `T1 alpha` = alpha_t1, `T2 alpha` = alpha_t2)
poll_estimates <- read_tab("poll_level.csv") |>
  dplyr::rename(
    Poll = poll,
    Respondents = respondents,
    Items = items,
    Raw = raw,
    LCA = lca,
    Standard = standard,
    `Proportion fitting` = proportion_fit
  )
gender_gaps <- read_tab("gender_gaps.csv") |>
  dplyr::rename(
    Poll = poll,
    Estimator = estimator,
    `Knowledge gap` = knowledge_gap,
    `Learning gap` = learning_gap
  )
paper_comparison <- read_tab("paper_comparison.csv") |>
  dplyr::rename(
    Metric = metric,
    Paper = paper,
    Deposit = deposit,
    `Current guess` = current_guess,
    `Paper page` = paper_page
  ) |>
  dplyr::select(Metric, Paper, Deposit, `Current guess`, `Paper page`)

format_table(
  reliability,
  "T1 and T2 knowledge-index reliability by poll",
  "reliability.html"
)
format_table(
  poll_estimates,
  "Current guess estimates by poll",
  "poll_estimates.html"
)
format_table(
  gender_gaps,
  "Female-minus-male knowledge and learning gaps",
  "gender_gaps.html"
)
format_table(
  paper_comparison,
  "Paper, Dataverse deposit, and current guess estimates",
  "paper_comparison.html"
)

readme_comparison <- read_tab("paper_comparison.csv") |>
  dplyr::filter(metric %in% c(
    "Mean alpha, T1", "Mean alpha, T2", "Mean raw learning", "Mean LCA learning",
    "Mean standard-correction learning", "Items where LCA exceeds raw", "Items fitting LCA"
  )) |>
  dplyr::select(Measure = metric, Paper = paper, Deposit = deposit, Current = current_guess)
readme_table <- knitr::kable(readme_comparison, format = "pipe", digits = table_style$digits)
readme <- readLines(project_file("docs", "README.in.md"))
writeLines(
  unlist(lapply(readme, function(line) if (line == "{{RESULTS_TABLE}}") readme_table else line)),
  project_file("README.md")
)
