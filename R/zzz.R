#### On Load ####

.onLoad <- function(libname, pkgname) {

  # nocov start

  # Memoise specific functions
  # Timeout lengths still up for discussion

  memoise_option <- getOption("ffscrapr.cache")
  # list of memoise options: "memory", "filesystem","off"

  if(is.null(memoise_option) || !memoise_option %in% c("memory","filesystem","off")) memoise_option <- "memory"

  if(memoise_option == "filesystem") {

    cache_dir <- rappdirs::user_cache_dir(appname = "ffscrapr")
    dir.create(cache_dir, recursive = TRUE,showWarnings = FALSE)
    cache <- memoise::cache_filesystem(cache_dir)
  }

  if(memoise_option == "memory") {
    cache <- memoise::cache_memory()
  }

  if(memoise_option!="off"){
    dp_values <<- memoise::memoise(dp_values, ~ memoise::timeout(86400), cache = cache)
    dp_playerids <<- memoise::memoise(dp_playerids, ~ memoise::timeout(86400), cache = cache)

    mfl_players <<- memoise::memoise(mfl_players, ~ memoise::timeout(604800), cache = cache)
    sleeper_players <<- memoise::memoise(sleeper_players, ~ memoise::timeout(604800), cache = cache)
    fleaflicker_players <<- memoise::memoise(fleaflicker_players, ~ memoise::timeout(604800), cache = cache)

    mfl_allrules <<- memoise::memoise(mfl_allrules, ~ memoise::timeout(604800), cache = cache)

    ff_franchises.mfl_conn <<- memoise::memoise(ff_franchises.mfl_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoring.mfl_conn <<- memoise::memoise(ff_scoring.mfl_conn, ~ memoise::timeout(86400), cache = cache)
    ff_league.mfl_conn <<- memoise::memoise(ff_league.mfl_conn, ~ memoise::timeout(86400), cache = cache)

    ff_starters.mfl_conn <<- memoise::memoise(ff_starters.mfl_conn, ~ memoise::timeout(86400), cache = cache)
    ff_standings.mfl_conn <<- memoise::memoise(ff_standings.mfl_conn, ~ memoise::timeout(3600), cache = cache)
    ff_playerscores.mfl_conn <<- memoise::memoise(ff_playerscores.mfl_conn, ~memoise::timeout(3600), cache = cache)
    ff_schedule.mfl_conn <<- memoise::memoise(ff_schedule.mfl_conn, ~ memoise::timeout(3600), cache = cache)
    ff_userleagues.mfl_conn <<- memoise::memoise(ff_userleagues.mfl_conn, ~ memoise::timeout(3600), cache = cache)

    ff_franchises.sleeper_conn <<- memoise::memoise(ff_franchises.sleeper_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoring.sleeper_conn <<- memoise::memoise(ff_scoring.sleeper_conn, ~memoise::timeout(86400), cache = cache)
    ff_league.sleeper_conn <<- memoise::memoise(ff_league.sleeper_conn, ~memoise::timeout(86400), cache = cache)

    ff_userleagues.sleeper_conn <<- memoise::memoise(ff_userleagues.sleeper_conn, ~ memoise::timeout(3600), cache = cache)
    ff_schedule.sleeper_conn <<- memoise::memoise(ff_schedule.sleeper_conn, ~ memoise::timeout(3600), cache = cache)
    ff_standings.sleeper_conn <<- memoise::memoise(ff_standings.sleeper_conn, ~ memoise::timeout(3600), cache = cache)
    ff_starters.sleeper_conn <<- memoise::memoise(ff_starters.sleeper_conn, ~ memoise::timeout(3600), cache = cache)


    ff_franchises.flea_conn <<- memoise::memoise(ff_franchises.flea_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoring.flea_conn <<- memoise::memoise(ff_scoring.flea_conn, ~memoise::timeout(86400), cache = cache)
    # ff_league.sleeper_conn <<- memoise::memoise(ff_league.sleeper_conn, ~memoise::timeout(86400), cache = cache)
    .flea_potentialpointsweek <<- memoise::memoise(.flea_potentialpointsweek, ~memoise::timeout(86400), cache = cache)

    ff_userleagues.flea_conn <<- memoise::memoise(ff_userleagues.flea_conn, ~ memoise::timeout(3600), cache = cache)
    ff_schedule.flea_conn <<- memoise::memoise(ff_schedule.flea_conn, ~ memoise::timeout(3600), cache = cache)
    ff_standings.flea_conn <<- memoise::memoise(ff_standings.flea_conn, ~ memoise::timeout(3600), cache = cache)
  }

  env <- rlang::env(
    user_agent = glue::glue(
      "ffscrapr/{utils::packageVersion('ffscrapr')} API client package",
      " https://github.com/dynastyprocess/ffscrapr"
    ) %>%
      httr::user_agent(),
    get = ratelimitr::limit_rate(httr::GET, ratelimitr::rate(60, 60)),
    get.mfl = ratelimitr::limit_rate(httr::GET, ratelimitr::rate(2, 3)),
    get.sleeper = ratelimitr::limit_rate(httr::GET, ratelimitr::rate(30, 2)),
    get.flea = ratelimitr::limit_rate(httr::GET, ratelimitr::rate(30, 2)),
    post = ratelimitr::limit_rate(httr::POST, ratelimitr::rate(60, 60))
  )

  assign(".ffscrapr_env", env, envir = baseenv())

  # nocov end
}
