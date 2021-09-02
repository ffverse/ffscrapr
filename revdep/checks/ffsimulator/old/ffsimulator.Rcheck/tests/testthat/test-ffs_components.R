
cache <- tibble::tibble(file = list.files(system.file("cache",package = "ffsimulator"), full.names = TRUE)) %>%
  dplyr::transmute(
    data = purrr::map(.data$file, readRDS),
    name = stringr::str_remove_all(.data$file, ".+cache/|\\.rds$")
  ) %>%
  dplyr::select("name", "data") %>%
  tibble::deframe()

test_that("ffs_adp_outcomes() works for both the simple and none injury models", {
  adp_outcomes <- ffs_adp_outcomes(
    scoring_history = cache$mfl_scoring_history,
    injury_model = "simple"
  )

  adp_outcomes_noinjury <- ffs_adp_outcomes(
    scoring_history = cache$espn_scoring_history,
    injury_model = "none"
  )

  checkmate::expect_tibble(adp_outcomes, min.rows = 500)
  checkmate::expect_tibble(adp_outcomes_noinjury, min.rows = 500)

  checkmate::expect_subset(
    names(adp_outcomes),
    c("pos", "rank", "prob_gp", "week_outcomes", "player_name", "fantasypros_id")
  )
  checkmate::expect_subset(
    names(adp_outcomes_noinjury),
    c("pos", "rank", "prob_gp", "week_outcomes", "player_name", "fantasypros_id")
  )
})


test_that("ffs_generate_projections() returns a tibble and specific columns", {
  projected_scores <- ffs_generate_projections(
    adp_outcomes = cache$adp_outcomes,
    latest_rankings = cache$latest_rankings,
    n_seasons = 2,
    n_weeks = 10,
    rosters = cache$mfl_rosters
  )

  checkmate::expect_tibble(projected_scores, min.rows = 7000)

  checkmate::expect_subset(
    c("fantasypros_id", "pos", "projected_score", "season", "week"),
    names(projected_scores)
  )
})

test_that("ffs_score_rosters() connects the scores to the rosters", {
  roster_scores <- ffs_score_rosters(
    projected_scores = cache$projected_scores,
    rosters = cache$mfl_rosters
  )

  checkmate::expect_tibble(roster_scores, min.rows = 7000)

  checkmate::expect_subset(
    c(
      "fantasypros_id", "pos", "projected_score", "season", "week",
      "franchise_id", "pos_rank"
    ),
    names(roster_scores)
  )
})


test_that("ffs_optimize_lineups() returns a tibble and specific columns", {
  future::plan("sequential")

  optimal_scores <- ffs_optimize_lineups(
    roster_scores = cache$roster_scores,
    lineup_constraints = cache$mfl_lineup_constraints,
    best_ball = FALSE,
    parallel = FALSE
  )

  expect_message({
    optimal_scores_parallel_bestball <- ffs_optimize_lineups(
      roster_scores = cache$roster_scores,
      lineup_constraints = cache$mfl_lineup_constraints,
      best_ball = TRUE,
      parallel = TRUE
    )
  })

  checkmate::expect_tibble(optimal_scores, nrows = 240)
  checkmate::expect_tibble(optimal_scores_parallel_bestball, nrows = 240)

  checkmate::expect_subset(
    c("franchise_id", "franchise_name", "season", "week", "optimal_score", "optimal_lineup", "lineup_efficiency", "actual_score"),
    names(optimal_scores)
  )
  checkmate::expect_subset(
    c("franchise_id", "franchise_name", "season", "week", "optimal_score", "optimal_lineup", "lineup_efficiency", "actual_score"),
    names(optimal_scores_parallel_bestball)
  )

  expect_equal(
    optimal_scores_parallel_bestball$optimal_score,
    optimal_scores_parallel_bestball$actual_score
  )
})

test_that("schedules returns a tibble and specific columns", {
  schedules <- ffs_build_schedules(
    n_teams = 12,
    n_seasons = 2,
    n_weeks = 10
  )

  schedules_w_bye <- ffs_build_schedules(
    n_teams = 11,
    n_seasons = 2,
    n_weeks = 10
  )

  checkmate::expect_tibble(schedules, nrows = 240)

  checkmate::expect_subset(
    c("season", "week", "team", "opponent"),
    names(schedules)
  )


  checkmate::expect_tibble(schedules_w_bye, nrows = 220)
  checkmate::expect_subset(
    c("season", "week", "team", "opponent"),
    names(schedules_w_bye)
  )

})

test_that("summary functions return tibbles", {
  summary_week <- ffs_summarise_week(
    optimal_scores = cache$optimal_scores,
    schedules = cache$schedules
  )
  summary_season <- ffs_summarise_season(summary_week = summary_week)
  summary_simulation <- ffs_summarise_simulation(summary_season = summary_season)

  checkmate::expect_tibble(summary_week, nrows = 240)
  checkmate::expect_tibble(summary_season, nrows = 24)
  checkmate::expect_tibble(summary_simulation, nrows = 12)

  checkmate::expect_subset(
    c(
      "season", "franchise_id", "franchise_name", "h2h_wins", "h2h_winpct",
      "allplay_wins", "allplay_games", "allplay_winpct", "points_for",
      "points_against", "potential_points"
    ),
    names(summary_season),
    label = "summary_season names check"
  )
  checkmate::expect_subset(
    c(
      "season", "season_week", "franchise_name", "optimal_score",
      "lineup_efficiency", "team_score", "opponent_score", "result",
      "opponent_name", "allplay_wins", "allplay_games", "allplay_pct",
      "franchise_id", "optimal_lineup"
    ),
    names(summary_week),
    label = "summary_week names check"
  )
  checkmate::expect_subset(
    c(
      "franchise_id", "franchise_name", "seasons", "h2h_wins", "h2h_winpct",
      "allplay_wins", "allplay_winpct", "points_for", "points_against",
      "potential_points"
    ),
    names(summary_simulation),
    label = "summary_simulation names check"
  )
})
