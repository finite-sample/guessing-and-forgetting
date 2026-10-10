verify_sources()
polls <- purrr::map(poll_manifest$file, read_poll)
benchmarks <- readr::read_csv(benchmark_file, show_col_types = FALSE)
saveRDS(list(polls = polls, benchmarks = benchmarks), prepared_data_file)
