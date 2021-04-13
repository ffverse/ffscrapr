with_mock_api({
  test_that("ff_starters returns a tibble of starters", {
    skippy()

    dlf <- mfl_connect(2020, 37920)
    dlf_starters <- ff_starters(dlf, week = c(1:3), year = 2020)

    expect_tibble(dlf_starters, min.rows = 100)

    jml_conn <- sleeper_connect(league_id = "522458773317046272", season = 2020)
    jml_starters <- ff_starters(jml_conn, week = 1:4)

    expect_tibble(jml_starters, min.rows = 100)

    got_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
    got_starters <- ff_starters(got_conn, week = 4)

    expect_tibble(got_starters, min.rows = 100)

    tony_conn <- espn_connect(season = 2020, league_id = 899513)
    tony_starters <- ff_starters(tony_conn, weeks = 1:2)
    tony_potentialpoints <- espn_potentialpoints(tony_conn, weeks = 1:2)

    expect_tibble(tony_starters, min.rows = 100)
    expect_tibble(tony_potentialpoints, min.rows = 100)
  })
})
