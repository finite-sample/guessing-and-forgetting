test_that("current reliability reproduces the paper", {
  reliability <- readr::read_csv(
    project_file("tabs", "reliability.csv"),
    show_col_types = FALSE
  )
  expect_equal(nrow(reliability), 23)
  expect_equal(mean(reliability$alpha_t1), .495, tolerance = .001)
  expect_equal(mean(reliability$alpha_t2), .561, tolerance = .001)
  expect_equal(sum(reliability$alpha_t2 > reliability$alpha_t1), 18)
})

test_that("item output is complete", {
  items <- readr::read_csv(
    project_file("tabs", "item_level.csv"),
    show_col_types = FALSE
  )
  expect_equal(nrow(items), 177)
  expect_true(all(items$lca_converged))
})

test_that("paper comparison distinguishes matching and changed quantities", {
  comparison <- readr::read_csv(
    project_file("tabs", "paper_comparison.csv"),
    show_col_types = FALSE
  )
  expect_equal(nrow(comparison), 13)
  expect_lt(
    abs(comparison$deposit_difference[comparison$metric == "Mean LCA learning"]),
    .001
  )
  expect_gt(
    abs(comparison$current_difference[comparison$metric == "Items fitting LCA"]),
    .05
  )
})
