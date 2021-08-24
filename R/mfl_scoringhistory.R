## ff_scoringhistory (MFL) ##

#' Get a dataframe of scoring history, utilizing the ff_scoring and load_player_stats functions.
#'
#' @param conn a conn object created by `ff_connect()`
#' @param season season a numeric vector of seasons (earliest available year is 1999)
#' @param ... other arguments
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   ssb_conn <- ff_connect(platform = "mfl", league_id = 54040, season = 2020)
#'   ff_scoringhistory(ssb_conn, season = 2020)
#' }) # end try
#' }
#'
#' @describeIn ff_scoringhistory MFL: returns scoring history in a flat table, one row per player per week.
#'
#' @export
ff_scoringhistory.mfl_conn <- function(conn, season = 1999:2020, ...) {
  checkmate::assert_numeric(season, lower = 1999, upper = as.integer(format(Sys.Date(), "%Y")))

  # Pull in scoring rules for that league
  league_rules <-
    ff_scoring(conn) %>%
    tidyr::separate(
      col = "range",
      into = c("lower_range", "upper_range"),
      sep = "-(?=[0-9,\\.]*$)"
    ) %>%
    dplyr::mutate(dplyr::across(
      .cols = c("lower_range", "upper_range"),
      .fns = as.numeric
    )) %>%
    dplyr::left_join(
      ffscrapr::nflfastr_stat_mapping %>% dplyr::filter(.data$platform == "mfl"),
      by = c("event" = "ff_event")
    ) %>%
    dplyr::select(
      "pos", "points", "lower_range", "upper_range", "event", "points_type", "nflfastr_event", "short_desc"
    )

  ros <- .nflfastr_roster(season) %>%
    dplyr::mutate(pos = replace(.data$pos,.data$pos=="K","PK"))

  ps <- .nflfastr_offense_long(season)

  if("PK" %in% league_rules$pos){
    ps <- dplyr::bind_rows(
      ps,
      .nflfastr_kicking_long(season))
  }

  fastr_weekly <- ros %>%
    dplyr::inner_join(ps, by = c("gsis_id"="player_id","season")) %>%
    dplyr::inner_join(league_rules, by = c("metric"="nflfastr_event","pos")) %>%
    dplyr::filter(.data$value >= .data$lower_range, .data$value <= .data$upper_range) %>%
    dplyr::mutate(
      value = dplyr::case_when(.data$points_type == "once" ~ 1, TRUE ~ .data$value),
      points = .data$value * .data$points
    ) %>%
    dplyr::group_by(.data$season, .data$week, .data$gsis_id, .data$sportradar_id) %>%
    dplyr::mutate(points = round(sum(.data$points, na.rm = TRUE), 2)) %>%
    dplyr::ungroup() %>%
    tidyr::pivot_wider(
      id_cols = c("season", "week", "gsis_id", "sportradar_id",
                  "mfl_id", "player_name", "pos", "team", "points"),
      names_from = .data$metric,
      values_from = .data$value,
      values_fill = 0,
      values_fn = max
    )

  return(fastr_weekly)
}
