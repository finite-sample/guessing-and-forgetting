repository_root <- rprojroot::find_root(rprojroot::has_file("DESCRIPTION"))
source(file.path(repository_root, "scripts", "00_config.R"))
source(project_file("scripts", "00_utils.R"))
