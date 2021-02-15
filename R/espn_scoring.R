## ff_scoring (ESPN) ##

#' Get a dataframe of scoring settings
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @examples
#' \donttest{
#' conn <- espn_connect(season = 2020, league_id = 899513)
#' ff_scoring(conn)
#' }
#'
#' @describeIn ff_scoring ESPN: returns scoring settings in a flat table, override positions have their own scoring.
#'
#' @export
ff_scoring.espn_conn <- function(conn) {

  scoring_rules <- espn_getendpoint(conn,view = "mSettings") %>%
    purrr::pluck("content","settings","scoringSettings","scoringItems") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::mutate(stat = .espn_stat_map()[as.character(.data$statId)] %>% unname())

  overrides <- scoring_rules %>%
    dplyr::mutate(
      override_pos = purrr::map(.data$pointsOverrides,names),
      points = purrr::map_dbl(.data$pointsOverrides,purrr::pluck,1,.default = NA_real_)
    ) %>%
    tidyr::unnest("override_pos") %>%
    dplyr::filter(!is.na(.data$points)) %>%
    dplyr::select(
      "stat_id" = "statId",
      "stat_name" = "stat",
      "override_pos",
      "points"
    )

  main_stats <- scoring_rules %>%
    dplyr::select('stat_id' = 'statId',
                  'stat_name' = 'stat',
                  'points') %>%
    dplyr::bind_rows(overrides)

  return(main_stats)
}
