verify_sources <- function() {
  manifest <- readr::read_csv(
    project_file("data", "manifest.csv"),
    show_col_types = FALSE
  )
  hashes <- manifest |>
    dplyr::mutate(
      observed_md5 = unname(tools::md5sum(project_file(manifest$path)))
    )
  assertr::verify(
    hashes,
    all(hashes$md5 == hashes$observed_md5),
    error_fun = assertr::error_stop
  )
  invisible(TRUE)
}

read_poll <- function(file) {
  data <- readr::read_csv(
    project_file("data", paste0(file, ".csv")),
    show_col_types = FALSE
  )
  data |>
    assertr::verify(names(data)[[ncol(data)]] == "female") |>
    assertr::verify((ncol(data) - 1L) %% 2L == 0L)
  n_items <- (ncol(data) - 1L) / 2L
  item_names <- paste0("item", seq_len(n_items))
  pre <- data |>
    dplyr::select(dplyr::all_of(seq_len(n_items))) |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.integer))
  post <- data |>
    dplyr::select(dplyr::all_of(n_items + seq_len(n_items))) |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.integer))
  names(pre) <- names(post) <- item_names
  valid_binary <- function(value) is.na(value) | value %in% c(0L, 1L)
  pre |> assertr::assert(valid_binary, dplyr::everything())
  post |> assertr::assert(valid_binary, dplyr::everything())
  list(data = data, pre = pre, post = post, female = data$female)
}
