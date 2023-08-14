testthat::test_that("vignette queries work", {
  local_mock_api()
  response_trending <- sleeper_getendpoint('players/nfl/trending/add', lookback_hours = 48, limit = 10)
  aaa <- fleaflicker_connect(season = 2020, league_id = 312861)
  aaa_lg <- ff_league(aaa)
  aaa_ros <- ff_rosters(aaa)

  ssb <- mfl_connect(season = 2020,
                     league_id = 54040, # from the URL of your league
                     rate_limit_number = 3,
                     rate_limit_seconds = 6)
  ssb_lg <- ff_league(ssb)
  ssb_ros <- ff_rosters(ssb)

  response_scoreboard <- fleaflicker_getendpoint("FetchLeagueScoreboard",
                                                 sport = "NFL",
                                                 league_id = 206154,
                                                 season = 2020,
                                                 scoring_period = 5)
  onegame_lineups <- fleaflicker_getendpoint(
    "FetchLeagueBoxscore",
    sport = "NFL",
    league_id = 206154,
    # example for one call, but you can call this in a map or loop!
    fantasy_game_id = 46301923,
    scoring_period = 5)


  sfb_search <- mfl_getendpoint(
    mfl_connect(season = 2020),
    endpoint = "leagueSearch",
    SEARCH = "sfbx conference"
  )

  fog_tradebait <- mfl_getendpoint(
    mfl_connect(season = 2019, league_id = 12608),
    "tradeBait",
    INCLUDE_DRAFT_PICKS = 1)
  fog_franchises <- ff_franchises(mfl_connect(season = 2019, league_id = 12608))
  fog_players <- mfl_players(mfl_connect(season = 2019, league_id = 12608))
})
