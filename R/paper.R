read_tab <- function(name) readr::read_csv(file.path(table_dir, name), show_col_types = FALSE)

format_table <- function(data, caption, filename, digits = table_style$digits) {
  data |>
    knitr::kable(
      format = "html",
      caption = caption,
      digits = digits,
      escape = TRUE
    ) |>
    kableExtra::kable_styling(
      bootstrap_options = table_style$bootstrap_options,
      full_width = table_style$full_width,
      position = table_style$position
    ) |>
    kableExtra::save_kable(file.path(table_dir, filename), self_contained = TRUE)
}
