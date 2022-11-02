#### ESPN ff_starters ####

#' Get starters and bench
#'
#' @param conn the connection object created by `ff_connect()`
#' @param weeks which weeks to calculate, a number or numeric vector
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starters ESPN: returns who was started as well as what they scored.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- espn_connect(season = 2020, league_id = 1178049)
#'   ff_starters(conn, weeks = 1:3)
#' }) # end try
#' }
#'
#' @export
ff_starters.espn_conn <- function(conn, weeks = 1:17, ...) {
  if (conn$season < 2018) stop("Starting lineups not available before 2018")

  checkmate::assert_numeric(weeks)

  max_week <- .espn_week_checkmax(conn)

  run_weeks <- weeks[weeks < max_week]

  if (length(run_weeks) == 0) {
    warning(
      glue::glue(
        "ESPN league_id {conn$league_id} does not have lineups for ",
        "{conn$season} weeks {paste(min(weeks),max(weeks), sep = '-')}."
      ),
      call. = FALSE
    )

    return(NULL)
  }

  starters <- purrr::map_dfr(run_weeks, .espn_week_starter, conn) %>%
    dplyr::mutate(
      lineup_slot = .espn_lineupslot_map()[as.character(.data$lineup_id)] %>% unname(),
      pos = .espn_pos_map()[as.character(.data$pos)] %>% unname(),
      team = .espn_team_map()[as.character(.data$team)] %>% unname()
    ) %>%
    dplyr::arrange(.data$week, .data$franchise_id, .data$lineup_id) %>%
    dplyr::left_join(
      ff_franchises(conn) %>% dplyr::select("franchise_id", "franchise_name"),
      by = "franchise_id"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "week",
      "franchise_id",
      "franchise_name",
      "franchise_score",
      "lineup_slot",
      "player_score",
      "projected_score",
      "player_id",
      "player_name",
      "pos",
      "team",
      "eligible_lineup_slots"
    )))

  return(starters)
}

.espn_week_checkmax <- function(conn) {
  url_query <- glue::glue(
    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/",
    "{conn$season}/segments/0/leagues/{conn$league_id}",
    "?scoringPeriodId=0&view=mSettings"
  )

  settings <- espn_getendpoint_raw(conn, url_query)

  current_week <- settings %>%
    purrr::pluck("content", "status", "latestScoringPeriod")

  final_week <- settings %>%
    purrr::pluck("content", "status", "finalScoringPeriod")

  max_week <- min(current_week, final_week, na.rm = TRUE)

  return(max_week)
}

.espn_week_starter <- function(week, conn) {
  url_query <- glue::glue(
    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/",
    "{conn$season}/segments/0/leagues/{conn$league_id}",
    "?scoringPeriodId={week}&view=mMatchupScore&view=mBoxscore&view=mSettings&view=mRosterSettings"
  )

  week_scores <- espn_getendpoint_raw(conn, url_query) %>%
    purrr::pluck("content", "schedule") %>%
    tibble::tibble() %>%
    purrr::set_names("x") %>%
    tidyr::hoist(1, "week" = "matchupPeriodId", "home", "away") %>%
    dplyr::filter(.data$week == .env$week) %>%
    tidyr::pivot_longer(c("home", "away"), names_to = NULL, values_to = "team") %>%
    tidyr::hoist("team", "starting_lineup" = "rosterForCurrentScoringPeriod", "franchise_id" = "teamId") %>%
    dplyr::select(-"team", -"x") %>%
    tidyr::hoist("starting_lineup", "franchise_score" = "appliedStatTotal", "entries") %>%
    tidyr::unnest_longer("entries") %>%
    tidyr::hoist("entries", "player_id" = "playerId", "lineup_id" = "lineupSlotId", "player_data" = "playerPoolEntry") %>%
    tidyr::hoist("player_data", "player_score" = "appliedStatTotal", "player") %>%
    dplyr::select(-"player_data") %>%
    tidyr::hoist("player",
                 "eligible_lineup_slots" = "eligibleSlots",
                 "player_name" = "fullName",
                 "pos" = "defaultPositionId",
                 "team" = "proTeamId",
                 ) %>%
    dplyr::mutate(
      projected_score = purrr::map_dbl(.data$player,
                                       ~.x %>%
                                         purrr::pluck("stats",
                                                      2, # assume stats list col returns actual as first list and projected as second
                                                      "appliedTotal",
                                                      .default = NA_real_) %>%
                                         round(1)),
      player = NULL)

  return(week_scores)
}
