#' ESPN players library
#'
#' A cached table of ESPN NFL players. Will store in memory for each session!
#' (via memoise in zzz.R)
#'
#' @param conn a connection object created by \code{espn_connect} or \code{ff_connect()}
#' @param limit the maximum number of results to return
#'
#' @examples
#' \donttest{
#'   conn <- espn_connect(season = 2020,league_id = 1178049)
#'
#'   player_list <- espn_players(conn, limit = 25)
#' }
#'
#' @return a dataframe containing all ~1000+ players in the ESPN database
#' @export

espn_players <- function(conn, limit = 5000) {

  checkmate::assert_number(limit, lower = 0)

  if(as.numeric(conn$season) < 2018) rlang::abort("ESPN's v3 API does not return player data from before 2018")

  df_players <- espn_getendpoint(
    conn = conn,
    scoringPeriodId = 0,
    view = "kona_player_info",
    x_fantasy_filter =
      jsonlite::toJSON(
        list(players = list(limit = limit,
                            sortPercOwned = list(
                              sortPriority = 1,
                              sortAsc = FALSE)
                            )
             ),
        auto_unbox = TRUE)
    ) %>%
    purrr::pluck("content","players") %>%
    tibble::tibble() %>%
    tidyr::hoist(
      1,
      "player_id"="id",
      "player_data"="player") %>%
    dplyr::select('player_id','player_data') %>%
    tidyr::hoist(
      'player_data',
      "player_name" = "fullName",
      "pos" = "defaultPositionId",
      "eligible_pos" = "eligibleSlots",
      "team"="proTeamId",
      "jersey_num"="jersey"
    ) %>%
    dplyr::mutate(
      pos = purrr::map_chr(as.character(.data$pos), ~.espn_pos_map()[.x]),
      eligible_pos = purrr::map(.data$eligible_pos, ~.espn_lineupslot_map()[as.character(.x)] %>% unname()),
      team = purrr::map_chr(as.character(.data$team), ~.espn_team_map()[.x])
    ) %>%
    dplyr::select(-"player_data")

  return(df_players)
}
