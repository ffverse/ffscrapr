#### ff_rosters (MFL) ####

#' Get a dataframe of rosters.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param week a numeric that specifies which week to return
#' @param custom_players "`r lifecycle::badge("deprecated")`" - now returns custom players by default
#' @param ... arguments passed to other methods (currently none)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   ssb_conn <- ff_connect(platform = "mfl", league_id = 54040, season = 2020)
#'   ff_rosters(ssb_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_rosters MFL: returns roster data
#'
#' @export

ff_rosters.mfl_conn <- function(conn, custom_players = deprecated(), week = NULL, ...) {
  checkmate::assert_number(week, null.ok = TRUE)

  if (lifecycle::is_present(custom_players)) {
    lifecycle::deprecate_soft("1.3.0", "ffscrapr::ff_draft.mfl_conn(custom_players=)")
  }

  rosters_endpoint <- mfl_getendpoint(conn, "rosters", W = week) %>%
    purrr::pluck("content", "rosters", "franchise") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "player" = "player", "franchise_id" = "id") %>%
    dplyr::select("player", "franchise_id") %>%
    dplyr::filter(!is.na(.data$player)) %>%
    dplyr::mutate("player" = purrr::map(.data$player, dplyr::bind_rows)) %>%
    tidyr::unnest("player") %>%
    dplyr::rename(
      "player_id" = "id",
      "roster_status" = "status"
    ) %>%
    dplyr::select("franchise_id", "player_id", dplyr::everything())

  players_endpoint <- mfl_players(conn) %>%
    dplyr::select("player_id", "player_name", "pos", "team", "age", "draft_year", "draft_round")

  franchises_endpoint <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  rosters_endpoint %>%
    dplyr::left_join(franchises_endpoint, by = "franchise_id") %>%
    dplyr::left_join(players_endpoint, by = "player_id") %>%
    dplyr::mutate(dplyr::across(dplyr::any_of(c("contractYear", "salary")), as.numeric)) %>%
    dplyr::select(
      "franchise_id", "franchise_name",
      "player_id", "player_name", "pos", "team", "age",
      dplyr::any_of(c("salary", "contract_years" = "contractYear")),
      dplyr::everything()
    )
}
