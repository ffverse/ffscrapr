#### On Load ####

.ffscrapr_env <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {

  memoise_option <- getOption("ffscrapr.cache")
  # list of memoise options: "memory", "filesystem","off"

  if (is.null(memoise_option) || !memoise_option %in% c("memory", "filesystem", "off")) {
    memoise_option <- "memory"
  }

  # nocov start
  # not testing filesystem cache or cache off
  if (memoise_option == "filesystem") {
    cache_dir <- rappdirs::user_cache_dir(appname = "ffscrapr")
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    cache <- cachem::cache_disk(dir = cache_dir)
  }
  # nocov end

  if (memoise_option == "memory") cache <- cachem::cache_mem()

  if (memoise_option != "off") {
  # Memoise specific functions
    sapply(
      c("dp_values", "dp_playerids"),
      .cache_fn,
      duration = 86400,
      cache = cache
    )
    # LONG TERM STORAGE
    sapply(
      c(
        "mfl_players",
        "sleeper_players",
        "fleaflicker_players",
        "espn_players",
        "mfl_allrules"
      ),
      .cache_fn,
      duration = 604800,
      cache = cache
    )

    # MEDIUM TERM STORAGE

    sapply(
      c(
        "ff_franchises.mfl_conn",
        "ff_scoring.mfl_conn",
        "ff_league.mfl_conn",
        "ff_starters.mfl_conn",
        "ff_scoringhistory.mfl_conn",

        "ff_franchises.sleeper_conn",
        "ff_scoring.sleeper_conn",
        "ff_league.sleeper_conn",
        "ff_scoringhistory.sleeper_conn",

        "ff_franchises.flea_conn",
        "ff_scoring.flea_conn",
        "ff_league.flea_conn",
        ".flea_potentialpointsweek",
        "ff_scoringhistory.flea_conn",

        "ff_franchises.espn_conn",
        "ff_scoring.espn_conn",
        "ff_league.espn_conn",
        "ff_starters.espn_conn",
        "ff_scoringhistory.espn_conn"
      ),
      .cache_fn,
      duration = 86400,
      cache = cache
    )

    # SHORT TERM STORAGE
    sapply(
      c(
        "ff_starters.sleeper_conn",
        "ff_userleagues.sleeper_conn",
        "ff_schedule.sleeper_conn",
        "ff_standings.sleeper_conn",
        "ff_standings.mfl_conn",
        "ff_playerscores.mfl_conn",
        "ff_schedule.mfl_conn",
        "ff_userleagues.mfl_conn",
        "ff_userleagues.flea_conn",
        "ff_schedule.flea_conn",
        "ff_standings.flea_conn",
        "ff_starters.flea_conn",
        "ff_standings.espn_conn",
        "ff_playerscores.espn_conn",
        "ff_schedule.espn_conn"
      ),
      .cache_fn,
      duration = 3600,
      cache = cache
    )
  }

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
}

.onAttach <- function(libname, pkgname) {
  memoise_option <- getOption("ffscrapr.cache")

  if (is.null(memoise_option) || !memoise_option %in% c("memory", "filesystem", "off")) {
    memoise_option <- "memory"
  }

  if (memoise_option == "off") packageStartupMessage('Note: ffscrapr.cache is set to "off"')
}
