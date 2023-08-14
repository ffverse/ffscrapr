test_that("ff_scoringhistory returns a tibble of player scores", {
  local_mock_api()

  rowcount_check <- FALSE

  try({
    test_ps <- nflreadr::load_player_stats(2019:2020, stat_type = "offense")
    test_psk <- nflreadr::load_player_stats(2019:2020, stat_type = "kicking")
    test_rosters <- nflreadr::load_rosters(2019:2020)
    rowcount_check <- c(
      nrow(test_ps) >= 10000,
      nrow(test_psk) >= 1000,
      nrow(test_rosters) >= 5000
    )
  })

  if(!all(rowcount_check)) skip("nflverse data did not download correctly")

  sfb_conn <- mfl_connect(2020, 65443)
  sfb_scoringhistory <- ff_scoringhistory(sfb_conn, 2019:2020)
  expect_tibble(sfb_scoringhistory, min.rows = 6000)

  foureight_conn <- mfl_connect(2020, 22627)
  foureight_scoringhistory <- ff_scoringhistory(foureight_conn, 2019:2020)
  expect_tibble(foureight_scoringhistory, min.rows = 6000)
  expect_lt(max(foureight_scoringhistory$points), 60)

  jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
  jml_scoringhistory <- ff_scoringhistory(jml_conn, 2019:2020)
  expect_tibble(jml_scoringhistory, min.rows = 6000)

  joe_conn <- fleaflicker_connect(2020, 312861)
  joe_scoringhistory <- ff_scoringhistory(joe_conn, 2019:2020)
  expect_tibble(joe_scoringhistory, min.rows = 6000)

  tony_conn <- espn_connect(season = 2020, league_id = 899513)
  tony_scoringhistory <- ff_scoringhistory(tony_conn, 2019:2020)
  expect_tibble(tony_scoringhistory, min.rows = 3000)

  template_scoringhistory <- ff_template(scoring_type = "sfb11", roster_type = "sfb11") %>%
    ff_scoringhistory(2019:2020)

  expect_tibble(template_scoringhistory, min.rows = 6000)
})
