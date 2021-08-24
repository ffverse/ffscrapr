## ff_scoringhistory (sleeper) ##

#' Get a dataframe of scoring history, utilizing the ff_scoring and load_player_stats functions.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param season season a numeric vector of seasons (earliest available year is 1999)
#' @param ... other arguments
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_scoringhistory(conn, season = 2020)
#' }) # end try
#' }
#'
#' @describeIn ff_scoringhistory Sleeper: returns scoring history in a flat table, one row per player per week.
#'
#' @export
ff_scoringhistory.sleeper_conn <- function(conn, season = 1999:2020, ...) {
  checkmate::assert_numeric(season, lower = 1999, upper = as.integer(format(Sys.Date(), "%Y")))

  # Pull in scoring rules for that league
  league_rules <-
    ff_scoring(conn) %>%
    dplyr::left_join(
      ffscrapr::nflfastr_stat_mapping %>% dplyr::filter(.data$platform == "sleeper"),
      by = c("event" = "ff_event")
    )

  ros <- .nflfastr_roster(season)

  ps <- .nflfastr_offense_long(season)

  if("K" %in% league_rules$pos){
    ps <- dplyr::bind_rows(
      ps,
      .nflfastr_kicking_long(season))
  }

  ros %>%
    dplyr::inner_join(ps, by = c("gsis_id"="player_id","season")) %>%
    dplyr::inner_join(league_rules, by = c("metric"="nflfastr_event","pos")) %>%
    dplyr::mutate(points = .data$value * .data$points) %>%
    dplyr::group_by(.data$season, .data$week, .data$gsis_id, .data$sportradar_id) %>%
    dplyr::mutate(points = round(sum(.data$points, na.rm = TRUE), 2)) %>%
    dplyr::ungroup() %>%
    tidyr::pivot_wider(
      id_cols = c("season", "week", "gsis_id", "sportradar_id", "sleeper_id", "player_name", "pos", "team", "points"),
      names_from = .data$metric,
      values_from = .data$value,
      values_fill = 0,
      values_fn = max
    )
}
