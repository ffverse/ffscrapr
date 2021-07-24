## ff_scoring (ESPN) ##

#' Get a dataframe of scoring settings
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- espn_connect(season = 2020, league_id = 899513)
#'   ff_scoring(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_scoring ESPN: returns scoring settings in a flat table, override positions have their own scoring.
#'
#' @export
ff_scoring.espn_conn <- function(conn) {
  scoring_rules <-
    espn_getendpoint(conn, view = "mSettings") %>%
    purrr::pluck("content", "settings", "scoringSettings", "scoringItems") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::mutate(stat = .espn_stat_map()[as.character(.data$statId)] %>% unname())

  overrides <-
    scoring_rules %>%
    dplyr::mutate(
      override_pos = purrr::map(.data$pointsOverrides, names),
      pos = .espn_pos_map()[as.character(.data$override_pos)] %>% unname(),
      points = purrr::map_dbl(.data$pointsOverrides, purrr::pluck, 1, .default = NA_real_)
    ) %>%
    tidyr::unnest("override_pos") %>%
    dplyr::filter(!is.na(.data$points)) %>%
    dplyr::select(
      "pos",
      "points",
      "stat_id" = "statId",
      "stat_name" = "stat"
    )

  main_stats <-
    scoring_rules %>%
    tidyr::expand_grid(pos = c("QB", "RB", "WR", "TE", "K", "P", "DT", "DE", "LB", "CB", "S", "HC", "DST")) %>%
    dplyr::select(
      "pos",
      "points",
      "stat_id" = "statId",
      "stat_name" = "stat"
    ) %>%
    dplyr::anti_join(overrides, by = "pos", "stat_id") %>%
    dplyr::bind_rows(overrides)

  return(main_stats)
}
