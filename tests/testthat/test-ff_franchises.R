test_that("ff_franchises returns a tibble of franchises", {
  local_mock_api()

  ssb <- mfl_connect(2019, 54040)
  ssb_franchises <- ff_franchises(ssb)

  dlf <- mfl_connect(2020, 37920)
  dlf_franchises <- ff_franchises(dlf)

  jml <- sleeper_connect(2020, "522458773317046272")
  jml_franchises <- ff_franchises(jml)

  dlp <- sleeper_connect(2020, "521379020332068864")
  dlp_franchises <- ff_franchises(dlp)

  joe_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
  joe_franchises <- ff_franchises(joe_conn)

  tony <- espn_connect(season = 2020, league_id = 899513)
  tony_franchises <- ff_franchises(tony)

  expect_tibble(ssb_franchises, nrows = 14)
  expect_tibble(dlf_franchises, nrows = 16)
  expect_tibble(jml_franchises, nrow = 12)
  expect_tibble(dlp_franchises, nrow = 12)
  expect_tibble(joe_franchises, nrow = 16)
  expect_tibble(tony_franchises, nrow = 10)
})
