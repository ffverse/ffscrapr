with_mock_api({
  test_that("ff_scoringhistory returns a tibble of player scores", {
    skippy()
    sfb_conn <- mfl_connect(2020, 65443)
    sfb_scoringhistory <- ff_scoringhistory(sfb_conn, 2020)
    expect_tibble(sfb_scoringhistory, min.rows = 3000)

    jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
    jml_playerscores <- ff_scoringhistory(jml_conn, 2020)
    expect_tibble(jml_playerscores, min.rows = 3000)

    joe_conn <- fleaflicker_connect(2020, 312861)
    joe_scoringhistory <- ff_scoringhistory(joe_conn, 2020)
    expect_tibble(joe_scoringhistory, min.rows = 3000)

    tony_conn <- espn_connect(season = 2020, league_id = 899513)
    tony_scoringhistory <- ff_scoringhistory(tony_conn)
    expect_tibble(tony_scoringhistory, min.rows = 3000)
  })
})
