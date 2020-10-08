with_mock_api({
  test_that("ff_league returns a tibble for each platform currently programmed", {
    dlf_conn <- ff_connect("mfl", 37920, season = 2019)
    dlf_standings <- ff_standings(dlf_conn)

    expect_tibble(dlf_standings, any.missing = FALSE, min.rows = 16)

    jml_conn <- ff_connect("sleeper", 522458773317046272, season = 2020)
    jml_standings <- ff_standings(jml_conn)

    expect_tibble(jml_standings, any.missing = FALSE, min.rows = 12)

  })
})
