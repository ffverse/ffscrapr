test_that("ff_scoring returns a tibble", {
  local_mock_api()

  dlf <- mfl_connect(2019, 37920)
  dlf_scoring <- ff_scoring(dlf)

  jml_conn <- sleeper_connect(league_id = "522458773317046272", season = 2020)
  jml_scoring <- ff_scoring(jml_conn)

  joe_conn <- ff_connect(platform = "fleaflicker", league_id = 312861, season = 2020)
  joe_scoring <- ff_scoring(joe_conn)

  tony_conn <- espn_connect(season = 2020, league_id = 899513)
  tony_scoring <- ff_scoring(tony_conn)

  expect_tibble(dlf_scoring, min.rows = 10)
  expect_tibble(jml_scoring, min.rows = 10)
  expect_tibble(joe_scoring, min.rows = 10)
  expect_tibble(tony_scoring, min.rows = 10)
})

test_that("ff_scoring for templates return tibbles", {
  ppr <- ff_template(scoring_type = "ppr") %>% ff_scoring()
  half_ppr <- ff_template(scoring_type = "half_ppr") %>% ff_scoring()
  zero_ppr <- ff_template(scoring_type = "zero_ppr") %>% ff_scoring()
  sfb11 <- ff_template(scoring_type = "sfb11") %>% ff_scoring()

  expect_tibble(ppr)
  expect_tibble(half_ppr)
  expect_tibble(zero_ppr)
  expect_tibble(sfb11)
})
