#### On Load ####

.onLoad <- function(libname, pkgname) {

  # nocov start
  # Memoise specific functions
  # Timeout lengths still up for discussion

  dp_values <<- memoise::memoise(dp_values, ~ memoise::timeout(86400))
  dp_playerids <<- memoise::memoise(dp_playerids, ~ memoise::timeout(86400))

  mfl_players <<- memoise::memoise(mfl_players, ~ memoise::timeout(86400))
  mfl_allrules <<- memoise::memoise(mfl_allrules, ~ memoise::timeout(86400))

  ff_userleagues.mfl_conn <<- memoise::memoise(ff_userleagues.mfl_conn, ~ memoise::timeout(3600))
  ff_franchises.mfl_conn <<- memoise::memoise(ff_franchises.mfl_conn, ~ memoise::timeout(86400))
  ff_scoring.mfl_conn <<- memoise::memoise(ff_scoring.mfl_conn, ~ memoise::timeout(3600))
  ff_standings.mfl_conn <<- memoise::memoise(ff_standings.mfl_conn, ~ memoise::timeout(3600))
  ff_schedule.mfl_conn <<- memoise::memoise(ff_schedule.mfl_conn, ~ memoise::timeout(3600))

  sleeper_players <<- memoise::memoise(sleeper_players, ~ memoise::timeout(86400))

  ff_userleagues.sleeper_conn <<- memoise::memoise(ff_userleagues.sleeper_conn, ~ memoise::timeout(3600))
  ff_franchises.sleeper_conn <<- memoise::memoise(ff_franchises.sleeper_conn, ~ memoise::timeout(86400))
  ff_schedule.sleeper_conn <<- memoise::memoise(ff_schedule.sleeper_conn, ~ memoise::timeout(3600))
  ff_standings.sleeper_conn <<- memoise::memoise(ff_standings.sleeper_conn, ~ memoise::timeout(3600))

  env <- rlang::env(
    user_agent = glue::glue(
      "ffscrapr/{utils::packageVersion('ffscrapr')} API client package",
      " https://github.com/dynastyprocess/ffscrapr"
    ) %>%
      httr::user_agent(),
    get = ratelimitr::limit_rate(httr::GET, ratelimitr::rate(60, 60)),
    get.mfl = ratelimitr::limit_rate(httr::GET, ratelimitr::rate(2, 3)),
    get.sleeper = ratelimitr::limit_rate(httr::GET, ratelimitr::rate(30, 2)),
    post = ratelimitr::limit_rate(httr::POST, ratelimitr::rate(60, 60))
  )

  assign(".ffscrapr_env", env, envir = baseenv())

  # nocov end
}
