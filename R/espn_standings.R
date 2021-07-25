#### ff_standings (ESPN) ####

#' Get a dataframe of league standings
#'
#' @param conn the connection object created by `ff_connect()`
#' @param ... other arguments (for other platforms)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   espn_conn <- espn_connect(season = 2020, league_id = 899513)
#'   ff_standings(espn_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_standings ESPN: returns standings and points data.
#'
#' @export
ff_standings.espn_conn <- function(conn, ...) {
  team_endpoint <-
    espn_getendpoint(conn, view = "mTeam") %>%
    purrr::pluck("content")

  standings_init <- team_endpoint %>%
    purrr::pluck("teams") %>%
    tibble::tibble() %>%
    tidyr::hoist(
      .col = 1,
      "franchise_id" = "id",
      "league_rank" = "rankCalculatedFinal",
      "record" = "record"
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "franchise_id",
        "league_rank",
        "record"
      ))
    )

  records <-
    standings_init %>%
    dplyr::select(.data$record) %>%
    tidyr::hoist(
      "record",
      "overall"
    ) %>%
    dplyr::select(-.data$record) %>%
    tidyr::hoist(
      "overall",
      "h2h_wins" = "wins",
      "h2h_losses" = "losses",
      "h2h_ties" = "ties",
      "h2h_winpct" = "percentage",
      "points_for" = "pointsFor",
      "points_against" = "pointsAgainst",
    ) %>%
    dplyr::select(-.data$overall)

  allplay <- ff_schedule(conn) %>%
    .add_allplay()

  franchise_names <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  standings <-
    dplyr::bind_cols(
      standings_init %>% dplyr::select(-.data$record),
      records
    ) %>%
    dplyr::left_join(allplay, by = c("franchise_id")) %>%
    dplyr::left_join(x = franchise_names, by = c("franchise_id"))

  return(standings)
}
