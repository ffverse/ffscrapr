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
