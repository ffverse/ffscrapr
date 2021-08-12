## ff_scoring (flea) ##

#' Get a dataframe of scoring settings
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   joe_conn <- ff_connect(platform = "fleaflicker", league_id = 312861, season = 2020)
#'   ff_scoring(joe_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_scoring Fleaflicker: returns scoring settings in a flat table, one row per position per rule.
#'
#' @export
ff_scoring.flea_conn <- function(conn) {
  scoring_rules <- fleaflicker_getendpoint("FetchLeagueRules", league_id = conn$league_id) %>%
    purrr::pluck("content", "groups") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::unnest_longer("scoringRules") %>%
    tidyr::unnest_wider("scoringRules") %>%
    dplyr::filter(!is.na(.data$description)) %>%
    tidyr::hoist("points", "point_value" = "value") %>%
    tidyr::hoist("pointsPer", "points_per_value" = "value") %>%
    tidyr::unnest_wider("category") %>%
    tidyr::unnest_longer("applyTo") %>%
    dplyr::mutate(points = dplyr::coalesce(.data$points_per_value, .data$point_value)) %>%
    dplyr::select(
      dplyr::any_of(c(
        "pos" = "applyTo",
        "event" = "nameSingular",
        "abbrev" = "abbreviation",
        "points",
        "label",
        "desc" = "description",
        "event_id" = "id"
      ))
    )

  return(scoring_rules)
}
