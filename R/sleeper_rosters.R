#### ff_rosters (Sleeper) ####

#' Get a dataframe of roster data
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... arguments passed to other methods (currently none)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_rosters(jml_conn)
#' }) # end try
#' }
#' @describeIn ff_rosters Sleeper: Returns all roster data.
#' @export
ff_rosters.sleeper_conn <- function(conn, ...) {
  players_endpoint <- sleeper_players() %>%
    dplyr::select("player_id", "player_name", "pos", "team", "age")

  franchises_endpoint <- ff_franchises(conn) %>%
    dplyr::transmute(franchise_id = as.character(.data$franchise_id), .data$franchise_name)

  df_rosters <- sleeper_getendpoint(glue::glue("league/{conn$league_id}/rosters")) %>%
    purrr::pluck("content") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "player_id" = "players", "franchise_id" = "roster_id") %>%
    tidyr::unnest("player_id") %>%
    dplyr::transmute(
      franchise_id = as.character(.data$franchise_id),
      player_id = as.character(.data$player_id)
    ) %>%
    dplyr::left_join(players_endpoint, by = "player_id") %>%
    dplyr::left_join(franchises_endpoint, by = "franchise_id") %>%
    dplyr::select(
      "franchise_id", "franchise_name",
      "player_id", "player_name", "pos", "team", "age",
      dplyr::everything()
    )

  return(df_rosters)
}
