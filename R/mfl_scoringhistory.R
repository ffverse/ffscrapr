## ff_scoringhistory (MFL) ##

#' Get a dataframe of scoring history, utilizing the ff_scoring and load_player_stats functions.
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param season the season of interest back to 1999
#' @param ... other arguments
#'
#' @examples
#' \donttest{
# ssb_conn <- ff_connect(platform = "mfl", league_id = 54040, season = 2020)
# ff_scoringhistory(ssb_conn)
#' }
#'
#' @seealso \url{http://www03.myfantasyleague.com/2020/scoring_rules#rules}
#'
#' @describeIn ff_scoringhistory MFL: returns scoring history in a flat table, one row per player per week.
#'
#' @export
ff_scoringhistory.mfl_conn <- function(conn, season, ...) {

  #Pull in scoring rules for that league
  league_rules <-
    ff_scoring(conn) %>%
    tidyr::separate(col = range,
                    into = c("lower_range","upper_range"),
                    sep = "-(?=[0-9]*$)") %>%
    dplyr::mutate(dplyr::across(.cols = c(lower_range, upper_range),
                                .fns = as.numeric))

  #Pull Rosters from nflfastr to get positions
  fastr_rosters <-
    nflfastR::fast_scraper_roster(season) %>%
    dplyr::mutate(position = dplyr::if_else(position == "FB", "RB", position))

  #Load stats from nflfastr and map the rules from the internal stat_mapping file
  fastr_games <-
    nflfastR::load_player_stats() %>%
    dplyr::inner_join(fastr_rosters, by = c("player_id" = "gsis_id", "season" = "season")) %>%
    tidyr::pivot_longer(names_to = "metric",
                        cols = c(completions, attempts, passing_yards, passing_tds, interceptions, sacks, sack_fumbles_lost,
                                 passing_first_downs, passing_2pt_conversions, carries, rushing_yards, rushing_tds,
                                 rushing_fumbles_lost, rushing_first_downs, rushing_2pt_conversions, receptions, targets,
                                 receiving_yards, receiving_tds, receiving_fumbles_lost, receiving_first_downs,
                                 receiving_2pt_conversions, special_teams_tds)) %>%
    dplyr::inner_join(stat_mapping, by = c("metric" = "nflfastr_event")) %>%
    dplyr::inner_join(league_rules, by = c("mfl_event" = "event", "position" = "pos")) %>%
    dplyr::filter(value >= lower_range, value <= upper_range) %>%
    dplyr::mutate(points = value*points) %>%
    dplyr::group_by(season, week, sportradar_id) %>%
    dplyr::mutate(points = round(sum(points, na.rm = TRUE),2)) %>%
    dplyr::ungroup() %>%
    dplyr::left_join(ffscrapr::dp_playerids() %>% dplyr::select(sportradar_id, mfl_id), by = "sportradar_id") %>%
    dplyr::select(season, week, player_id = mfl_id, player_name, pos = position, team = recent_team,
                  metric, value, points) %>%
    tidyr::pivot_wider(id_cols = c(season, week, player_id, player_name, pos, team, points),
                       names_from = metric,
                       values_from = value,
                       values_fill = 0,
                       values_fn = max)
}
