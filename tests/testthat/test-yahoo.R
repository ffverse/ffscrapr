test_that("yahoo",{
  skip_if_not(
    (!.bypass_mocks() && !.rebuild_mocks()) || Sys.getenv("CALTONJI_YAHOO_TOKEN") != ""
  )

  conn <- yahoo_connect(
    league_id = 77275,
    season = 2023,
    token = Sys.getenv("CALTONJI_YAHOO_TOKEN")
  )

  user_leagues <- ff_userleagues(conn)
  checkmate::expect_tibble(user_leagues, min.rows = 25)
  expect_contains(user_leagues$league_id, "77275")

  game_id <- .yahoo_game_id(conn, 2023)
  expect_equal(game_id, "423")

  franchises <- ff_franchises(conn)
  checkmate::expect_tibble(franchises, min.rows = 10)
  expect_equal(nrow(franchises), 10)
})
