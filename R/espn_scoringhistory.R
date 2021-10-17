## ff_scoringhistory (ESPN) ##

#' Get a dataframe of scoring history, utilizing the ff_scoring and load_player_stats functions.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param season season a numeric vector of seasons (earliest available year is 1999)
#' @param ... other arguments
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- espn_connect(season = 2020, league_id = 899513)
#'   ff_scoringhistory(conn, season = 2020)
#' }) # end try
#' }
#'
#' @describeIn ff_scoringhistory ESPN: returns scoring history in a flat table, one row per player per week.
#'
#' @export
ff_scoringhistory.espn_conn <- function(conn, season = 1999:2020, ...) {
  checkmate::assert_numeric(season, lower = 1999, upper = as.integer(format(Sys.Date(), "%Y")))

  league_rules <-
    ff_scoring(conn) %>%
    dplyr::left_join(
      ffscrapr::nflfastr_stat_mapping %>% dplyr::filter(.data$platform == "espn"),
      by = c("stat_name" = "ff_event")
    )

  ros <- .nflfastr_roster(season)

  ps <- .nflfastr_offense_long(season)

  if("K" %in% league_rules$pos){
    ps <- dplyr::bind_rows(
      ps,
      .nflfastr_kicking_long(season))
  }

  if(any(c("passing25Yards","rushing10Yards","receiving10Yards") %in% league_rules$stat_name)){
    ps <- .espn_threshold_scoring(ps)
  }

  ros %>%
    dplyr::inner_join(ps, by = c("gsis_id"="player_id","season")) %>%
    dplyr::inner_join(league_rules, by = c("metric"="nflfastr_event","pos")) %>%
    dplyr::mutate(points = .data$value * .data$points) %>%
    dplyr::group_by(.data$season, .data$week, .data$gsis_id, .data$sportradar_id) %>%
    dplyr::mutate(points = round(sum(.data$points, na.rm = TRUE), 2)) %>%
    dplyr::ungroup() %>%
    tidyr::pivot_wider(
      id_cols = c("season", "week", "gsis_id", "sportradar_id", "espn_id", "player_name", "pos", "team", "points"),
      names_from = .data$metric,
      values_from = .data$value,
      values_fill = 0,
      values_fn = max
    )

}

.espn_threshold_scoring <- function(ps){

  thresholds <- ps %>%
    dplyr::filter(.data$metric %in% c("passing_yards","rushing_yards","receiving_yards")) %>%
    dplyr::mutate(
      threshold = ifelse(.data$metric == "passing_yards",25,10),
      metric = paste(.data$metric,.data$threshold,sep = "_"),
      value = .data$value %/% .data$threshold,
      threshold = NULL
    )

  dplyr::bind_rows(ps,thresholds)
}
