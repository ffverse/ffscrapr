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
#'
#' @export ff_connect
#' @return a list that stores MFL connection objects

ff_connect <- function(platform = "mfl",league_id,...){

  platform <- tolower(platform)

  if(!platform %in% c('mfl','sleeper')){stop("We only have code for MFL and Sleeper so far!")}

  switch(platform,
         # 'fleaflicker' = ,
         # 'flea' = fleaflicker_connect(league_id = league_id,...),
         # 'espn' = espn_connect(league_id = league_id,...),
         # 'yahoo' = yahoo_connect(league_id = league_id,...)
         "sleeper" = sleeper_connect(league_id = league_id, ...),
         "mfl" = mfl_connect(league_id=league_id,...)
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

ff_league <- function(conn){
  UseMethod("ff_league")
}

#' @export
ff_league.default <- function(conn){
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
#' @return A tibble of league scoring rules for each position defined.

ff_scoring <- function(conn){
  UseMethod("ff_scoring")
}

#' @export
ff_scoring.default <- function(conn){
  stop(glue::glue("No method of ff_scoring found for platform: {conn$platform}."))
}

#### ff_rosters ####

#' Get League Rosters
#'
#' This function returns a tibble of common league settings - things like "1QB" or "2QB", best ball, team count etc
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @export ff_rosters
#'
#' @return A tibble of rosters, joined to basic player information and basic franchise information

ff_rosters <- function(conn){
  UseMethod("ff_rosters")
}

#' @export
ff_rosters.default <- function(conn){
  stop(glue::glue("No method of ff_rosters found for platform: {conn$platform}."))
}

#### ff_franchises ####

#' Get League Franchises
#'
#' This function returns a tibble of franchise details (id, name, abbrev etc)
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @export ff_franchises
#'
#' @return A tibble of franchises

ff_franchises <- function(conn){
  UseMethod("ff_franchises")
}

#' @export
ff_franchises.default <- function(conn){
  stop(glue::glue("No method of ff_franchises found for platform: {conn$platform}."))
}

#### ff_transactions ####

#' Get League Transactions
#'
#' This function returns a tibble of transactions
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args
#'
#' @export ff_transactions
#'
#' @return A tibble of franchises

ff_transactions <- function(conn,...){
  UseMethod("ff_transactions")
}

#' @export
ff_transactions.default <- function(conn,...){
  stop(glue::glue("No method of ff_transactions found for platform: {conn$platform}."))
}

#### ff_draft ####

#' Get Draft Results
#'
#' This function returns a tibble of draft results
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... additional args which might be used eventually
#'
#' @export ff_draft
#'
#' @return A tibble of draft results

ff_draft <- function(conn,...){
  UseMethod("ff_draft")
}

#' @export
ff_draft.default <- function(conn,...){
  stop(glue::glue("No method of ff_transactions found for platform: {conn$platform}."))
}


# ff_settings_rosters - summarises all available roster setting details

# ff_standings - summarises standings, potential points, all-play

# ff_schedule - summarises matchups in a flat table

# ff_draft_picks - summarises current and future year draft picks

# ff_auction_settings

# ff_auction_details

