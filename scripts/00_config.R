project_root <- rprojroot::find_root(rprojroot::has_file("DESCRIPTION"))
project_file <- function(...) file.path(project_root, ...)
data_dir <- project_file("data")
derived_dir <- file.path(data_dir, "derived")
table_dir <- project_file("tabs")
figure_dir <- project_file("figs")
prepared_data_file <- file.path(derived_dir, "prepared_data.rds")
benchmark_file <- file.path(data_dir, "benchmarks.csv")
figure_size <- c(width = 7, height = 7)
figure_dpi <- 180
estimator_labels <- c(
  raw = "Raw score change", standard = "Standard correction", lca = "Latent-class model"
)
estimator_colours <- c(raw = "grey50", standard = "#6BAED6", lca = "#08519C")
table_style <- list(
  digits = 3, bootstrap_options = c("striped", "hover", "condensed"),
  full_width = FALSE, position = "left"
)

theme_paper <- function() {
  ggplot2::theme_minimal(base_size = 11, base_family = "sans") +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      legend.position = "bottom", legend.title = ggplot2::element_blank()
    )
}

poll_manifest <- tibble::tibble(
  file = c(
    "aus", "btp04", "btp04GE", "btp05", "btp07", "bul", "ca", "cpl",
    "dk", "eu2007", "eu2009", "ire", "mi", "nic1", "sm", "swp",
    "ukbge", "ukcrime", "ukeu", "ukhealth", "ukmon", "vt", "wtu"
  ),
  poll = c(
    "Australia Constitutional Referendum", "BTP 2004 Primaries",
    "BTP 2004 General Election", "BTP 2005", "BTP 2007", "Bulgaria",
    "California Referendum", "CPL", "Denmark", "EU 2007", "EU 2009",
    "Northern Ireland", "Michigan", "NIC", "San Mateo", "SWEPCO",
    "UK BGE", "UK Crime", "UK EU", "UK Health", "UK Monarchy",
    "Vermont", "WTU"
  )
)

lucky_probabilities <- list(
  aus = c(.25, .25, .25, .50, .25, .50, .20, .20, .333, .333),
  btp04 = c(.25, .25, .25, .25, .33, .25, .33),
  btp04GE = c(.33, .25, .50, .50, .50, .25, .25, .25, .25),
  btp05 = c(.25, .33, .33, .20, .25, .25),
  btp07 = rep(.25, 8),
  bul = rep(.50, 7),
  ca = c(.33, .33, .25, .25, .25),
  cpl = c(.167, .333, .333, .333, .25, .143, .20),
  dk = c(.333, .333, .25, .25, .25, .25, .50, .50, .50),
  eu2007 = c(.25, .25, .25, .25, .25, .20, .20, .20, .25, .40, .40),
  eu2009 = rep(.25, 6),
  ire = c(.25, .20, .25, .25, .25, .333, .25),
  mi = c(.50, .50, .25, .25, .25, .571, .571, .571, .571),
  nic1 = c(.50, .50, .50, .50, .25, .25, .429, .429),
  sm = c(.20, .20, .20, .20, .20, .20, .25, .20),
  swp = c(.167, .333, .333, .333, .143),
  ukbge = c(.50, .50, .50, rep(3 / 7, 12)),
  ukcrime = rep(.50, 7),
  ukeu = rep(.50, 5),
  ukhealth = rep(.50, 6),
  ukmon = rep(.50, 8),
  vt = c(.20, .20, .25, .25, .25, .25, .20, .25, .25),
  wtu = c(.167, .333, .333, .333, .142)
)
