#### ff_standings (Fleaflicker) ####

#' Get a dataframe of league standings
#'
#' @param conn a conn object created by `ff_connect()`
#' @param include_allplay TRUE/FALSE - return all-play win pct calculation? defaults to TRUE
#' @param include_potentialpoints TRUE/FALSE - return potential points calculation? defaults to TRUE.
#' @param ... arguments passed to other methods
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(season = 2020, league_id = 206154)
#'   x <- ff_standings(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_standings Fleaflicker: returns H2H/points/all-play/best-ball data in a table.
#'
#' @export
ff_standings.flea_conn <- function(conn, include_allplay = TRUE, include_potentialpoints = TRUE, ...) {
  standings <- fleaflicker_getendpoint("FetchLeagueStandings",
    league_id = conn$league_id,
    season = conn$season,
    sport = "NFL"
  ) %>%
    purrr::pluck("content", "divisions") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "division_id" = "id", "division_name" = "name", "teams") %>%
    tidyr::unnest_longer("teams") %>%
    tidyr::hoist(
      "teams",
      "franchise_id" = "id",
      "franchise_name" = "name",
      "recordOverall",
      "points_for" = "pointsFor",
      "points_against" = "pointsAgainst"
    ) %>%
    dplyr::mutate(dplyr::across(c("points_for", "points_against"), purrr::map_dbl, purrr::pluck, "value")) %>%
    tidyr::hoist("recordOverall", "h2h_wins" = "wins", "h2h_losses" = "losses", "h2h_ties" = "ties") %>%
    dplyr::mutate(
      dplyr::across(dplyr::starts_with("h2h"), tidyr::replace_na, 0),
      h2h_winpct = (.data$h2h_wins / (.data$h2h_wins + .data$h2h_losses + .data$h2h_ties)) %>% round(3)
    ) %>%
    dplyr::select(
      dplyr::starts_with("division"),
      dplyr::starts_with("franchise"),
      dplyr::starts_with("h2h"),
      dplyr::starts_with("points")
    ) %>%
    dplyr::arrange(dplyr::desc(.data$h2h_winpct))

  if (any(include_potentialpoints, include_allplay)) schedule <- ff_schedule(conn)

  if (include_allplay) {
    allplay <- .add_allplay(schedule)

    standings <- standings %>%
      dplyr::left_join(allplay, by = c("franchise_id"))
  }

  if (include_potentialpoints) {
    potentialpoints <- .flea_add_potentialpoints(schedule, conn)

    standings <- standings %>%
      dplyr::left_join(potentialpoints, by = c("franchise_id"))
  }

  return(standings)
}

.flea_add_potentialpoints <- function(schedule, conn) {
  weeks_played <- schedule %>%
    dplyr::filter(!is.na(.data$result)) %>%
    dplyr::distinct(.data$week, .data$game_id) %>%
    dplyr::mutate(potentialpoints = purrr::map2(.data$week, .data$game_id, .flea_potentialpointsweek, conn)) %>%
    tidyr::unnest(.data$potentialpoints) %>%
    dplyr::group_by(.data$franchise_id) %>%
    dplyr::summarise(potential_points = sum(.data$potential_points)) %>%
    dplyr::ungroup()
}

.flea_potentialpointsweek <- function(week, game_id, conn) {
  x <- fleaflicker_getendpoint("FetchLeagueBoxscore",
    sport = "NFL",
    scoring_period = week,
    fantasy_game_id = game_id,
    league_id = conn$league_id
  ) %>%
    purrr::pluck("content") %>%
    magrittr::extract(c("game", "pointsHome", "pointsAway")) %>%
    list() %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::hoist("game", "home", "away") %>%
    dplyr::mutate(
      dplyr::across(c("home", "away"), ~ purrr::pluck(.x, 1, "id")),
      dplyr::across(
        c("pointsHome", "pointsAway"),
        ~ purrr::map_dbl(.x, purrr::pluck, "scoringPeriod", "optimum", "value")
      )
    )

  home <- x %>%
    dplyr::select(
      "franchise_id" = "home",
      "potential_points" = "pointsHome"
    )

  away <- x %>%
    dplyr::select(
      "franchise_id" = "away",
      "potential_points" = "pointsAway"
    )

  y <- dplyr::bind_rows(home, away)

  return(y)
}
