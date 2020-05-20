#### Higher-level Wrappers ####

#' Connect to a League
#'
#' This function creates a connection object which stores parameters and gets a login-cookie if available - it does so by passing arguments to the appropriate league-based handler
#'
#' @param platform one of MFL, (future - Sleeper, Flea, ESPN, Yahoo in approximate priority order)
#' @param leagueID LeagueID (currently assuming one league at a time)
#'
#' @export
#' @return a list that stores MFL connection objects
#'

league_connect <- function(platform = "MFL",leagueID,...){

  if(platform!="MFL"){stop("We only have code for MFL so far!")}

  switch(platform,
         "MFL" = mfl_connect(leagueID=leagueID,...),
         "Sleeper" = sleeper_connect(leagueID = leagueID, ...))

}
