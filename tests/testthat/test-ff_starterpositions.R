test_that("ff_starter_positions returns a tibble of starter positions", {
  local_mock_api()

  dlf <- mfl_connect(2020, 37920)
  dlf_starter_positions <- ff_starter_positions(dlf)

  expect_tibble(dlf_starter_positions, min.rows = 4)

  jml_conn <- sleeper_connect(league_id = "522458773317046272", season = 2020)
  jml_starter_positions <- ff_starter_positions(jml_conn)

  expect_tibble(jml_starter_positions, min.rows = 4)

  got_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
  got_starter_positions <- ff_starter_positions(got_conn)

  expect_tibble(got_starter_positions, min.rows = 10)

  tony_conn <- espn_connect(season = 2020, league_id = 899513)
  tony_starter_positions <- ff_starter_positions(tony_conn)

  expect_tibble(tony_starter_positions, min.rows = 5)
})

test_that("ff_scoring for templates return tibbles", {
  oneqb <- ff_template(roster_type = "1qb") %>% ff_starter_positions()
  sf <- ff_template(roster_type = "superflex") %>% ff_starter_positions()
  sfb11 <- ff_template(roster_type = "sfb11") %>% ff_starter_positions()
  idp <- ff_template(roster_type = "idp") %>% ff_starter_positions()

  expect_tibble(oneqb)
  expect_tibble(sf)
  expect_tibble(sfb11)
  expect_tibble(idp)
})
