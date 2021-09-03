#### ff_standings (Sleeper) ####

#' Get a dataframe of league standings
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... arguments passed to other methods (currently none)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_standings(jml_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_standings Sleeper: returns all standings and points data and manually calculates allplay results.
#'
#' @export
ff_standings.sleeper_conn <- function(conn, ...) {
  franchise_names <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  rosters_standings <- sleeper_getendpoint(glue::glue("league/{conn$league_id}/rosters")) %>%
    purrr::pluck("content") %>%
    purrr::map(`[`, "settings") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::hoist(
      1,
      "h2h_wins" = "wins",
      "h2h_losses" = "losses",
      "h2h_ties" = "ties",
      "points_for" = "fpts",
      "pf_dec" = "fpts_decimal",
      "points_against" = "fpts_against",
      "pa_dec" = "fpts_against_decimal",
      "potential_points" = "ppts",
      "pp_dec" = "ppts_decimal"
    ) %>%
    dplyr::mutate_if(is.numeric, tidyr::replace_na, 0) %>%
    dplyr::mutate(
      franchise_id = seq_along(.data$h2h_wins),
      h2h_winpct = .data$h2h_wins / (.data$h2h_wins + .data$h2h_losses + .data$h2h_ties),
      points_for = as.numeric(paste0(.data$points_for, ".", .data$pf_dec)),
      points_against = as.numeric(paste0(.data$points_against, ".", .data$pa_dec)),
      potential_points = as.numeric(paste0(.data$potential_points, ".", .data$pp_dec))
    ) %>%
    dplyr::select(
      "franchise_id",
      "h2h_wins", "h2h_losses", "h2h_ties", "h2h_winpct",
      "points_for", "points_against", "potential_points"
    )

  allplay <- ff_schedule(conn) %>%
    .add_allplay()

  standings <- franchise_names %>%
    dplyr::left_join(rosters_standings, by = "franchise_id") %>%
    dplyr::left_join(allplay, by = "franchise_id")

  return(standings)
}
