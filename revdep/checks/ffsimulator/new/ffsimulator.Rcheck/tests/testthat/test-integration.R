test_that("MFL simulation works", {

  skip_on_cran()

  foureight <- mfl_connect(2021,22627)
  foureight_sim <- ff_simulate(foureight, n_seasons = 2)

  checkmate::expect_list(foureight_sim, len = 7)
  checkmate::expect_tibble(foureight_sim$summary_simulation, nrows = 12, any.missing = FALSE)
  checkmate::expect_tibble(foureight_sim$summary_season, nrows = 24, any.missing = FALSE)
  checkmate::expect_tibble(foureight_sim$summary_week, nrows = 336, any.missing = FALSE)

})

test_that("Sleeper simulation works", {

  skip_on_cran()

  jml <- ff_connect(platform = "sleeper", league_id = "652718526494253056", season = 2021)
  jml_sim <- ff_simulate(jml, n_seasons = 2)

  checkmate::expect_list(jml_sim, len = 7)
  checkmate::expect_tibble(jml_sim$summary_simulation, nrows = 12, any.missing = FALSE)
  checkmate::expect_tibble(jml_sim$summary_season, nrows = 24, any.missing = FALSE)
  checkmate::expect_tibble(jml_sim$summary_week, nrows = 336, any.missing = FALSE)
})

test_that("Fleaflicker simulation works", {

  skip_on_cran()

  got <- fleaflicker_connect(2020, 206154)
  got_sim <- ff_simulate(got, n_seasons = 2)

  checkmate::expect_list(got_sim, len = 7)
  checkmate::expect_tibble(got_sim$summary_simulation, nrows = 16, any.missing = FALSE)
  checkmate::expect_tibble(got_sim$summary_season, nrows = 32, any.missing = FALSE)
  checkmate::expect_tibble(got_sim$summary_week, nrows = 448, any.missing = FALSE)

})

test_that("ESPN simulation works", {

  skip_on_cran()

  tony <- espn_connect(season = 2020, league_id = 899513)
  tony_sim <- ff_simulate(tony, n_seasons = 2)

  checkmate::expect_list(tony_sim, len = 7)
  checkmate::expect_tibble(tony_sim$summary_simulation, nrows = 10, any.missing = FALSE)
  checkmate::expect_tibble(tony_sim$summary_season, nrows = 20, any.missing = FALSE)
  checkmate::expect_tibble(tony_sim$summary_week, nrows = 280, any.missing = FALSE)

})
