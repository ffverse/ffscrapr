with_mock_api({
  test_that("ff_schedule returns a tibble", {
    skippy()
    dlf <- mfl_connect(2019, 37920)
    dlf_schedule <- ff_schedule(dlf)

    ssb <- mfl_connect(2020, 54040)
    ssb_schedule <- ff_schedule(ssb)

    fog <- mfl_connect(2019, 12608)
    fog_schedule <- ff_schedule(fog)

    jml_conn <- sleeper_connect(league_id = "522458773317046272", season = 2020)
    jml_schedule <- ff_schedule(jml_conn)

    joe_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
    joe_schedule <- ff_schedule(joe_conn, week = 4)

    tony_conn <- espn_connect(season = 2020, league_id = 899513)
    tony_schedule <- ff_schedule(tony_conn)

    expect_tibble(ssb_schedule, min.rows = 100)
    expect_tibble(dlf_schedule, min.rows = 100)
    expect_tibble(jml_schedule, min.rows = 100)
    expect_null(fog_schedule)

    expect_tibble(joe_schedule, min.rows = 16)
    expect_tibble(tony_schedule, min.rows = 100)
  })
})
