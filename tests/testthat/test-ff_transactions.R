test_that("ff_transactions returns a tibble of transactions", {
  local_mock_api()

  # ssb <- mfl_connect(2019, 54040)
  # ssb_transactions <- ff_transactions(ssb)

  # dlf <- mfl_connect(2020, 37920)
  # dlf_transactions <- ff_transactions(dlf)

  # expect_tibble(ssb_transactions, min.rows = 100)
  # expect_tibble(dlf_transactions, min.rows = 100)

  jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
  jml_transactions <- ff_transactions(jml_conn, week = 1:9)

  ## Sleeper - test for simultaneous drops (#246) ##
  templer_conn <- ff_connect(platform = "sleeper", league_id = "515566249837142016", season = 2020)
  templer_transactions <- ff_transactions(templer_conn, week = 1:9)

  ## Sleeper - test for waiver priority handling (#299) ##
  fflm <- ff_connect(platform = "sleeper", league_id = "649647301366755328", season = 2021)
  fflm_transactions <- ff_transactions(fflm, week = 1)

  expect_tibble(jml_transactions, min.rows = 20)
  expect_tibble(templer_transactions, min.rows = 20)
  expect_tibble(fflm_transactions, min.rows = 20)

  got_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
  got_transactions <- ff_transactions(got_conn, franchise_id = 1373475)

  aaa_conn <- fleaflicker_connect(season = 2020, league_id = 312861)
  aaa_transactions <- ff_transactions(aaa_conn, franchise_id = 1581722)

  expect_tibble(aaa_transactions)
  expect_tibble(got_transactions)

  dlp_conn <- espn_connect(
    season = 2020,
    league_id = 1178049,
    swid = Sys.getenv("TAN_SWID"),
    espn_s2 = Sys.getenv("TAN_ESPN_S2")
  )

  dlp_transactions <- ff_transactions(dlp_conn, limit = 10)

  expect_tibble(dlp_transactions)
})
