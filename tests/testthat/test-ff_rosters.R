test_that("ff_rosters returns a tibble", {
  local_mock_api()

  ssb <- mfl_connect(2020, 54040)
  ssb_rosters <- ff_rosters(ssb)
  ssb_rosters_w2 <- ff_rosters(ssb, week = 2)
  expect_tibble(ssb_rosters, min.rows = 300)
  expect_tibble(ssb_rosters_w2, min.rows = 300)

  jml_conn <- sleeper_connect(league_id = "522458773317046272", season = 2020)
  jml_rosters <- ff_rosters(jml_conn)
  expect_tibble(jml_rosters, min.rows = 200)

  joe_conn <- ff_connect(platform = "fleaflicker", league_id = 312861, season = 2020)
  joe_rosters <- ff_rosters(joe_conn)
  expect_tibble(joe_rosters, min.rows = 200)

  tony_conn <- espn_connect(season = 2020, league_id = 899513)
  tony_rosters <- ff_rosters(tony_conn)
  tony_rosters_w2 <- ff_rosters(tony_conn, week = 2)

  expect_tibble(tony_rosters, min.rows = 200)
  expect_tibble(tony_rosters_w2, min.rows = 200)
})
