#### ff_rosters (MFL) ####

#' Get a dataframe of rosters.
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param custom_players TRUE or FALSE - include custom players? defaults to FALSE
#' @param ... arguments passed to other methods (currently none)
#'
#' @examples
#' ssb_conn <- ff_connect(platform = "mfl", league_id = 54040, season = 2020)
#' ff_rosters(ssb_conn)
#' @rdname ff_rosters
#' @export

ff_rosters.mfl_conn <- function(conn, custom_players = FALSE, ...) {
  stopifnot(is.logical(custom_players))

  rosters_endpoint <- mfl_getendpoint(conn, "rosters") %>%
    purrr::pluck("content", "rosters", "franchise") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "player" = "player", "franchise_id" = "id") %>%
    dplyr::select("player", "franchise_id") %>%
    dplyr::filter(!is.na(.data$player)) %>%
    dplyr::mutate("player" = purrr::map(.data$player, dplyr::bind_rows)) %>%
    tidyr::unnest("player") %>%
    dplyr::rename(
      "player_id" = .data$id,
      "roster_status" = .data$status
    ) %>%
    dplyr::select("franchise_id", "player_id", dplyr::everything())

  players_endpoint <- if (custom_players) {
    mfl_players(conn)
  } else {
    mfl_players()
  }

  players_endpoint <- players_endpoint %>%
    dplyr::select("player_id", "player_name", "pos", "team", "age", "draft_year", "draft_round")

  franchises_endpoint <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  rosters_endpoint %>%
    dplyr::left_join(franchises_endpoint, by = "franchise_id") %>%
    dplyr::left_join(players_endpoint, by = "player_id") %>%
    dplyr::select(
      "franchise_id", "franchise_name",
      "player_id", "player_name", "pos", "team", "age",
      dplyr::everything()
    )
}
