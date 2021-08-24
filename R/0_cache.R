#### CACHE MANAGEMENT ####

#' Empty Function Cache
#'
#' This function will reset the cache for any and all ffscrapr cached functions.
#'
#' @export
.ff_clear_cache <- function() {
  functions <- list(
    dp_values,
    dp_playerids,
    nflfastr_weekly,
    nflfastr_rosters,
    .nflfastr_kicking_long,
    .nflfastr_offense_long,
    .nflfastr_roster,
    mfl_players,
    sleeper_players,
    espn_players,
    mfl_allrules,
    ff_franchises.mfl_conn,
    ff_scoring.mfl_conn,
    ff_league.mfl_conn,
    ff_starters.mfl_conn,
    ff_scoringhistory.mfl_conn,
    ff_standings.mfl_conn,
    ff_playerscores.mfl_conn,
    ff_schedule.mfl_conn,
    ff_userleagues.mfl_conn,
    ff_franchises.sleeper_conn,
    ff_scoring.sleeper_conn,
    ff_league.sleeper_conn,
    ff_scoringhistory.sleeper_conn,
    ff_userleagues.sleeper_conn,
    ff_schedule.sleeper_conn,
    ff_standings.sleeper_conn,
    ff_starters.sleeper_conn,
    ff_franchises.flea_conn,
    ff_scoring.flea_conn,
    ff_league.flea_conn,
    .flea_potentialpointsweek,
    ff_scoringhistory.flea_conn,
    ff_userleagues.flea_conn,
    ff_schedule.flea_conn,
    ff_standings.flea_conn,
    ff_starters.flea_conn,
    ff_franchises.espn_conn,
    ff_scoring.espn_conn,
    ff_league.espn_conn,
    ff_starters.espn_conn,
    ff_scoringhistory.espn_conn,
    ff_standings.espn_conn,
    ff_playerscores.espn_conn,
    ff_schedule.espn_conn
  )

  lapply(functions, memoise::forget)
}
