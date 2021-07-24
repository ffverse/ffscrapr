#### ff_draft (Fleaflicker) ####

#' Get Draft Results
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... args for other methods
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(season = 2020, league_id = 206154)
#'   ff_draft(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_draft Fleaflicker: returns a table of drafts for the current year
#'
#' @export
ff_draft.flea_conn <- function(conn, ...) {
  draftboard <- fleaflicker_getendpoint("FetchLeagueDraftBoard",
    sport = "NFL",
    season = conn$season,
    league_id = conn$league_id
  ) %>%
    purrr::pluck("content", "orderedSelections") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "franchise" = "team", "player", "slot") %>%
    tidyr::hoist("slot", "round", "pick" = "slot", "overall") %>%
    tidyr::hoist("franchise", "franchise_id" = "id", "franchise_name" = "name") %>%
    dplyr::mutate(player = purrr::map(.data$player, purrr::pluck, "proPlayer")) %>%
    tidyr::hoist("player",
      "player_id" = "id",
      "player_name" = "nameFull",
      "pos" = "position",
      "team" = "proTeamAbbreviation"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "round",
      "pick",
      "overall",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "team"
    )))

  return(draftboard)
}
