test_that("ff_playerscores returns a tibble of player scores", {
  local_mock_api()

  sfb_conn <- mfl_connect(2020, 65443)
  sfb_playerscores <- ff_playerscores(sfb_conn, 2019, "AVG")

  expect_tibble(sfb_playerscores, min.rows = 100)

  jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
  expect_warning(ff_playerscores(jml_conn))

  joe_conn <- fleaflicker_connect(2020, 312861)
  joe_playerscores <- ff_playerscores(joe_conn, page_limit = 2)

  expect_tibble(joe_playerscores, min.rows = 50)

  tony_conn <- espn_connect(season = 2020, league_id = 899513)
  tony_playerscores <- ff_playerscores(tony_conn, limit = 5)

  expect_tibble(tony_playerscores, min.rows = 5)
})
