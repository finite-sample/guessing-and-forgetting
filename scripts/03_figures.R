estimates <- read_tab("poll_level.csv") |>
  tidyr::pivot_longer(c(raw, standard, lca), names_to = "estimator", values_to = "learning") |>
  dplyr::mutate(
    poll = factor(poll, levels = rev(poll_manifest$poll)),
    estimator = factor(estimator, levels = names(estimator_labels))
  )
plot <- ggplot2::ggplot(estimates, ggplot2::aes(learning, poll, colour = estimator)) +
  ggplot2::geom_point(position = ggplot2::position_dodge(width = 0.5), size = 1.8) +
  ggplot2::scale_colour_manual(values = estimator_colours, labels = estimator_labels) +
  ggplot2::scale_x_continuous(labels = function(x) 100 * x) +
  ggplot2::labs(x = "Mean item-level learning (percentage points)", y = NULL) +
  theme_paper()
for (extension in c("pdf", "png")) {
  ggplot2::ggsave(
    file.path(figure_dir, paste0("learning.", extension)), plot,
    width = figure_size[["width"]], height = figure_size[["height"]], dpi = figure_dpi
  )
}
