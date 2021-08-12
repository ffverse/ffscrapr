#### ESPN Player Scores ####

#' ESPN Player Scores
#'
#' @param conn the list object created by `ff_connect()`
#' @param limit A numeric describing the number of players to return - default 1000
#' @param ... other arguments (for other platform/methods)
#'
#' @describeIn ff_playerscores ESPN: returns total points for season and average per game, for both current and previous season.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'
#'   conn <- espn_connect(season = 2020, league_id = 899513)
#'
#'   ff_playerscores(conn, limit = 5)
#' }) # end try
#' }
#' @export
ff_playerscores.espn_conn <- function(conn, limit = 1000, ...) {
  checkmate::assert_number(limit)

  xff <- list(players = list(
    limit = limit,
    sortPercOwned = list(
      sortAsc = FALSE,
      sortPriority = 1
    ),
    filterStatsForTopScoringPeriodIDs = list(
      value = 2,
      additionalValue = c(paste0("00", conn$season))
    )
  )) %>%
    jsonlite::toJSON(auto_unbox = TRUE)

  franchises <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  df_scores <- espn_getendpoint(conn, view = "kona_player_info", x_fantasy_filter = xff) %>%
    purrr::pluck("content", "players") %>%
    tibble::tibble() %>%
    purrr::set_names("x") %>%
    tidyr::hoist("x", "player_id" = "id", "franchise_id" = "onTeamId", "player") %>%
    tidyr::hoist("player", "player_name" = "fullName", "pos_id" = "defaultPositionId", "stats") %>%
    dplyr::mutate(
      pos = .espn_pos_map()[.data$pos_id],
      stats = purrr::map(
        .data$stats,
        ~ tibble::tibble(.x) %>%
          tidyr::unnest_wider(1) %>%
          dplyr::filter(stringr::str_starts(.data$id, "00")) %>%
          dplyr::select(
            "season" = "seasonId",
            "score_total" = "appliedTotal",
            "score_average" = "appliedAverage"
          )
      ),
      x = NULL,
      pos_id = NULL,
      player = NULL
    ) %>%
    tidyr::unnest("stats") %>%
    dplyr::left_join(franchises, by = "franchise_id") %>%
    dplyr::select(
      dplyr::any_of(
        c(
          "season", "player_id", "player_name", "pos",
          "score_total", "score_average", "franchise_id", "franchise_name"
        )
      )
    ) %>%
    dplyr::arrange(dplyr::desc(.data$season), dplyr::desc(.data$score_total))

  return(df_scores)
}
