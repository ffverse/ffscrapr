with_mock_api({
  test_that("ff_league returns a tibble for each platform currently programmed", {
    skippy()
    dlf_conn <- ff_connect("mfl", 37920, season = 2020)
    dlf_league <- ff_league(dlf_conn)

    expect_tibble(dlf_league, min.rows = 1)

    jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
    jml_league <- ff_league(jml_conn)
    expect_tibble(jml_league, min.rows = 1)

    bestball_conn <- ff_connect(platform = "sleeper", league_id = "711961723149553664", season = 2021)
    bestball_league <- ff_league(bestball_conn)
    expect_tibble(bestball_league, min.rows = 1)

    got_conn <- fleaflicker_connect(2020, 206154)
    got_league <- ff_league(got_conn)
    expect_tibble(got_league, min.rows = 1)

    espn_conn <- espn_connect(season = 2020, league_id = 899513)
    espn_league <- ff_league(espn_conn)
    expect_tibble(espn_league, min.rows = 1)
  })
})
