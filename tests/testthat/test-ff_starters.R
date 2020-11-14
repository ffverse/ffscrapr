with_mock_api({
  test_that("ff_transactions returns a tibble of starters", {

    dlf <- mfl_connect(2020, 37920)
    dlf_starters <- ff_starters(dlf,week = 1:2,year = 2020)

    expect_tibble(dlf_starters, min.rows = 100)

    jml_conn <- sleeper_connect(league_id = 522458773317046272, season = 2020)
    jml_starters <- ff_starters(jml_conn, week = 1:2)

    expect_tibble(jml_starters, min.rows = 100)

  })
})
