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
  x <- fleaflicker_getendpoint("FetchLeagueStandings", league_id = conn$league_id, sport = "NFL") %>%
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
