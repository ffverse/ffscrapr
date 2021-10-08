#### ff_rosters (ESPN) ####

#' Get a dataframe of roster data
#'
#' @param conn a conn object created by `ff_connect`
#' @param week a numeric that specifies which week to return
#' @param ... arguments passed to other methods (currently none)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- espn_connect(season = 2020, league_id = 899513)
#'   ff_league(conn)
#' }) # end try
#' }
#' @describeIn ff_rosters ESPN: Returns all roster data.
#' @export
ff_rosters.espn_conn <- function(conn, week = NULL, ...) {
  checkmate::assert_number(week, null.ok = TRUE)

  franchises <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  roster_endpoint <- espn_getendpoint(conn, view = "mRoster", scoringPeriodId = week)

  if (!roster_endpoint$content$draftDetail$drafted) {
    warning(
      glue::glue("ESPN league_id {conn$league_id} has not drafted yet!"),
      call. = FALSE
    )

    return(NULL)
  }

  roster_endpoint <- roster_endpoint %>%
    purrr::pluck("content", "teams") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "franchise_id" = "id", "roster") %>%
    tidyr::hoist("roster", "entries") %>%
    dplyr::select(-"roster") %>%
    tidyr::unnest("entries") %>%
    tidyr::hoist("entries",
      "player_id" = "playerId",
      "player_data" = "playerPoolEntry",
      "status",
      "acquisition_type" = "acquisitionType",
      "acquisition_date" = "acquisitionDate"
    ) %>%
    tidyr::hoist("player_data", "player") %>%
    tidyr::hoist("player",
      "player_name" = "fullName",
      "team" = "proTeamId",
      "pos" = "defaultPositionId",
      "eligible_pos" = "eligibleSlots"
    ) %>%
    dplyr::select(-"entries", -"player_data", -"player") %>%
    dplyr::mutate(
      pos = purrr::map_chr(as.character(.data$pos), ~ .espn_pos_map()[.x]),
      eligible_pos = purrr::map(.data$eligible_pos, ~ .espn_lineupslot_map()[as.character(.x)] %>% unname()),
      team = purrr::map_chr(as.character(.data$team), ~ .espn_team_map()[.x]),
      player = NULL,
      acquisition_date = .as_datetime(.data$acquisition_date / 1000)
    ) %>%
    dplyr::left_join(x = franchises, by = "franchise_id")

  return(roster_endpoint)
}
