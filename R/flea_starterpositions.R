####  Flea ff_starter_positions ####

#' Get starters and bench
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starter_positions Fleaflicker: returns minimum and maximum starters for each player position.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(season = 2020, league_id = 206154)
#'   ff_starter_positions(conn)
#' }) # end try
#' }
#'
#' @export
ff_starter_positions.flea_conn <- function(conn, ...) {
  x <- fleaflicker_getendpoint("FetchLeagueRules",
    sport = "NFL",
    league_id = conn$league_id
  ) %>%
    purrr::pluck("content", "rosterPositions") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "label", "group", "eligibility", "start") %>%
    dplyr::select("label", "group", "eligibility", min = "start") %>%
    dplyr::filter(.data$group == "START") %>%
    dplyr::mutate_at("min", tidyr::replace_na, 0) %>%
    dplyr::mutate(
      total_starters = sum(min),
      offense_starters = sum(stringr::str_detect(.data$label, "QB|RB|WR|TE") * .data$min),
      defense_starters = sum(stringr::str_detect(.data$label, "EDR|IL|LB|DB|S|CB") * .data$min),
      kdst_starters = sum(stringr::str_detect(.data$label, "K|P|D/ST") * .data$min)
    ) %>%
    tidyr::unnest_longer("eligibility") %>%
    dplyr::group_by(.data$eligibility, .data$total_starters, .data$offense_starters, .data$defense_starters, .data$kdst_starters) %>%
    dplyr::summarise(
      pos_min = sum(stringr::str_detect(.data$label, "/", negate = TRUE) * .data$min, na.rm = TRUE),
      pos_max = sum(.data$min, na.rm = TRUE)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::filter(.data$pos_max != 0) %>%
    dplyr::select(
      pos = "eligibility",
      min = "pos_min",
      max = "pos_max",
      "offense_starters",
      "defense_starters",
      "kdst_starters",
      "total_starters"
    )


  return(x)
}
