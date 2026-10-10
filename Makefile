.PHONY: restore analysis test lint format check ci ci-docker

restore:
	Rscript --vanilla -e 'if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv", repos = "https://cloud.r-project.org"); renv::load(project = getwd()); renv::restore(prompt = FALSE)'

analysis:
	Rscript scripts/99_run_all.R

test: analysis
	Rscript -e 'testthat::test_dir("tests/testthat", stop_on_failure = TRUE)'

lint:
	Rscript -e 'l <- unlist(lapply(c("R", "scripts", "tests"), lintr::lint_dir), recursive = FALSE); print(l); quit(status = as.integer(length(l) > 0))'

format:
	Rscript -e 'for (p in c("R", "scripts", "tests")) styler::style_dir(p)'

check: lint test

ci: check

ci-docker:
	docker run --rm -v "$(CURDIR):/project" -w /project \
		-v r_renv_cache:/root/.cache/R/renv \
		-e RENV_CONFIG_REPOS_OVERRIDE=https://packagemanager.posit.co/cran/latest \
		rocker/verse:4.6.0 bash -c "make restore check"
