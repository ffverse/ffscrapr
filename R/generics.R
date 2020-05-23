#### Higher-level Wrappers ####

#' Connect to a League
#'
#' This function creates a connection object which stores parameters and gets a login-cookie if available - it does so by passing arguments to the appropriate league-based handler
#'
#' @param platform one of MFL, (future - Sleeper, Fleaflicker, ESPN, Yahoo in approximate priority order)
#' @param leagueID LeagueID (currently assuming one league at a time)
#'
#' @export
#' @return a list that stores MFL connection objects
#'

league_connect <- function(platform = "mfl",leagueID,...){

  platform <- tolower(platform)

  if(platform!='mfl'){stop("We only have code for MFL so far!")}

  switch(platform,
         "mfl" = mfl_connect(leagueID=leagueID,...),
         "sleeper" = sleeper_connect(leagueID = leagueID, ...),
         'fleaflicker' = ,
         'flea' = fleaflicker_connect(leagueID = leagueID,...))
}

#### Generic Helpers ####

#' Choose current season
#'
#' A helper function to return the current year if March or later, otherwise assume previous year
#' @noRd
#' @keywords internal

.choose_season <- function(){

  if(as.numeric(format(Sys.Date(),"%m"))>2){return(format(Sys.Date(),"%Y"))}

  format(Sys.Date()-365.25,"%Y")
}

#' Rate limit
#'
#' A helper function to rate limit if toggled TRUE
#' @param toggle a logical to turn on rate_limiting if TRUE and off if FALSE
#' @param rate_number number of calls per \code{rate_seconds}
#' @param rate_seconds number of seconds
#'
#' @noRd

.fn_get <- function(toggle = TRUE,rate_number,rate_seconds){

  if(toggle){return(ratelimitr::limit_rate(httr::GET,ratelimitr::rate(rate_number,rate_seconds)))}
  if(!toggle){return(httr::GET)}

}
