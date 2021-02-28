#### ff_standings (ESPN) ####

#' Get a dataframe of league standings
#'
#' @param conn the connection object created by \code{ff_connect()}
#'
#' @examples
#' \donttest{
#' espn_conn <- espn_connect(season = 2020, league_id = 899513)
#' ff_standings(espn_conn)
#' }
#'
#' @describeIn ff_standings ESPN: returns standings and points data.
#'
#' @export
ff_standings.espn_conn <- function(conn) {
  team_endpoint <-
    espn_getendpoint(conn, view = "mTeam") %>%
    purrr::pluck("content")

  standings_init <- team_endpoint %>%
    purrr::pluck("teams") %>%
    tibble::tibble() %>%
    tidyr::hoist(
      .col = 1,
      "franchise_id" = "id",
      # "points" = "points",
      "league_rank" = "rankCalculatedFinal",
      # "league_rank" = "rankFinal",
      "record" = "record"
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "franchise_id",
        # "points",
        "league_rank",
        # "league_rank",
        "record"
      )
      )
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

  standings <-
    dplyr::bind_cols(
      standings_init %>% dplyr::select(-.data$record),
      records
    )
  return(standings)
}
