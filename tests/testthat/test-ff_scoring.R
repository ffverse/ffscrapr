with_mock_api({
  test_that("ff_schedule returns a tibble", {
    dlf <- mfl_connect(2019, 37920)
    dlf_scoring <- ff_scoring(dlf)

    jml_conn <- sleeper_connect(league_id = 522458773317046272, season = 2020)
    jml_scoring <- ff_scoring(jml_conn)

    expect_tibble(dlf_scoring, min.rows = 10)
    expect_tibble(jml_scoring, min.rows = 10)
  })
})
