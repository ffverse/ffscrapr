#### ff_rosters (Fleaflicker) ####

#' Get a dataframe of roster data
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... arguments passed to other methods (currently none)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   joe_conn <- ff_connect(platform = "fleaflicker", league_id = 312861, season = 2020)
#'
#'   ff_rosters(joe_conn)
#' }) # end try
#' }
#' @describeIn ff_rosters Fleaflicker: Returns roster data (minus age as of right now)
#' @export
ff_rosters.flea_conn <- function(conn, ...) {
  df_rosters <- fleaflicker_getendpoint("FetchLeagueRosters",
    sport = "NFL",
    external_id_type = "SPORTRADAR",
    league_id = conn$league_id
  ) %>%
    purrr::pluck("content", "rosters") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::hoist("team", "franchise_id" = "id", "franchise_name" = "name") %>%
    dplyr::select(-"team") %>%
    tidyr::unnest_longer("players") %>%
    tidyr::hoist("players", "proPlayer") %>%
    tidyr::hoist("proPlayer",
      "player_id" = "id",
      "player_name" = "nameFull",
      "pos" = "position",
      "team" = "proTeamAbbreviation",
      "externalIds"
    ) %>%
    dplyr::mutate(sportradar_id = purrr::map_chr(.data$externalIds, purrr::pluck, 1, "id", .default = NA)) %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "team",
      "sportradar_id"
    )))

  return(df_rosters)
}
