with_mock_api({
  test_that("ff_playersish calls return a tibble", {
    skippy()
    mfl <- mfl_players(mfl_connect(2020, 54040))
    expect_tibble(mfl, min.rows = 300)

    sleeper <- sleeper_players()
    expect_tibble(sleeper, min.rows = 200)

    joe_conn <- ff_connect(platform = "fleaflicker", league_id = 312861, season = 2020)
    flea <- fleaflicker_players(joe_conn, page_limit = 2)
    expect_tibble(flea)

    conn <- espn_connect(season = 2020, league_id = 1178049)
    espn <- espn_players(conn)

    expect_tibble(espn)
  })
})
