####  Flea ff_starters ####

#' Get starters and bench
#'
#' @param conn the list object created by `ff_connect()`
#' @param week a numeric or numeric vector
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starters Fleaflicker: returns who was started as well as what they scored.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(season = 2020, league_id = 206154)
#'   ff_starters(conn)
#' }) # end try
#' }
#'
#' @export
ff_starters.flea_conn <- function(conn, week = 1:17, ...) {
  starters <- ff_schedule(conn, week) %>%
    dplyr::filter(!is.na(.data$result)) %>%
    dplyr::distinct(.data$week, .data$game_id) %>%
    dplyr::mutate(starters = purrr::map2(.data$week, .data$game_id, .flea_starters, conn)) %>%
    tidyr::unnest("starters") %>%
    dplyr::arrange(.data$week, .data$franchise_id)
}

.flea_starters <- function(week, game_id, conn) {
  x <- fleaflicker_getendpoint("FetchLeagueBoxscore",
    sport = "NFL",
    scoring_period = week,
    fantasy_game_id = game_id,
    league_id = conn$league_id
  ) %>%
    purrr::pluck("content", "lineups") %>%
    list() %>%
    tibble::tibble() %>%
    tidyr::unnest_longer(1) %>%
    tidyr::unnest_wider(1) %>%
    tidyr::unnest_longer("slots") %>%
    tidyr::unnest_wider("slots") %>%
    dplyr::mutate(
      position = purrr::map_chr(.data$position, purrr::pluck, "label"),
      positionColor = NULL
    ) %>%
    tidyr::pivot_longer(c("home", "away"), names_to = "franchise", values_to = "player") %>%
    tidyr::hoist("player", "proPlayer", "owner", "points" = "viewingActualPoints") %>%
    tidyr::hoist("proPlayer",
      "player_id" = "id",
      "player_name" = "nameFull",
      "pos" = "position",
      "team" = "proTeamAbbreviation"
    ) %>%
    dplyr::filter(!is.na(.data$player_id)) %>%
    tidyr::hoist("owner", "franchise_id" = "id", "franchise_name" = "name") %>%
    tidyr::hoist("points", "player_score" = "value") %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id",
      "franchise_name",
      "starter_status" = "position",
      "player_id",
      "player_name",
      "pos",
      "team",
      "player_score"
    )))

  return(x)
}
