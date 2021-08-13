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

  # Pull in scoring rules for that league
  league_rules <-
    ff_scoring(conn) %>%
    dplyr::left_join(
      ffscrapr::nflfastr_stat_mapping %>% dplyr::filter(.data$platform == "espn"),
      by = c("stat_name" = "ff_event")
    )

  # Use custom ffscrapr function to get positions fron nflfastR rosters
  fastr_rosters <-
    nflfastr_rosters(season) %>%
    dplyr::mutate(position = dplyr::if_else(.data$position %in% c("HB", "FB"), "RB", .data$position))

  # Load stats from nflfastr and map the rules from the internal stat_mapping file
  nflfastr_weekly(seasons = season) %>%
    dplyr::inner_join(fastr_rosters, by = c("player_id" = "gsis_id", "season" = "season")) %>%
    tidyr::pivot_longer(
      names_to = "metric",
      cols = c(
        "completions", "attempts", "passing_yards", "passing_tds", "interceptions", "sacks",
        "sack_fumbles_lost", "passing_first_downs", "passing_2pt_conversions", "carries",
        "rushing_yards", "rushing_tds", "rushing_fumbles_lost", "rushing_first_downs",
        "rushing_2pt_conversions", "receptions", "targets", "receiving_yards", "receiving_tds",
        "receiving_fumbles_lost", "receiving_first_downs", "receiving_2pt_conversions",
        "special_teams_tds"
      )
    ) %>%
    dplyr::inner_join(league_rules, by = c("metric" = "nflfastr_event", "position" = "pos")) %>%
    dplyr::mutate(points = .data$value * .data$points) %>%
    dplyr::group_by(.data$season, .data$week, .data$player_id, .data$sportradar_id) %>%
    dplyr::mutate(points = round(sum(.data$points, na.rm = TRUE), 2)) %>%
    dplyr::ungroup() %>%
    dplyr::select("season", "week",
      "gsis_id" = "player_id", "sportradar_id", "espn_id", "player_name", "pos" = "position",
      "team" = "recent_team", "metric", "value", "points"
    ) %>%
    tidyr::pivot_wider(
      id_cols = c("season", "week", "gsis_id", "sportradar_id", "espn_id", "player_name", "pos", "team", "points"),
      names_from = .data$metric,
      values_from = .data$value,
      values_fill = 0,
      values_fn = max
    )
}
