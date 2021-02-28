with_mock_api({
  test_that("ff_league returns a tibble for each platform currently programmed", {
    skippy()
    dlf_conn <- ff_connect("mfl", 37920, season = 2019)
    dlf_standings <- ff_standings(dlf_conn)

    expect_tibble(dlf_standings, any.missing = FALSE, min.rows = 16)

    jml_conn <- ff_connect("sleeper", "522458773317046272", season = 2020)
    jml_standings <- ff_standings(jml_conn)

    dlp <- sleeper_connect(2020, "521379020332068864")
    dlp_standings <- ff_standings(dlp)

    got_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
    got_standings <- ff_standings(got_conn, include_allplay = FALSE, include_potentialpoints = FALSE)

    got_schedule <- ff_schedule(got_conn, week = 4)
    got_potentialpoints <- .flea_add_potentialpoints(got_schedule, got_conn)

    tony_conn <- espn_connect(season = 2020, league_id = 899513)
    tony_standings <- ff_standings(tony_conn)

    expect_tibble(jml_standings, any.missing = FALSE, nrows = 12)
    expect_tibble(dlp_standings, any.missing = FALSE, nrows = 12)
    expect_tibble(got_standings, any.missing = FALSE, nrows = 16)
    expect_tibble(got_potentialpoints, nrows = 16)
    expect_tibble(tony_standings, any.missing = FALSE, nrows = 10)
  })
})
