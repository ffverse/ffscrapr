#### ff_franchises (flea) ####

#' Get a dataframe of franchise information
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(season = 2020, league_id = 206154)
#'   ff_franchises(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_franchises Fleaflicker: returns franchise and division information.
#' @export

ff_franchises.flea_conn <- function(conn) {
  x <- fleaflicker_getendpoint("FetchLeagueStandings", season = conn$season, league_id = conn$league_id, sport = "NFL") %>%
    purrr::pluck("content", "divisions") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "division_id" = "id", "division_name" = "name", "teams") %>%
    tidyr::unnest_longer("teams") %>%
    tidyr::hoist("teams",
      "franchise_id" = "id",
      "franchise_name" = "name",
      "franchise_logo" = "logoUrl",
      "franchise_abbrev" = "initials",
      "owners"
    ) %>%
    tidyr::unnest_longer("owners") %>%
    tidyr::hoist("owners",
      "user_id" = "id",
      "user_name" = "displayName",
      "user_avatar" = "avatarUrl",
      "user_lastlogin" = "lastSeen"
    ) %>%
    dplyr::mutate_at("user_lastlogin", ~ (as.numeric(.x) / 1000) %>% .as_datetime()) %>%
    dplyr::select(dplyr::any_of(c(
      dplyr::starts_with("division"),
      dplyr::starts_with("franchise"),
      dplyr::starts_with("user")
    )))

  return(x)
}

#' Get a dataframe of more detailed franchise information
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(season = 2020, league_id = 206154)
#'   ff_franchises(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_franchises Fleaflicker: returns franchise and division information.
#' @export
ff_franchises.flea_conn2 <- function(conn) {
  x <- ffscrapr::fleaflicker_getendpoint("FetchLeagueStandings", season = conn$season, league_id = conn$league_id, sport = "NFL") |>
    purrr::pluck("content", "divisions") |>
    tibble::tibble() |>
    tidyr::hoist(1, "division_id" = "id", "division_name" = "name", "teams") |>
    tidyr::unnest_longer("teams") |>
    tidyr::hoist("teams",
                 "franchise_id" = "id",
                 "franchise_name" = "name",
                 "owners"
    ) |>
    tidyr::unnest_longer("owners") |>
    tidyr::hoist("owners",
                 "user_id" = "id",
                 "user_name" = "displayName",
                 "user_lastlogin" = "lastSeen"
    ) |>
    dplyr::mutate_at("user_lastlogin", ~ (as.numeric(.x) / 1000) |> ffscrapr:::.as_datetime()) |>
    tidyr::hoist("teams",
                 "recordOverall" = "recordOverall",
                 "recordDivision" = "recordDivision",
                 "pointsFor" = "pointsFor",
                 "pointsAgainst" = "pointsAgainst") |>
    tidyr::hoist("pointsFor",
                 "franchise_pointsfor" = "value") |>
    tidyr::hoist("pointsAgainst",
                 "franchise_pointsagainst" = "value") |>
    tidyr::hoist("recordOverall",
                 "franchise_wins" = "wins",
                 "franchise_losses" = "losses",
                 "franchise_rank" = "rank",
                 "franchise_record"= "formatted",
                 "winPercentage" = "winPercentage") |>
    tidyr::hoist("winPercentage",
                 "franchise_winpercentage" = "value") |>
    dplyr::mutate_at("franchise_winpercentage", ~ round(.x,3)) |>
    tidyr::hoist("recordDivision",
                 "franchise_division_wins" = "wins",
                 "franchise_division_losses" = "losses",
                 "franchise_division_rank" = "rank",
                 "franchise_division_record"= "formatted",
                 "winPercentage" = "winPercentage") |>
    tidyr::hoist("winPercentage",
                 "franchise_division_winpercentage" = "value") |>
    dplyr::mutate_at("franchise_division_winpercentage", ~ round(.x,3)) |>
    dplyr::select(dplyr::any_of(c(
      dplyr::starts_with("division"),
      dplyr::starts_with("franchise"),
      dplyr::starts_with("user")
    )))
  
  return(x)
}
