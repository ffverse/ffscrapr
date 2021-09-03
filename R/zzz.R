#### On Load ####

.ffscrapr_env <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {

  # nocov start

  # Memoise specific functions
  # Timeout lengths still up for discussion

  memoise_option <- getOption("ffscrapr.cache")
  # list of memoise options: "memory", "filesystem","off"

  if (is.null(memoise_option) || !memoise_option %in% c("memory", "filesystem", "off")) {
    memoise_option <- "memory"
  }

  if (memoise_option == "filesystem") {
    cache_dir <- rappdirs::user_cache_dir(appname = "ffscrapr")
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    cache <- cachem::cache_disk(dir = cache_dir)
  }

  if (memoise_option == "memory") {
    cache <- cachem::cache_mem()
  }

  if (memoise_option != "off") {
    dp_values <<- memoise::memoise(dp_values, ~ memoise::timeout(86400), cache = cache)
    dp_playerids <<- memoise::memoise(dp_playerids, ~ memoise::timeout(86400), cache = cache)

    nflfastr_weekly <<- memoise::memoise(nflfastr_weekly, ~ memoise::timeout(604800), cache = cache)
    nflfastr_rosters <<- memoise::memoise(nflfastr_rosters, ~ memoise::timeout(86400), cache = cache)

    .nflfastr_kicking_long <<- memoise::memoise(.nflfastr_kicking_long, ~ memoise::timeout(604800), cache = cache)
    .nflfastr_offense_long <<- memoise::memoise(.nflfastr_offense_long, ~ memoise::timeout(604800), cache = cache)
    .nflfastr_roster <<- memoise::memoise(.nflfastr_roster, ~ memoise::timeout(604800), cache = cache)

    # LONG TERM STORAGE

    mfl_players <<- memoise::memoise(mfl_players, ~ memoise::timeout(604800), cache = cache)
    sleeper_players <<- memoise::memoise(sleeper_players, ~ memoise::timeout(604800), cache = cache)
    fleaflicker_players <<- memoise::memoise(fleaflicker_players, ~ memoise::timeout(604800), cache = cache)
    espn_players <<- memoise::memoise(espn_players, ~ memoise::timeout(604800), cache = cache)

    mfl_allrules <<- memoise::memoise(mfl_allrules, ~ memoise::timeout(604800), cache = cache)

    # MEDIUM TERM STORAGE

    ff_franchises.mfl_conn <<- memoise::memoise(ff_franchises.mfl_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoring.mfl_conn <<- memoise::memoise(ff_scoring.mfl_conn, ~ memoise::timeout(86400), cache = cache)
    ff_league.mfl_conn <<- memoise::memoise(ff_league.mfl_conn, ~ memoise::timeout(86400), cache = cache)
    ff_starters.mfl_conn <<- memoise::memoise(ff_starters.mfl_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoringhistory.mfl_conn <<- memoise::memoise(ff_scoringhistory.mfl_conn, ~ memoise::timeout(86400), cache = cache)

    ff_franchises.sleeper_conn <<- memoise::memoise(ff_franchises.sleeper_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoring.sleeper_conn <<- memoise::memoise(ff_scoring.sleeper_conn, ~ memoise::timeout(86400), cache = cache)
    ff_league.sleeper_conn <<- memoise::memoise(ff_league.sleeper_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoringhistory.sleeper_conn <<- memoise::memoise(ff_scoringhistory.sleeper_conn, ~ memoise::timeout(86400), cache = cache)

    ff_franchises.flea_conn <<- memoise::memoise(ff_franchises.flea_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoring.flea_conn <<- memoise::memoise(ff_scoring.flea_conn, ~ memoise::timeout(86400), cache = cache)
    ff_league.flea_conn <<- memoise::memoise(ff_league.flea_conn, ~ memoise::timeout(86400), cache = cache)
    .flea_potentialpointsweek <<- memoise::memoise(.flea_potentialpointsweek, ~ memoise::timeout(86400), cache = cache)
    ff_scoringhistory.flea_conn <<- memoise::memoise(ff_scoringhistory.flea_conn, ~ memoise::timeout(86400), cache = cache)

    ff_franchises.espn_conn <<- memoise::memoise(ff_franchises.espn_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoring.espn_conn <<- memoise::memoise(ff_scoring.espn_conn, ~ memoise::timeout(86400), cache = cache)
    ff_league.espn_conn <<- memoise::memoise(ff_league.espn_conn, ~ memoise::timeout(86400), cache = cache)
    ff_starters.espn_conn <<- memoise::memoise(ff_starters.espn_conn, ~ memoise::timeout(86400), cache = cache)
    ff_scoringhistory.espn_conn <<- memoise::memoise(ff_scoringhistory.espn_conn, ~ memoise::timeout(86400), cache = cache)

    # SHORT TERM STORAGE

    ff_starters.sleeper_conn <<- memoise::memoise(ff_starters.sleeper_conn, ~ memoise::timeout(3600), cache = cache)
    ff_userleagues.sleeper_conn <<- memoise::memoise(ff_userleagues.sleeper_conn, ~ memoise::timeout(3600), cache = cache)
    ff_schedule.sleeper_conn <<- memoise::memoise(ff_schedule.sleeper_conn, ~ memoise::timeout(3600), cache = cache)
    ff_standings.sleeper_conn <<- memoise::memoise(ff_standings.sleeper_conn, ~ memoise::timeout(3600), cache = cache)

    ff_standings.mfl_conn <<- memoise::memoise(ff_standings.mfl_conn, ~ memoise::timeout(3600), cache = cache)
    ff_playerscores.mfl_conn <<- memoise::memoise(ff_playerscores.mfl_conn, ~ memoise::timeout(3600), cache = cache)
    ff_schedule.mfl_conn <<- memoise::memoise(ff_schedule.mfl_conn, ~ memoise::timeout(3600), cache = cache)
    ff_userleagues.mfl_conn <<- memoise::memoise(ff_userleagues.mfl_conn, ~ memoise::timeout(3600), cache = cache)

    ff_userleagues.flea_conn <<- memoise::memoise(ff_userleagues.flea_conn, ~ memoise::timeout(3600), cache = cache)
    ff_schedule.flea_conn <<- memoise::memoise(ff_schedule.flea_conn, ~ memoise::timeout(3600), cache = cache)
    ff_standings.flea_conn <<- memoise::memoise(ff_standings.flea_conn, ~ memoise::timeout(3600), cache = cache)
    ff_starters.flea_conn <<- memoise::memoise(ff_starters.flea_conn, ~ memoise::timeout(3600), cache = cache)

    ff_standings.espn_conn <<- memoise::memoise(ff_standings.espn_conn, ~ memoise::timeout(3600), cache = cache)
    ff_playerscores.espn_conn <<- memoise::memoise(ff_playerscores.espn_conn, ~ memoise::timeout(3600), cache = cache)
    ff_schedule.espn_conn <<- memoise::memoise(ff_schedule.espn_conn, ~ memoise::timeout(3600), cache = cache)
  }

  # if (memoise_option == "off") packageStartupMessage('Note: ffscrapr.cache is set to "off"')

  user_agent <- glue::glue(
    "ffscrapr/{utils::packageVersion('ffscrapr')} ",
    "API client package ",
    "https://github.com/ffverse/ffscrapr"
  ) %>%
    httr::user_agent()

  # get <-  ratelimitr::limit_rate(.retry_get, ratelimitr::rate(60, 60))
  get.mfl <- ratelimitr::limit_rate(.retry_get, ratelimitr::rate(2, 3))
  get.sleeper <- ratelimitr::limit_rate(.retry_get, ratelimitr::rate(30, 2))
  get.flea <- ratelimitr::limit_rate(.retry_get, ratelimitr::rate(30, 2))
  get.espn <- ratelimitr::limit_rate(.retry_get, ratelimitr::rate(30, 2))
  post <- ratelimitr::limit_rate(.retry_post, ratelimitr::rate(60, 60))


  assign("user_agent", user_agent, envir = .ffscrapr_env)
  assign("get.mfl", get.mfl, envir = .ffscrapr_env)
  assign("get.sleeper", get.sleeper, envir = .ffscrapr_env)
  assign("get.flea", get.flea, envir = .ffscrapr_env)
  assign("get.espn", get.espn, envir = .ffscrapr_env)
  assign("post", post, envir = .ffscrapr_env)

  # nocov end
}

.onAttach <- function(libname, pkgname) {
  memoise_option <- getOption("ffscrapr.cache")

  if (is.null(memoise_option) || !memoise_option %in% c("memory", "filesystem", "off")) {
    memoise_option <- "memory"
  }

  if (memoise_option == "off") packageStartupMessage('Note: ffscrapr.cache is set to "off"')
}
