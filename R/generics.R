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
#' \code{rate_limit} Defaults to TRUE. Pass \code{FALSE} to turn off.
#'
#' \code{rate_limit_number} number of attempts to try in \code{rate_limit_seconds}.
#'
#' \code{APIKEY} MFL-specific - grants access to perform something as a user in a specific league
#'
#' \code{user_name} Collects user_name field for leagues that support it (MFL, Sleeper so far)
#'
#' \code{password} Collects password and attempts to fetch an authorization token which functions a lot like an APIKEY
#'
#' \code{user_agent} Identifies user scraping the data
#'
#' @examples
#' ff_connect(platform = "mfl", season = 2019, league_id = 54040, rate_limit = FALSE)
#' @export ff_connect
#' @return a connection object to be used with \code{ff_*} functions
#'
#' @seealso \code{\link{mfl_connect}}, \code{\link{sleeper_connect}}

ff_connect <- function(platform = "mfl", league_id = NULL, ...) {
  platform <- tolower(platform)

  if (!platform %in% c("mfl", "sleeper")) {
    stop("We only have code for MFL and Sleeper so far!")
  }

  switch(platform,
    # 'fleaflicker' = ,
    # 'flea' = fleaflicker_connect(league_id = league_id,...),
    # 'espn' = espn_connect(league_id = league_id,...),
    # 'yahoo' = yahoo_connect(league_id = league_id,...)
    "sleeper" = sleeper_connect(league_id = league_id, ...),
    "mfl" = mfl_connect(league_id = league_id, ...)
  )
}

#### ff_league ####

#' Get League Summary
#'
#' This function returns a tibble of common league settings, including details like "1QB" or "2QB/SF", best ball, team count etc
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @export ff_league
#'
#' @return A one-row tibble of league settings.

ff_league <- function(conn) {
  UseMethod("ff_league")
}

#' @export
ff_league.default <- function(conn) {
  stop(glue::glue("No method of ff_league found for platform: {conn$platform}."))
}

#### ff_scoring ####

#' Get League Scoring settings
#'
#' This function returns a dataframe with detailed scoring settings, broken down by position, event, range, and points.
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @export
#'
#' @return A tibble of league scoring rules for each position defined.

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
#' This function returns a tibble of team rosters
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... arguments passed to other methods
#' \code{custom_players} TRUE or FALSE - include custom players (i.e. devy?)
#'
#' @export ff_rosters
#'
#' @return A tibble of rosters, joined to basic player information and basic franchise information

ff_rosters <- function(conn, ...) {
  UseMethod("ff_rosters")
}

#' @export
#'
ff_rosters.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_rosters found for platform: {conn$platform}."))
}

#### ff_franchises ####

#' Get League Franchises
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @export ff_franchises
#'
#' @return A tibble of franchises, complete with IDs

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
#' This function returns a tibble of transactions
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args
#' \code{custom_players} TRUE or FALSE - retrieve custom/devy players from database?
#'
#' @export ff_transactions
#'
#' @return A tidy dataframe of transaction data

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
#' This function gets a table of the draft results for the current year.
#' Can handle MFL devy drafts or startup drafts by specifying the custom_players argument
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args
#' \code{custom_players} TRUE or FALSE - retrieve custom players from the MFL database? (Devy, placeholder picks etc)
#'
#' @export ff_draft
#'
#' @return A tibble of draft results

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
#' This function returns a tibble of player scores based on league rules
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param season the season to look up (generally only recent seasons available)
#' @param week a numeric week or one of YTD (year to date) or AVG (average)
#' @param ... arguments passed to other methods
#'
#' @return A tibble of historical player scoring

#' @export

ff_playerscores <- function(conn, season, week, ...) {
  UseMethod("ff_playerscores")
}

#' @export
ff_playerscores.default <- function(conn, season, week, ...) {
  stop(glue::glue("No method of ff_playerscores found for platform: {conn$platform}."))
}

#### ff_standings ####

#' Get Standings
#'
#' This function returns a tibble of season-long fantasy team stats
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args which might be used eventually
#'
#' @export ff_standings
#'
#' @return A tibble of standings

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
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args which might be used eventually
#'
#' @export ff_draftpicks

ff_draftpicks <- function(conn, ...) {
  UseMethod("ff_draftpicks")
}

#' @export
ff_draftpicks.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_draftpicks found for platform: {conn$platform}"))
}

# ff_schedule - summarises matchups in a flat table

#### ff_schedule ####

#' Get Schedule
#'
#' This function returns a tibble with one row for every team for every weekly matchup
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args which might be used eventually
#'
#' @export ff_schedule
#'
#' @return A tidy dataframe with one row per game per franchise per week

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
#' This function returns a tibble with one row for every league a user is in. This requries authentication cookies for MFL usage.
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args which might be used eventually
#' \code{season} in MFL, you can look up previous seasons by passing a season parameter
#' \code{user_name} in Sleeper, you can look up users not in the Sleeper conn object by passing a user_name param
#'
#' @export ff_userleagues
#'
#' @return A tidy dataframe with one row for every league a user is in

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
#' This function returns a tibble with one row for every starter (and bench) for every week and their scoring, if available.
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args depending on method
#'
#' @export ff_starters
#'
#' @return A tibble

ff_starters <- function(conn, ...) {
  UseMethod("ff_starters")
}

#' @export
ff_starters.default <- function(conn, ...) {
  stop(glue::glue("No method of ff_starters found for platform: {conn$platform}."))
}
