#' Read MFL league
#'
#' @param season Get data for specified league year - if missing, will warn that season is being chosen by sys
#' @param leagueID Identifier for league - generally a five digit number found in the homepage URL
#' @param APIKEY APIKEY - grants access to views as the user in question, optional for public leagues
#'
#' @return the league endpoint for MFL
#'
#' @examples
#' mfl_get_league(season = 2020, leagueID = 54040, APIKEY = NULL)
#'
#' @export mfl_get_league

mfl_get_league <- function(season = NULL, leagueID = NULL, APIKEY = NULL){

  if(is.null(season)){
    message("No season supplied - choosing based on system date")
    season <- .mfl_choose_season()
    }

  season
}

#' Choose correct MFL season
#'
#' Returns current year if March or later, otherwise assumes previous year
#' @noRd
#' @keywords internal

.mfl_choose_season <- function(){
  # If current month is March or later, assume league has rolled over to new league year
  if(as.numeric(format(Sys.Date(),"%m"))>2){return(format(Sys.Date(),"%Y"))}

  format(Sys.Date()-365.25,"%Y")

  }
