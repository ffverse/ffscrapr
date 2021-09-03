#### NFLFASTR IMPORT ####

#' Import latest nflfastr weekly stats
#'
#' Fetches a copy of the latest week-level stats from nflfastr's data repository, via the [nflreadr](https://nflreadr.nflverse.com) package.
#'
#' The goal of this data is to replicate the NFL's official weekly stats, which
#' can diverge a bit from what fantasy data feeds display.
#'
#' If you have any issues with the output of this data, please open an issue in
#' the nflfastr repository.
#'
#' @param seasons The seasons to return, TRUE returns all data available.
#' @param type One of "offense" or "kicking"
#'
#' @seealso <https://nflreadr.nflverse.com>
#'
#' @examples
#' \donttest{
#' try( # try only shown here because sometimes CRAN checks are weird
#'   nflfastr_weekly()
#' )
#' }
#'
#' @return Weekly stats for all passers, rushers and receivers in the nflverse play-by-play data from the 1999 season to the most recent season
#'
#' @export
nflfastr_weekly <- function(seasons = TRUE,
                            type = c("offense", "kicking")) {

  type <- match.arg(type)

  df_weekly <- nflreadr::load_player_stats(seasons = seasons, stat_type = type)

  return(df_weekly)
}

#' Import nflfastr roster data
#'
#' Fetches a copy of roster data from nflfastr's data repository.
#' The same input/output as nflfastr's fast_scraper_roster function.
#'
#' If you have any issues with the output of this data, please open an issue in
#' the nflfastr repository.
#'
#' @param seasons A numeric vector of seasons, earliest of which is 1999. TRUE returns all seasons, NULL returns latest season.
#'
#' @seealso <https://nflreadr.nflverse.com>
#'
#' @examples
#' \donttest{
#' try( # try only shown here because sometimes CRAN checks are weird
#'   nflfastr_rosters(seasons = 2019:2020)
#' )
#' }
#'
#' @return Data frame where each individual row represents a player in the roster of the given team and season
#'
#' @export

nflfastr_rosters <- function(seasons) {
  df_rosters <- nflreadr::load_rosters(seasons = seasons)

  return(df_rosters)
}

.nflfastr_offense_long <- function(season){
  ps <- nflfastr_weekly(seasons = season, type = "offense") %>%
    dplyr::select(dplyr::any_of(c(
      "season", "week","player_id",
      "attempts", "carries", "completions", "interceptions", "passing_2pt_conversions", "passing_first_downs",
      "passing_tds", "passing_yards", "receiving_2pt_conversions", "receiving_first_downs",
      "receiving_fumbles", "receiving_fumbles_lost", "receiving_tds",
      "receiving_yards", "receptions", "rushing_2pt_conversions", "rushing_first_downs",
      "rushing_fumbles", "rushing_fumbles_lost", "rushing_tds", "rushing_yards",
      "sack_fumbles", "sack_fumbles_lost", "sack_yards", "sacks", "special_teams_tds",
      "targets")
    )) %>%
    tidyr::pivot_longer(
      names_to = "metric",
      cols = -c("season","week","player_id")
    )

  return(ps)
}

.nflfastr_kicking_long <- function(season){
  psk <- nflfastr_weekly(seasons = season, type = "kicking") %>%
    dplyr::select(dplyr::any_of(c(
      "season","week","player_id",
      "fg_att", "fg_blocked",
      "fg_made", "fg_made_0_19", "fg_made_20_29", "fg_made_30_39",
      "fg_made_40_49", "fg_made_50_59", "fg_made_60_", "fg_made_distance",
      "fg_missed", "fg_missed_0_19", "fg_missed_20_29", "fg_missed_30_39",
      "fg_missed_40_49", "fg_missed_50_59", "fg_missed_60_", "fg_missed_distance",
      "fg_pct","pat_att", "pat_blocked", "pat_made",
      "pat_missed", "pat_pct"
    ))) %>%
    tidyr::pivot_longer(
      names_to = "metric",
      cols = -c("season","week","player_id")
    )
  return(psk)
}

.nflfastr_roster <- function(season){
  ros <- nflfastr_rosters(season) %>%
    dplyr::mutate(position = ifelse(.data$position %in% c("HB", "FB"), "RB", .data$position)) %>%
    dplyr::select(dplyr::any_of(c(
      "season","gsis_id","sportradar_id",
      "player_name"="full_name","pos"="position","team"
    ))) %>%
    dplyr::left_join(
      dp_playerids() %>%
        dplyr::select("sportradar_id","mfl_id","sleeper_id","espn_id","fleaflicker_id"),
      by = c("sportradar_id"),
      na_matches = "never"
    )

  return(ros)
}
