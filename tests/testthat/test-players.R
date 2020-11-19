with_mock_api({
  test_that("ff_playersish calls return a tibble", {
    mfl <- mfl_players()
    expect_tibble(mfl, min.rows = 300)

    sleeper <- sleeper_players()
    expect_tibble(sleeper, min.rows = 200)

    joe_conn <- ff_connect(platform = "fleaflicker", league_id = 312861, season = 2020)
    flea <- fleaflicker_players(joe_conn)
    expect_tibble(flea,min.rows = 300)


  })
})
