#### Higher-Level Wrappers ####

# This series of functions are designed to be the main functions - all are prefixed with "ff_" for easy of autocomplete

#' Connect to a League
#'
#' This function creates a connection object which stores parameters and gets a login-cookie if available - it does so by passing arguments to the appropriate league-based handler.
#'
#'
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
         "mfl" = mfl_connect(league_id=league_id,...),
         "sleeper" = sleeper_connect(league_id = league_id, ...)
         )
}

# ff_league - summarises common league details

#' Get League Summary
#'
#' This function returns a dataframe summarizing common league settings.
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @export ff_league
#' @return A one-row tibble of scoring settings.
ff_league <- function(conn){
  UseMethod("ff_league")
}

ff_league.default <- function(conn){
  stop(glue::glue("No method of ff_league found for platform: {conn$platform}."))
}

# ff_settings_scoring - summarises all available scoring setting details
# ff_settings_rosters - summarises all available roster setting details
# ff_franchises - summarises team-level details (FAAB, salary, waiver order?)
# ff_rosters - summarises rosters
# ff_standings - summarises standings, potential points, all-play
# ff_schedule - summarises matchups in a flat table
# ff_draft_picks - summarises current and future year draft picks
# ff_auction_settings -
# ff_auction_details -

