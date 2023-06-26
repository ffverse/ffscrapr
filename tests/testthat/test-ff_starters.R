test_that("ff_starters returns a tibble of starters", {
  local_mock_api()

  dlf <- mfl_connect(2020, 37920)
  dlf_starters <- ff_starters(dlf, week = c(1:3), year = 2020)

  expect_tibble(dlf_starters, min.rows = 100)

  jml_conn <- sleeper_connect(league_id = "522458773317046272", season = 2020)
  jml_starters <- ff_starters(jml_conn, week = 1:4)

  expect_tibble(jml_starters, min.rows = 100)

  got_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
  got_starters <- ff_starters(got_conn, week = 4)

  expect_tibble(got_starters, min.rows = 100)

  tony_conn <- espn_connect(season = 2020, league_id = 899513)
  tony_starters <- ff_starters(tony_conn, weeks = 1:2)
  tony_potentialpoints <- espn_potentialpoints(tony_conn, weeks = 1:2)

  expect_tibble(tony_starters, min.rows = 100)
  expect_tibble(tony_potentialpoints, min.rows = 100)
})

test_that("ff_starters.espn finds the correct projected scores #397",{
  league_conn <- espn_connect(season = 2022, league_id = 98743043)
  s <- ff_starters(league_conn, weeks = 1:3)

  # expect no projections to match actuals except for where they are both zero
  n_projection_equal_actual <- sum(s$player_score == s$projected_score & s$player_score!=0)
  expect_equal(n_projection_equal_actual, 0)
})
