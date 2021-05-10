#### Sleeper Player Scores ####

#' Sleeper PlayerScores
#'
#' Unfortunately, Sleeper has deprecated their player stats endpoint from their supported/open API.
#' Please see `ff_scoringhistory()` for an alternative reconstruction.
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_playerscores Sleeper: Deprecated their open API endpoint for player scores
#'
#' @seealso ff_scoringhistory
#'
#' @export

ff_playerscores.sleeper_conn <- function(conn, ...) {
  warning(glue::glue("Sleeper has deprecated their stats endpoint, no player stats data can be returned at this time."))
}
