#### MFL Player Scores ####

#' MFL PlayerScores
#'
#' @param conn the list object created by \code{ff_connect()}
#' @param season the season of interest - generally only the most recent 2-3 seasons are available
#' @param week a numeric or one of YTD (year-to-date) or AVG (average to date)
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_playerscores MFL: returns the player fantasy scores for each week (not the actual stats)
#'
#' @examples
#' dlf_conn <- mfl_connect(2020, league_id = 37920)
#' ff_playerscores(conn = dlf_conn, season = 2019, week = "YTD")
#' @export

ff_playerscores.mfl_conn <- function(conn, season, week, ...) {
  if (!(is.numeric(week) | week %in% c("AVG", "YTD"))) {
    stop("week should be either a numeric or one of AVG or YTD")
  }

  df <- mfl_getendpoint(conn, "playerScores", YEAR = season, W = week, RULES = 1) %>%
    purrr::pluck("content", "playerScores", "playerScore") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::left_join(
      dplyr::select(mfl_players(), "player_id", "player_name", "pos", "team"),
      by = c("id" = "player_id")
    ) %>%
    dplyr::mutate(
      season = season,
      week = week
    ) %>%
    dplyr::select("season", "week", "player_id" = "id", "player_name", "pos", "team", "points" = "score", "isAvailable")

  return(df)
}
