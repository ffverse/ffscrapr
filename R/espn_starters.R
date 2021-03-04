#### ESPN ff_starters ####

#' Get starters and bench
#'
#' @param conn the list object created by \code{ff_connect()}
#' @param weeks which weeks to calculate, a number or numeric vector
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starters ESPN: returns who was started as well as what they scored.
#'
#' @examples
#' \donttest{
#' conn <- espn_connect(season = 2020, league_id = 1178049)
#' ff_starters(conn, weeks = 1:3)
#' }
#'
#' @export
ff_starters.espn_conn <- function(conn, weeks = 1:17, ...) {

  checkmate::assert_numeric(weeks)

  max_week <- .espn_week_checkmax(conn)

  weeks <- weeks[weeks < max_week]

  starters <- purrr::map_dfr(weeks,.espn_week_starter,conn) %>%
    dplyr::mutate(lineup_slot = .espn_lineupslot_map()[as.character(.data$lineup_id)] %>% unname(),
                  pos = .espn_pos_map()[as.character(.data$pos)] %>% unname(),
                  team = .espn_team_map()[as.character(.data$team)] %>% unname()
                  ) %>%
    dplyr::arrange(.data$week, .data$franchise_id, .data$lineup_id) %>%
    dplyr::left_join(
      ff_franchises(conn) %>% dplyr::select("franchise_id","franchise_name"),
      by = 'franchise_id') %>%
    dplyr::select(dplyr::any_of(c(
      "week",
      "franchise_id",
      "franchise_name",
      "franchise_score",
      "lineup_slot",
      "player_score",
      "player_id",
      "player_name",
      "pos",
      "team",
      "eligible_lineup_slots"
    )))

  return(starters)
}

.espn_week_checkmax <- function(conn){
  url_query <- glue::glue("https://fantasy.espn.com/apis/v3/games/ffl/seasons/",
                          "{conn$season}/segments/0/leagues/{conn$league_id}",
                          "?scoringPeriodId=0&view=mSettings")

  settings <- espn_getendpoint_raw(conn,url_query)

  current_week <- settings %>%
    purrr::pluck("content","status","latestScoringPeriod")

  max_week <- settings %>%
    purrr::pluck("content", "status", "finalScoringPeriod")

  return(max_week)
}

.espn_week_starter <- function(week,conn){

  url_query <- glue::glue("https://fantasy.espn.com/apis/v3/games/ffl/seasons/",
                          "{conn$season}/segments/0/leagues/{conn$league_id}",
                          "?scoringPeriodId={week}&view=mMatchupScore&view=mBoxscore&view=mSettings&view=mRosterSettings")

  week_scores <- espn_getendpoint_raw(conn,url_query) %>%
    purrr::pluck("content","schedule") %>%
    tibble::tibble() %>%
    purrr::set_names("x") %>%
    tidyr::hoist(1,"week"="matchupPeriodId","home","away") %>%
    dplyr::filter(.data$week == .env$week) %>%
    tidyr::pivot_longer(c(.data$home,.data$away),names_to = NULL,values_to = "team") %>%
    tidyr::hoist("team","starting_lineup"="rosterForCurrentScoringPeriod","franchise_id"="teamId") %>%
    dplyr::select(-"team",-"x") %>%
    tidyr::hoist("starting_lineup", "franchise_score"="appliedStatTotal","entries") %>%
    tidyr::unnest_longer("entries") %>%
    tidyr::hoist("entries", "player_id"="playerId","lineup_id" = "lineupSlotId", "player_data"="playerPoolEntry",) %>%
    tidyr::hoist("player_data", "player_score"= "appliedStatTotal", "player") %>%
    dplyr::select(-"player_data") %>%
    tidyr::hoist("player", "eligible_lineup_slots"= "eligibleSlots","player_name"="fullName","pos"="defaultPositionId", "team" = "proTeamId") %>%
    dplyr::select(-"player")

  return(week_scores)
}
