#### CACHE MANAGEMENT ####

#' Empty Function Cache
#'
#' This function will reset the cache for any and all ffscrapr cached functions.
#'
#' @export
.ffscrapr_clear_cache <- function(){

  functions = list(
    dp_values,
    dp_playerids,
    mfl_players,
    sleeper_players,
    mfl_allrules,
    ff_franchises.mfl_conn,
    ff_scoring.mfl_conn,
    ff_league.mfl_conn,
    ff_starters.mfl_conn,
    ff_standings.mfl_conn,
    ff_playerscores.mfl_conn,
    ff_schedule.mfl_conn,
    ff_userleagues.mfl_conn,
    ff_franchises.sleeper_conn,
    ff_scoring.sleeper_conn,
    ff_league.sleeper_conn,
    ff_userleagues.sleeper_conn,
    ff_schedule.sleeper_conn,
    ff_standings.sleeper_conn,
    ff_starters.sleeper_conn
  )

  purrr::walk(functions,memoise::forget)
}
