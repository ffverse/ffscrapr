with_mock_api({
  test_that("ff_playerscores returns a tibble of player scores", {
    sfb_conn <- mfl_connect(2020, 65443)

    sfb_playerscores <- ff_playerscores(sfb_conn, 2019, "AVG")

    expect_tibble(sfb_playerscores, min.rows = 100)

    jml_conn <- ff_connect(platform = "sleeper", league_id = '522458773317046272', season = 2020)
    expect_warning(ff_playerscores(jml_conn))

  })
})
