repository_root <- rprojroot::find_root(rprojroot::has_file("DESCRIPTION"))
source(file.path(repository_root, "scripts", "00_config.R"))
for (module in c("sources.R", "analysis.R", "paper.R")) {
  source(project_file("R", module))
}
