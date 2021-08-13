#### ff_franchises (Sleeper) ####

#' Get a dataframe of franchise information
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_franchises(jml_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_franchises Sleeper: retrieves a list of franchise information, including user IDs and co-owner IDs.
#'
#' @export
ff_franchises.sleeper_conn <- function(conn) {
  rosters_endpoint <- glue::glue("league/{conn$league_id}/rosters")

  users_endpoint <- glue::glue("league/{conn$league_id}/users")

  rosters_response <- sleeper_getendpoint(rosters_endpoint) %>%
    purrr::pluck("content") %>%
    purrr::map(`[`, c("roster_id", "owner_id", "co_owners")) %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1)

  users_response <- sleeper_getendpoint(users_endpoint) %>%
    purrr::pluck("content") %>%
    purrr::map(`[`, c("user_id", "display_name", "metadata")) %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::hoist("metadata", "franchise_name" = "team_name") %>%
    dplyr::mutate(franchise_name = dplyr::coalesce(.data$franchise_name, .data$display_name)) %>%
    dplyr::select(dplyr::any_of(c("user_id", "franchise_name", "avatar_id", "user_name" = "display_name")))

  df_ownerlist <- rosters_response %>%
    dplyr::left_join(users_response, by = c("owner_id" = "user_id")) %>%
    dplyr::select(
      "franchise_id" = .data$roster_id,
      dplyr::any_of(c("franchise_name", "user_name", "user_id" = "owner_id", "co_owners"))
    )

  return(df_ownerlist)
}
