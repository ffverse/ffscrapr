#### MFL ff_starters ####

#' MFL ff_starters
#'
#' @param conn the list object created by `ff_connect()`
#' @param season the season of interest - generally only the most recent 2-3 seasons are available
#' @param week a numeric vector (ie 1:3 or 1:17 etc)
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starters MFL: returns the player fantasy scores for each week (not the actual stats)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   dlf_conn <- mfl_connect(2020, league_id = 37920)
#'   ff_starters(conn = dlf_conn)
#' }) # end try
#' }
#'
#' @export
ff_starters.mfl_conn <- function(conn, week = 1:17, season = NULL, ...) {
  checkmate::assert_numeric(week, lower = 1, upper = 21)
  checkmate::assert_number(season, null.ok = TRUE)

  if (!is.null(season)) conn$season <- season

  players_endpoint <- mfl_players(conn) %>%
    dplyr::select("player_id", "player_name", "pos", "team")

  franchises_endpoint <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  weekly_starters <- tibble::tibble(
    season = conn$season,
    week = week
  ) %>%
    dplyr::mutate(starters = purrr::map2(week, season, .mfl_weeklystarters, conn)) %>%
    tidyr::unnest("starters") %>%
    dplyr::mutate(
      player_score = as.numeric(.data$player_score),
      should_start = as.numeric(.data$should_start)
    ) %>%
    dplyr::left_join(
      franchises_endpoint,
      by = "franchise_id"
    ) %>%
    dplyr::filter(!is.na(.data$franchise_name)) %>%
    dplyr::left_join(
      players_endpoint,
      by = "player_id"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id",
      "franchise_name",
      "season",
      "week",
      "starter_status",
      "should_start",
      "player_score",
      "player_id",
      "player_name",
      "pos",
      "team"
    )))

  return(weekly_starters)
}

.mfl_weeklystarters <- function(week, year, conn) {
  weekly_result <- mfl_getendpoint(conn, "weeklyResults", W = week, YEAR = year) %>%
    purrr::pluck("content", "weeklyResults", "matchup") %>%
    purrr::map("franchise") %>%
    tibble::tibble()

  errortibble <- tibble::tibble(
    "franchise_id" = character(),
    "starter_status" = character(),
    "player_id" = character(),
    "player_score" = character(),
    "should_start" = character()
  )

  if (nrow(weekly_result) == 0) {
    return(errortibble)
  }


  weekly_result <- weekly_result %>%
    tidyr::unnest_longer(1) %>%
    tidyr::unnest_wider(1)

  if (!"player" %in% names(weekly_result)) {
    return(errortibble)
  }


  weekly_result %>%
    dplyr::select("franchise_id" = "id", "player") %>%
    tidyr::unnest_longer("player") %>%
    tidyr::unnest_wider("player") %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id",
      "starter_status" = "status",
      "player_id" = "id",
      "player_score" = "score",
      "should_start" = "shouldStart"
    )))
}
