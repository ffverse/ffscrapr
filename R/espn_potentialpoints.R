#### ESPN Potential Points ####

#' ESPN Potential Points
#'
#' This function calculates the optimal starters for a given week, using some lineup heuristics.
#'
#' @param conn the list object created by `ff_connect()`
#' @param weeks a numeric vector for determining which weeks to calculate
#'
#' @return a tibble with the best lineup for each team and whether they were started or not
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- espn_connect(season = 2021, league_id = 950665)
#'   espn_potentialpoints(conn, weeks = 1)
#' }) # end try
#' }
#' @export

espn_potentialpoints <- function(conn, weeks = 1:17) {
  player_weeks <- ff_starters(conn, weeks)

  if (is.null(player_weeks)) {
    return(NULL)
  }

  player_weeks <- player_weeks %>%
    dplyr::rename(
      "actual_slot" = "lineup_slot",
      "player_pos" = "pos"
    )

  lineup_settings <- .espn_pp_settings(conn)

  unused_players <- player_weeks %>%
    tidyr::unnest_longer("eligible_lineup_slots") %>%
    dplyr::mutate_at("eligible_lineup_slots", as.character)

  optimal_lineups <- tibble::tibble()

  for (i in lineup_settings$priority) {
    pos <- lineup_settings %>%
      dplyr::rename("optimal_slot" = "pos") %>%
      dplyr::filter(.data$priority == i) %>%
      dplyr::nest_join(
        unused_players,
        by = c("lineup_id" = "eligible_lineup_slots")
      ) %>%
      tidyr::unnest("unused_players") %>%
      dplyr::group_by(.data$week, .data$franchise_id) %>%
      dplyr::mutate(
        rank = rank(dplyr::desc(.data$player_score), ties.method = c("first"))
      ) %>%
      dplyr::filter(.data$rank <= .data$count)

    optimal_lineups <- dplyr::bind_rows(optimal_lineups, pos)

    unused_players <- unused_players %>%
      dplyr::anti_join(pos, by = c("week", "player_id"))
  }

  finalized_optimal <- player_weeks %>%
    dplyr::anti_join(optimal_lineups, by = c("player_id", "week")) %>%
    dplyr::bind_rows(x = optimal_lineups) %>%
    dplyr::arrange(
      .data$week,
      .data$franchise_id,
      .data$priority,
      dplyr::desc(.data$player_score)
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "week",
      "franchise_id",
      "franchise_name",
      "franchise_score",
      "optimal_slot",
      "actual_slot",
      "player_score",
      "player_name",
      "player_pos",
      "team",
      "player_id"
    )))

  return(finalized_optimal)
}

.espn_pp_settings <- function(conn) {
  lineup_settings <- espn_getendpoint(conn, view = "mSettings") %>%
    purrr::pluck("content", "settings", "rosterSettings", "lineupSlotCounts") %>%
    tibble::enframe(name = "lineup_id", value = "count") %>%
    dplyr::mutate(pos = .espn_lineupslot_map()[as.character(.data$lineup_id)]) %>%
    tidyr::unnest(c("pos", "count")) %>%
    dplyr::left_join(.espn_pp_lineupkeys(), by = "lineup_id") %>%
    dplyr::filter(.data$count > 0, .data$priority > 0) %>%
    dplyr::arrange(.data$priority)

  return(lineup_settings)
}

.espn_pp_lineupkeys <- function() {
  tibble::tibble(
    lineup_id = c("0", "2", "3", "4", "5", "6", "7", "16", "17", "20", "21", "23", "8", "9", "10", "11", "24", "12", "13", "14", "15"),
    priority = c(1, 2, 5, 3, 6, 4, 9, 10, 11, 0, 0, 8, 12, 13, 16, 14, 15, 17, 18, 19, 20)
  ) %>%
    dplyr::arrange(.data$priority) %>%
    dplyr::mutate(lineup_id = as.character(.data$lineup_id))
}
