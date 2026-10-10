prepared <- readRDS(prepared_data_file)
results <- purrr::pmap(
  list(prepared$polls, poll_manifest$file, poll_manifest$poll), analyze_poll
)

write_result <- function(component, filename) {
  results |>
    purrr::map(component) |>
    purrr::list_rbind() |>
    readr::write_csv(file.path(table_dir, filename))
}

write_result("item", "item_level.csv")
write_result("poll", "poll_level.csv")
write_result("gender", "gender_gaps.csv")
write_result("reliability", "reliability.csv")

modern_items <- read_tab("item_level.csv")
modern_reliability <- read_tab("reliability.csv")
modern_gaps <- read_tab("gender_gaps.csv")
modern_gender <- modern_gaps |>
  dplyr::group_by(estimator) |>
  dplyr::summarise(
    knowledge_gap = -mean(knowledge_gap),
    learning_gap = -mean(learning_gap),
    .groups = "drop"
  )

raw_gender <- dplyr::filter(modern_gender, estimator == "raw")
lca_gender <- dplyr::filter(modern_gender, estimator == "lca")

current <- c(
  "Mean alpha, T1" = mean(modern_reliability$alpha_t1),
  "Mean alpha, T2" = mean(modern_reliability$alpha_t2),
  "Polls with alpha increase" = sum(modern_reliability$alpha_t2 > modern_reliability$alpha_t1),
  "Mean raw learning" = mean(modern_items$raw),
  "Mean LCA learning" = mean(modern_items$lca),
  "Mean standard-correction learning" = mean(modern_items$standard),
  "Items where LCA exceeds raw" = mean(modern_items$lca > modern_items$raw),
  "Items where standard correction exceeds raw" = mean(modern_items$standard > modern_items$raw),
  "Items fitting LCA" = mean(modern_items$gof_p_value >= .05),
  "Male-minus-female T1 raw knowledge gap" = raw_gender$knowledge_gap,
  "Male-minus-female T1 LCA knowledge gap" = lca_gender$knowledge_gap,
  "Male-minus-female raw learning gap" = raw_gender$learning_gap,
  "Male-minus-female LCA learning gap" = lca_gender$learning_gap
)

comparison <- compare_benchmarks(prepared$benchmarks, current)
readr::write_csv(comparison, file.path(table_dir, "paper_comparison.csv"))
