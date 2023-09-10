.nflverse_player_stats_long <- function(season){
  ps <- nflreadr::load_player_stats(season = season, stat_type = "offense") %>%
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

.nflverse_kicking_long <- function(season){
  psk <- nflreadr::load_player_stats(season = season, stat_type = "kicking") %>%
    dplyr::select(
      dplyr::any_of(c(
        "season","week","player_id",
        "fg_att", "fg_blocked",
        "fg_made", "fg_made_0_19", "fg_made_20_29", "fg_made_30_39",
        "fg_made_40_49", "fg_made_50_59", "fg_made_60_", "fg_made_distance",
        "fg_missed", "fg_missed_0_19", "fg_missed_20_29", "fg_missed_30_39",
        "fg_missed_40_49", "fg_missed_50_59", "fg_missed_60_", "fg_missed_distance",
        "fg_pct","pat_att", "pat_blocked", "pat_made",
        "pat_missed", "pat_pct"
      ))
    ) %>%
    tidyr::pivot_longer(
      names_to = "metric",
      cols = -c("season","week","player_id")
    )
  return(psk)
}

.nflverse_roster <- function(season){
  ros <- nflreadr::load_rosters(season) %>%
    dplyr::mutate(position = ifelse(.data$position %in% c("HB", "FB"), "RB", .data$position)) %>%
    dplyr::select(
      dplyr::any_of(c(
        "season","gsis_id","sportradar_id",
        "player_name"="full_name","pos"="position","team"
      ))
    ) %>%
    dplyr::group_by(season, gsis_id, sportradar_id) %>%
    dplyr::summarise(
      dplyr::across(dplyr::everything(), dplyr::last),
      .groups="drop"
    ) %>%
    dplyr::left_join(
      dp_playerids() %>%
        dplyr::select("sportradar_id","mfl_id","sleeper_id","espn_id","fleaflicker_id"),
      by = c("sportradar_id"),
      na_matches = "never"
    )

  return(ros)
}
