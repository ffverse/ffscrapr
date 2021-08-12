## ff_scoring (Sleeper) ##

#' Get a dataframe of scoring settings
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_scoring(jml_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_scoring Sleeper: returns scoring settings in a flat table, one row per position per rule.
#'
#' @export
ff_scoring.sleeper_conn <- function(conn) {
  scoring_rules <-
    glue::glue("league/{conn$league_id}") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content", "scoring_settings") %>%
    tibble::enframe(name = "event", value = "points") %>%
    dplyr::mutate(points = as.numeric(.data$points) %>% round(3)) %>%
    # Look in data-raw `DATASET` script to change the sleeper rule mappings
    dplyr::inner_join(sleeper_rule_mapping, by = "event") %>%
    dplyr::select("pos", "event", "points")

  return(scoring_rules)
}
