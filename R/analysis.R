fit_item_model <- function(pre, post) {
  starts <- list(
    NULL,
    c(gg = .2, gk = .2, gd = .1, kk = .1, dg = .1, dk = .1, dd = .2, gamma = .2),
    c(gg = .3, gk = .1, gd = .1, kk = .1, dg = .1, dk = .1, dd = .2, gamma = .25)
  )
  attempt <- function(start) {
    tryCatch(
      guess::fit_item_lca(pre, post, na_as = "dk", start = start),
      error = function(error) NULL
    )
  }
  fit <- starts |>
    purrr::map(attempt) |>
    purrr::compact() |>
    purrr::pluck(1, .default = NULL)
  if (is.null(fit)) {
    stop("The current guess estimator failed for every documented starting value.")
  }
  fit
}

score_people <- function(pre, post, guessing_probability) {
  adjusted <- guess::group_adj(
    pre,
    post,
    guessing_probability,
    knowledge_given_dont_know = 0,
    na_as = "dk"
  )$adjusted_responses
  raw_pre <- rowMeans(replace(pre, is.na(pre), 0))
  raw_post <- rowMeans(replace(post, is.na(post), 0))
  tibble::tibble(
    knowledge = raw_pre,
    learning = raw_post - raw_pre,
    adjusted_knowledge = rowMeans(adjusted$pre_test),
    adjusted_learning = rowMeans(adjusted$post_test - adjusted$pre_test)
  )
}

gender_gap <- function(score, female) {
  gender_data <- tibble::tibble(score = score, female = female)
  gender_data <- dplyr::filter(gender_data, !is.na(gender_data$female))
  stats::coef(stats::lm(score ~ female, data = gender_data))[[2L]]
}

analyze_poll <- function(poll_data, file, poll) {
  message("Modern poll: ", file)
  lucky <- lucky_probabilities[[file]]
  tibble::tibble(items = ncol(poll_data$pre), lucky = length(lucky)) |>
    assertr::verify(items == lucky)

  fit <- fit_item_model(poll_data$pre, poll_data$post)
  standard <- guess::stnd_cor(
    poll_data$pre,
    poll_data$post,
    lucky,
    na_as = "dk"
  )$learn
  raw <- poll_data$post |>
    dplyr::mutate(dplyr::across(dplyr::everything(), ~ tidyr::replace_na(.x, 0L))) |>
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(),
        ~ .x - tidyr::replace_na(poll_data$pre[[dplyr::cur_column()]], 0L)
      )
    ) |>
    colMeans()
  gof <- guess::assess_item_lca_fit(
    fit,
    poll_data$pre,
    poll_data$post,
    na_as = "dk"
  )$statistics

  item_results <- tibble::tibble(
    poll = poll,
    item = names(raw),
    raw = unname(raw),
    lca = unname(fit$learning),
    standard = unname(standard),
    lca_converged = fit$diagnostics$convergence == 0,
    gof_p_value = gof$p_value
  )
  poll_results <- tibble::tibble(
    poll = poll,
    respondents = nrow(poll_data$pre),
    items = ncol(poll_data$pre),
    raw = mean(raw),
    lca = mean(fit$learning),
    standard = mean(standard),
    proportion_fit = mean(gof$p_value >= .05)
  )
  pre_scored <- poll_data$pre |>
    dplyr::mutate(dplyr::across(dplyr::everything(), ~ tidyr::replace_na(.x, 0L)))
  post_scored <- poll_data$post |>
    dplyr::mutate(dplyr::across(dplyr::everything(), ~ tidyr::replace_na(.x, 0L)))
  reliability_results <- tibble::tibble(
    poll = poll,
    alpha_t1 = ltm::cronbach.alpha(pre_scored)$alpha,
    alpha_t2 = ltm::cronbach.alpha(post_scored)$alpha
  )

  raw_people <- score_people(poll_data$pre, poll_data$post, lucky)
  lca_people <- score_people(
    poll_data$pre,
    poll_data$post,
    unname(fit$params["gamma", ])
  )
  gender_results <- tibble::tibble(
    poll = poll,
    estimator = c("raw", "standard", "lca"),
    knowledge_gap = c(
      gender_gap(raw_people$knowledge, poll_data$female),
      gender_gap(raw_people$adjusted_knowledge, poll_data$female),
      gender_gap(lca_people$adjusted_knowledge, poll_data$female)
    ),
    learning_gap = c(
      gender_gap(raw_people$learning, poll_data$female),
      gender_gap(raw_people$adjusted_learning, poll_data$female),
      gender_gap(lca_people$adjusted_learning, poll_data$female)
    )
  )

  list(
    item = item_results,
    poll = poll_results,
    gender = gender_results,
    reliability = reliability_results
  )
}


compare_benchmarks <- function(benchmarks, current) {
  stopifnot(!anyDuplicated(benchmarks$metric), setequal(benchmarks$metric, names(current)))
  benchmarks |>
    dplyr::mutate(
      current_guess = unname(current[metric]),
      deposit_difference = deposit - paper,
      current_difference = current_guess - paper
    ) |>
    assertr::verify(!is.na(deposit)) |>
    assertr::verify(!is.na(current_guess))
}
