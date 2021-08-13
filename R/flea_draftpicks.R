#### ff_draftpicks - Fleaflicker ####

#' Fleaflicker Draft Picks
#'
#' @param conn the connection object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#' @param franchise_id A list of franchise IDs to pull, if NULL will return all franchise IDs
#'
#' @describeIn ff_draftpicks Fleaflicker: retrieves current and future draft picks, potentially for a specified team.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(2020, 206154)
#'   ff_draftpicks(conn, franchise_id = 1373475)
#' }) # end try
#' }
#'
#' @export
ff_draftpicks.flea_conn <- function(conn, franchise_id = NULL, ...) {
  franchises <- ff_franchises(conn)

  if (!is.null(franchise_id)) {
    franchises <- franchises %>%
      dplyr::filter(.data$franchise_id %in% .env$franchise_id)
  }

  picks <- franchises %>%
    dplyr::transmute(picks = purrr::map(.data$franchise_id, .flea_get_teampicks, conn)) %>%
    tidyr::unnest(1) %>%
    dplyr::arrange(.data$franchise_id, .data$season, .data$round)
}

.flea_get_teampicks <- function(franchise_id, conn) {
  teampicks <- fleaflicker_getendpoint("FetchTeamPicks",
    sport = "NFL",
    league_id = conn$league_id,
    team_id = franchise_id
  ) %>%
    purrr::pluck("content", "picks") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "season", "ownedBy", "originalOwner", "slot", "lost") %>%
    dplyr::filter(!.data$lost | is.na(.data$lost)) %>%
    dplyr::mutate_at(c("ownedBy", "originalOwner", "slot"), purrr::map, as.list) %>%
    tidyr::hoist("slot", "round", "pick" = "slot") %>%
    tidyr::hoist("ownedBy", "franchise_id" = "id", "franchise_name" = "name") %>%
    tidyr::hoist("originalOwner", "original_franchise_id" = "id", "original_franchise_name" = "name") %>%
    dplyr::mutate(
      original_franchise_id = dplyr::coalesce(.data$original_franchise_id, .data$franchise_id),
      original_franchise_name = dplyr::coalesce(.data$original_franchise_name, .data$franchise_name)
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "season", "round", "pick",
      "franchise_id", "franchise_name",
      "original_franchise_id", "original_franchise_name"
    )))

  return(teampicks)
}
