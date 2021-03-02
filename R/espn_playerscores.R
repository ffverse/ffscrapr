#### ESPN Player Scores ####

#' ESPN Player Scores
#'
#' @param conn the list object created by \code{ff_connect()}
#' @param limit A numeric describing the number of players to return - default 1000
#' @param ... other arguments (for other platform/methods)
#'
#' @describeIn ff_playerscores ESPN
#'
#' @examples
#' \donttest{
#'
#' conn <- espn_connect(season = 2020, league_id = 899513)
#' x <- ff_playerscores(conn, limit = 10)
#' x
#' }
#' @export
ff_playerscores.espn_conn <- function(conn, limit = 1000, ...) {

  checkmate::assert_number(limit)

  xff <- list(players = list(
    limit = limit,
    sortPercOwned = list(
      sortAsc = FALSE,
      sortPriority = 1
    )
  )) %>%
    jsonlite::toJSON(auto_unbox = TRUE)

  x <- espn_getendpoint(conn,view = "kona_player_info",x_fantasy_filter = xff)


  return(df_players)
}
