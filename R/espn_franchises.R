#### ff_franchises (flea) ####

#' Get a dataframe of franchise information
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'
#'   conn <- espn_connect(season = 2020, league_id = 1178049)
#'
#'   ff_franchises(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_franchises ESPN: returns franchise and division information.
#' @export
ff_franchises.espn_conn <- function(conn) {
  team_endpoint <- espn_getendpoint(conn, view = "mTeam") %>%
    purrr::pluck("content")

  members <- team_endpoint %>%
    purrr::pluck("members") %>%
    purrr::map_dfr(`[`, c("displayName", "firstName", "lastName", "id")) %>%
    dplyr::transmute(
      "user_nickname" = .data$displayName,
      "user_name" = paste(.data$firstName, .data$lastName),
      "user_id" = .data$id
    )

  teams <- team_endpoint %>%
    purrr::pluck("teams") %>%
    tibble::tibble() %>%
    tidyr::hoist(
      .col = 1,
      "franchise_id" = "id",
      "franchise_abbrev" = "abbrev",
      "franchise_location" = "location",
      "franchise_nickname" = "nickname",
      "logo" = "logo",
      "waiver_order" = "waiverRank",
      "user_id" = "primaryOwner"
    ) %>%
    dplyr::left_join(members, by = c("user_id" = "user_id")) %>%
    dplyr::mutate(
      franchise_name = paste(.data$franchise_location, .data$franchise_nickname)
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "franchise_id",
        "franchise_name",
        "franchise_abbrev",
        "logo",
        "waiver_order",
        "user_id",
        "user_name",
        "user_nickname"
      ))
    )

  return(teams)
}
