#### NFLFASTR IMPORT ####

#' Import latest nflfastr weekly stats
#'
#' Fetches a copy of the latest week-level stats from nflfastr's data repository, via the [nflreadr](https://nflreadr.nflverse.com) package.
#'
#' The goal of this data is to replicate the NFL's official weekly stats, which
#' can diverge a bit from what fantasy data feeds display.
#'
#' If you have any issues with the output of this data, please open an issue in
#' the nflfastr repository.
#'
#' @param seasons The seasons to return, TRUE returns all data available.
#' @param type One of "offense", "defense", or "all" - currently, only "offense" is available.
#'
#' @seealso <https://nflreadr.nflverse.com>
#'
#' @examples
#' \donttest{
#' try( # try only shown here because sometimes CRAN checks are weird
#'   nflfastr_weekly()
#' )
#' }
#'
#' @return Weekly stats for all passers, rushers and receivers in the nflverse play-by-play data from the 1999 season to the most recent season
#'
#' @export
nflfastr_weekly <- function(seasons = TRUE,
                            type = c("offense", "defense", "all")) {

  # type <- match.arg(type)

  df_weekly <- nflreadr::load_player_stats(seasons = seasons)

  return(df_weekly)
}

#' Import nflfastr roster data
#'
#' Fetches a copy of roster data from nflfastr's data repository.
#' The same input/output as nflfastr's fast_scraper_roster function.
#'
#' If you have any issues with the output of this data, please open an issue in
#' the nflfastr repository.
#'
#' @param seasons A numeric vector of seasons, earliest of which is 1999. TRUE returns all seasons, NULL returns latest season.
#'
#' @seealso <https://nflreadr.nflverse.com>
#'
#' @examples
#' \donttest{
#' try( # try only shown here because sometimes CRAN checks are weird
#'   nflfastr_rosters(seasons = 2019:2020)
#' )
#' }
#'
#' @return Data frame where each individual row represents a player in the roster of the given team and season
#'
#' @export

nflfastr_rosters <- function(seasons) {

  df_rosters <- nflreadr::load_rosters(seasons = seasons)

  return(df_rosters)
}
