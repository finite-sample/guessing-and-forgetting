test_that("benchmark comparison matches metrics even when rows are reordered", {
  benchmarks <- tibble::tibble(metric = c("second", "first"), paper = c(2, 1), deposit = c(2, 1))
  comparison <- compare_benchmarks(benchmarks, c(first = 1.1, second = 2.2))
  expect_equal(comparison$current_guess, c(2.2, 1.1))
  expect_equal(comparison$current_difference, c(0.2, 0.1))
  expect_error(compare_benchmarks(benchmarks, c(first = 1.1)))
  duplicates <- dplyr::bind_rows(benchmarks, benchmarks)
  expect_error(compare_benchmarks(duplicates, c(first = 1, second = 2)))
})
