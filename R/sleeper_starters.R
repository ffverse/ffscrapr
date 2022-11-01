#### Sleeper ff_starters ####

#' Get starters and bench
#'
#' @param conn the list object created by `ff_connect()`
#' @param week a numeric or one of YTD (year-to-date) or AVG (average to date)
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starters Sleeper: returns only "who" was started, without any scoring/stats data. Only returns season specified in initial connection object.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- sleeper_connect(league_id = "522458773317046272", season = 2020)
#'   ff_starters(jml_conn, week = 3)
#' }) # end try
#' }
#'
#' @export
ff_starters.sleeper_conn <- function(conn, week = 1:17, ...) {
  checkmate::assert_numeric(week, lower = 1, upper = 21)

  max_week <- sleeper_getendpoint(glue::glue("league/{conn$league_id}")) %>%
    purrr::pluck("content", "settings", "leg")

  week <- week[week <= max_week]

  players_endpoint <- sleeper_players() %>%
    dplyr::select("player_id", "player_name", "pos", "team")

  franchises_endpoint <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  weekly_starters <- tibble::tibble(
    week = week
  ) %>%
    dplyr::mutate(starters = purrr::map(week, .sleeper_weeklystarters, conn)) %>%
    tidyr::unnest("starters") %>%
    dplyr::left_join(
      franchises_endpoint,
      by = "franchise_id"
    ) %>%
    dplyr::left_join(
      players_endpoint,
      by = "player_id"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id",
      "franchise_name",
      "week",
      "starter_status",
      "player_id",
      "player_name",
      "pos",
      "team"
    )))

  return(weekly_starters)
}

.sleeper_weeklystarters <- function(week, conn) {
  x <- glue::glue("league/{conn$league_id}/matchups/{week}") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content") %>%
    purrr::map(`[`, c("roster_id", "starters", "players")) %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::unnest("players") %>%
    dplyr::mutate(
      starter_status = purrr::map2_chr(
        .data$players, .data$starters,
        ~ dplyr::if_else(.x %in% .y, "starter", "nonstarter")
      ),
      players = purrr::flatten_chr(.data$players)
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id" = "roster_id",
      "player_id" = "players",
      "starter_status"
    )))
}
