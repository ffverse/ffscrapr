#### Higher-Level Wrappers ####

# This series of functions are designed to be the main functions - all are prefixed with "ff_" for easy of autocomplete

#### ff_connect ####

#' Connect to a League
#'
#' This function creates a connection object which stores parameters and gets a login-cookie if available - it does so by passing arguments to the appropriate league-based handler.
#'
#' @param platform one of MFL or Sleeper (Fleaflicker, ESPN, Yahoo in approximate priority order going forward)
#' @param league_id league_id (currently assuming one league at a time)
#' @param ... other parameters passed to the connect function for each specific platform.
#'
#' @seealso [mfl_connect()], [sleeper_connect()], [fleaflicker_connect()], [espn_connect()]
#'
#' @examples
#' \donttest{
#' ff_connect(platform = "mfl", season = 2019, league_id = 54040, rate_limit = FALSE)
#' }
#' @export ff_connect
#' @return a connection object to be used with `ff_*` functions

ff_connect <- function(platform = "mfl", league_id = NULL, ...) {
  platform <- tolower(platform)

  x <- switch(platform,
    "fleaflicker" = ,
    "flea" = fleaflicker_connect(league_id = league_id, ...),
    "espn" = espn_connect(league_id = league_id, ...),
    "sleeper" = sleeper_connect(league_id = league_id, ...),
    "mfl" = mfl_connect(league_id = league_id, ...)
    # 'yahoo' = stop("Y YOU YAHOO, YOU YAHOO?")
  )

  if (is.null(x)) stop("We can't connect to that platform yet!")

  x
}

#### ff_league ####

#' Get League Summary
#'
#' This function returns a tidy dataframe of common league settings, including details like "1QB" or "2QB/SF", scoring, best ball, team count, IDP etc. This is potentially useful in summarising the features of multiple leagues.
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @export ff_league
#'
#' @return A one-row summary of each league's main features.

ff_league <- function(conn) {
  UseMethod("ff_league")
}

#' @export
ff_league.default <- function(conn) {
  stop(glue::glue("No method of ff_league found for platform: {conn$platform}."))
}

#### ff_scoring ####

#' Get League Scoring Settings
#'
#' This function returns a dataframe with detailed scoring settings for each league - broken down by event, points, and (if available) position.
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @return A tibble of league scoring rules for each position defined.
#' @export

ff_scoring <- function(conn) {
  UseMethod("ff_scoring")
}

#' @export
ff_scoring.default <- function(conn) {
  stop(glue::glue("No method of ff_scoring found for platform: {conn$platform}."))
}

#### ff_rosters ####

#' Get League Rosters
#'
#' This function returns a tidy dataframe of team rosters
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... arguments passed to other methods
#'
#' @return A tidy dataframe of rosters, joined to basic player information and basic franchise information
#'
#' @export
ff_rosters <- function(conn, ...) {
  UseMethod("ff_rosters")
}

#' @export
ff_rosters.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_rosters found for platform: {conn$platform}."))
}

#### ff_franchises ####

#' Get League Franchises
#'
#' Return franchise-level data (including divisions, usernames, etc) - available data may vary slightly based on platform.
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @return A tidy dataframe of franchises, complete with IDs
#'
#' @export ff_franchises

ff_franchises <- function(conn) {
  UseMethod("ff_franchises")
}

#' @export
ff_franchises.default <- function(conn) {
  stop(glue::glue("No method of ff_franchises found for platform: {conn$platform}."))
}

#### ff_transactions ####

#' Get League Transactions
#'
#' This function returns a tidy dataframe of transactions - generally one row per player per transaction per team.
#' Each trade is represented twice, once per each team.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... additional args passed to platform-specific methods
#'
#' @return A tidy dataframe of transaction data
#'
#' @export

ff_transactions <- function(conn, ...) {
  UseMethod("ff_transactions")
}

#' @export
ff_transactions.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_transactions found for platform: {conn$platform}."))
}

#### ff_draft ####

#' Get Draft Results
#'
#' This function gets a tidy dataframe of draft results for the current year.
#' Can handle MFL devy drafts or startup drafts by specifying the custom_players argument
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... additional args passed to each platform
#'
#' @return A tidy dataframe of draft results
#'
#' @export ff_draft

ff_draft <- function(conn, ...) {
  UseMethod("ff_draft")
}

