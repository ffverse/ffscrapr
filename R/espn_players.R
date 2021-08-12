#' ESPN players library
#'
#' A cached table of ESPN NFL players. Will store in memory for each session!
#' (via memoise in zzz.R)
#'
#' @param conn a connection object created by `espn_connect` or `ff_connect()`
#' @param season a season to fetch
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'
#'   conn <- espn_connect(season = 2020, league_id = 1178049)
#'
#'   espn_players(conn, season = 2020)
#' }) # end try
#' }
#'
#' @return a dataframe containing all ~2000+ active players in the ESPN database
#' @export

espn_players <- function(conn = NULL, season = NULL) {
  checkmate::assert_number(season, null.ok = TRUE)

  if (!is.null(conn) && is.null(season)) season <- conn$season

  if (is.null(season)) season <- .fn_choose_season()

  xff <- list(filterActive = list(value = TRUE)) %>%
    jsonlite::toJSON(auto_unbox = TRUE)

  xff <- httr::add_headers(`x-fantasy-filter` = xff)

  url_query <- glue::glue(
    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/",
    "{season}/players?scoringPeriodId=0&view=players_wl"
  )

  df_players <- espn_getendpoint_raw(conn, url_query, xff) %>%
    purrr::pluck("content") %>%
    tibble::tibble() %>%
    stats::setNames("x") %>%
    tidyr::hoist(
      "x",
      "player_id" = "id",
      "player_name" = "fullName",
      "pos" = "defaultPositionId",
      "eligible_pos" = "eligibleSlots",
      "team" = "proTeamId"
    ) %>%
    dplyr::mutate(
      pos = purrr::map_chr(as.character(.data$pos), ~ .espn_pos_map()[.x]),
      eligible_pos = purrr::map(.data$eligible_pos, ~ .espn_lineupslot_map()[as.character(.x)] %>% unname()),
      team = purrr::map_chr(as.character(.data$team), ~ .espn_team_map()[.x]),
      x = NULL
    )

  return(df_players)
}
