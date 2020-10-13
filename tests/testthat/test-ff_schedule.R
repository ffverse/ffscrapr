with_mock_api({
  test_that("ff_schedule returns a tibble", {
    dlf <- mfl_connect(2019, 37920)
    dlf_schedule <- ff_schedule(dlf)

    ssb <- mfl_connect(2020, 54040)
    ssb_schedule <- ff_schedule(ssb)

    fog <- mfl_connect(2019, 12608)
    fog_schedule <- ff_schedule(fog)

    jml_conn <- sleeper_connect(league_id = 522458773317046272, season = 2020)
    jml_schedule <- ff_schedule(jml_conn)

    expect_tibble(ssb_schedule, min.rows = 100)
    expect_tibble(dlf_schedule, min.rows = 100)
    expect_tibble(jml_schedule, min.rows = 100)
    expect_null(fog_schedule)
  })
})