#' @export
ff_draft.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_transactions found for platform: {conn$platform}."))
}

#### ff_playerscores ####

#' Get Player Scoring History
#'
#' This function returns a tidy dataframe of player scores based on league rules.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... arguments passed to other methods
#'
#' @return A tibble of historical player scoring
#'
#' @export
ff_playerscores <- function(conn, ...) {
  UseMethod("ff_playerscores")
}

#' @export
ff_playerscores.default <- function(conn, season, week, ...) {
  stop(glue::glue("No method of ff_playerscores found for platform: {conn$platform}."))
}

#### ff_standings ####

#' Get Standings
#'
#' This function returns a tidy dataframe of season-long fantasy team stats, including H2H wins as well as points, potential points, and all-play.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... additional args passed to platform-specific methods
#'
#' @return A tidy dataframe of standings data
#'
#' @export ff_standings

ff_standings <- function(conn, ...) {
  UseMethod("ff_standings")
}

#' @export
ff_standings.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_standings found for platform: {conn$platform}."))
}

#### ff_draftpicks ####

#' Get Draft Picks
#'
#' Returns all draft picks (current and future) that belong to a specific franchise and have not yet been converted into players (i.e. selected.)
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... additional args passed to specific methods
#'
#' @return Returns a dataframe with current and future draft picks for each franchise
#'
#' @export
ff_draftpicks <- function(conn, ...) {
  UseMethod("ff_draftpicks")
}

#' @export
ff_draftpicks.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_draftpicks found for platform: {conn$platform}"))
}

#### ff_schedule ####

#' Get Schedule
#'
#' This function returns a tidy dataframe with one row for every team for every weekly matchup
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... additional args passed to each platform
#'
#' @return A tidy dataframe with one row per game per franchise per week
#'
#' @export
ff_schedule <- function(conn, ...) {
  UseMethod("ff_schedule")
}

#' @export
ff_schedule.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_schedule found for platform: {conn$platform}."))
}

#### ff_userleagues ####

#' Get User Leagues
#'
#' This function returns a tidy dataframe with one row for every league a user is in. This requries authentication cookies for MFL usage.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... additional args passed to specific platform methods
#'
#' @return A tidy dataframe with one row for every league a user is in
#'
#' @export
ff_userleagues <- function(conn, ...) {
  UseMethod("ff_userleagues")
}

#' @export
ff_userleagues.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_userleagues found for platform: {conn$platform}."))
}

#### ff_starters ####

#' Get Starting Lineups
#'
#' This function returns a tidy dataframe with one row for every starter (and bench) for every week and their scoring, if available.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... additional args depending on method
#'
#' @export ff_starters
#'
#' @return A tidy dataframe with every player for every week, including a flag for whether they were started or not

ff_starters <- function(conn, ...) {
  UseMethod("ff_starters")
}

#' @export
ff_starters.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_starters found for platform: {conn$platform}."))
}

#### ff_starter_positions ####

#' Get Starting Lineup Settings
#'
#' This function returns a tidy dataframe with positional lineup rules.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... additional args depending on method
#'
#' @return A tidy dataframe of positional lineup rules, one row per position with minimum and maximum starters as well as total starter calculations.
#'
#' @export

ff_starter_positions <- function(conn, ...) {
  UseMethod("ff_starter_positions")
}

#' @export
ff_starter_positions.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_starter_positions found for platform: {conn$platform}."))
}

## ff_scoringhistory ##

#' Get League-Specific Scoring History
#'
#' (Experimental!) This function reads your league's ff_scoring rules and maps them to nflfastr week-level data.
#' Not all of the scoring rules from your league may have nflfastr equivalents, but most of the common ones are available!
#'
#' @param conn a conn object created by `ff_connect()`
#' @param season a numeric vector of seasons (earliest available year is 1999, default is 1999:2020)
#' @param ... other arguments
#'
#' @seealso <https://www.nflfastr.com/reference/load_player_stats.html>
#'
#' @return A tidy dataframe of weekly fantasy scoring data, one row per player per week
#'
#' @export ff_scoringhistory

ff_scoringhistory <- function(conn, season, ...) {
  UseMethod("ff_scoringhistory")
}

#' @export
ff_scoringhistory.default <- function(conn, season, ...) {
  stop(glue::glue("No method of ff_scoringhistory found for platform: {conn$platform}."))
}
