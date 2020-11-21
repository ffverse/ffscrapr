with_mock_api({
  test_that("ff_league returns a tibble for each platform currently programmed", {
    dlf_conn <- ff_connect("mfl", 37920, season = 2020)
    dlf_league <- ff_league(dlf_conn)

    expect_tibble(dlf_league, any.missing = FALSE, min.rows = 1)

    jml_conn <- ff_connect(platform = "sleeper", league_id = 522458773317046272, season = 2020)
    jml_league <- ff_league(jml_conn)
    expect_tibble(jml_league, any.missing = FALSE, min.rows = 1)

    got_conn <- fleaflicker_connect(2020,206154)
    got_league <- ff_league(got_conn)

  })
})
