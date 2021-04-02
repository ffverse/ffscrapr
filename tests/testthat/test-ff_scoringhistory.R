with_mock_api({
  test_that("ff_scoringhistory returns a tibble of player scores", {
    skippy()
    sfb_conn <- mfl_connect(2020, 65443)
    sfb_scoringhistory <- ff_scoringhistory(sfb_conn, 2020)
    expect_tibble(sfb_scoringhistory, min.rows = 3000)

    # jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
    # expect_warning(ff_scoringhistory(jml_conn))
    #
    # joe_conn <- fleaflicker_connect(2020, 312861)
    # joe_playerscores <- ff_scoringhistory(joe_conn, page_limit = 2)
    # expect_tibble(joe_playerscores, min.rows = 50)
    #
    # tony_conn <- espn_connect(season = 2020, league_id = 899513)
    # tony_playerscores <- ff_scoringhistory(tony_conn, limit = 5)
    # expect_tibble(tony_playerscores, min.rows = 5)
  })
})
