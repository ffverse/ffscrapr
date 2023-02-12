#### Helpers ####
## Internal code written for re-use

#' Choose current season
#'
#' A helper function to return the current year if March or later, otherwise assume previous year
#'
#' @keywords internal

.fn_choose_season <- function(date = NULL) {
  if (is.null(date)) {
    date <- Sys.Date()
  }

  if (!inherits(date, "Date")) {
    date <- as.Date(date)
  }

  if (as.numeric(format(date, "%m")) > 2) {
    return(format(date, "%Y"))
  }

  return(format(date - 365.25, "%Y"))
}

#' Create RETRY version of GET
#'
#' This wrapper on httr retries the httr::GET function based on best-practice heuristics
#'
#' @param ... arguments passed to `httr::GET`
#'
#' @keywords internal
.retry_get <- function(...) {
  httr::RETRY("GET", ...)
}

#' Create RETRY version of POST
#'
#' This wrapper on httr retries the httr::POST function based on best-practice heuristics.
#'
#' @param ... arguments passed to `httr::POST`
#'
#' @keywords internal
.retry_post <- function(...) {
  httr::RETRY("POST", ...)
}

#' Set rate limit
#'
#' A helper function that creates a new copy of the httr::GET function and stores it
#' in the .ffscrapr_env hidden object
#'
#' @param toggle a logical to turn on rate_limiting if TRUE and off if FALSE
#' @param rate_number number of calls per `rate_seconds`
#' @param rate_seconds number of seconds
#'
#' @keywords internal

.fn_set_ratelimit <- function(toggle = TRUE, platform, rate_number, rate_seconds) {
  if (toggle) {
    fn_get <- ratelimitr::limit_rate(.retry_get, ratelimitr::rate(rate_number, rate_seconds))
    fn_post <- ratelimitr::limit_rate(.retry_post, ratelimitr::rate(rate_number, rate_seconds))
  }

  if (!toggle) {
    fn_get <- .retry_get
    fn_post <- .retry_post
  }

  if (platform == "mfl") {
    assign("get.mfl", fn_get, envir = .ffscrapr_env)
    assign("post.mfl", fn_post, envir = .ffscrapr_env)
  }

  if (platform == "sleeper") {
    assign("get.sleeper", fn_get, envir = .ffscrapr_env)
    assign("post.sleeper", fn_post, envir = .ffscrapr_env)
  }

  if (platform == "fleaflicker") {
    assign("get.sleeper", fn_get, envir = .ffscrapr_env)
    assign("post.sleeper", fn_post, envir = .ffscrapr_env)
  }

  if (platform == "espn") {
    assign("get.sleeper", fn_get, envir = .ffscrapr_env)
    assign("post.sleeper", fn_post, envir = .ffscrapr_env)
  }

  invisible(list(get = fn_get, post = fn_post))
}

#' Set user agent
#'
#' Self-identifying is mostly about being polite, although MFL has a program to give verified clients more bandwidth!
#' See: https://www03.myfantasyleague.com/2020/csetup?C=APICLI
#'
#' @keywords internal

.fn_set_useragent <- function(user_agent) {
  user_agent <- httr::user_agent(user_agent)
  assign("user_agent", user_agent, envir = .ffscrapr_env)

  invisible(user_agent)
}

#' Drop nulls from a list/vector
#' @keywords internal
.fn_drop_nulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}

#' Add allplay from a standardised schedule output
#'
#' @param schedule - an output from ff_schedule
#'
#' @keywords internal
.add_allplay <- function(schedule) {
  all_play <- schedule %>%
    dplyr::filter(!is.na(.data$result)) %>%
    dplyr::group_by(.data$week) %>%
    dplyr::mutate(
      allplay_wins = rank(.data$franchise_score, ) - 1,
      allplay_losses = dplyr::n() - 1 - .data$allplay_wins
    ) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(.data$franchise_id) %>%
    dplyr::summarise(
      allplay_wins = sum(c(.data$allplay_wins, 0), na.rm = TRUE),
      allplay_losses = sum(c(.data$allplay_losses, 0), na.rm = TRUE),
      allplay_winpct = (.data$allplay_wins / (.data$allplay_wins + .data$allplay_losses)) %>% round(3)
    )
  return(all_play)
}

#' Add unescaped cookies
#'
#' Useful for ESPN which is already URL escaped
#'
#' @param ... a named cookie values
#'
#' @seealso `httr::set_cookies`
#'
#' @keywords internal

set_unescaped_cookies <- function(...) {
  cookies <- c(...)

  cookie <- paste(names(cookies), cookies, sep = "=", collapse = ";")

  httr::config(cookie = cookie)
}

#' Release questions
#'
#' @keywords internal
#'
release_bullets <- function() {

  # nocov start

  c(
    "Tag the current version of ffscrapr-tests as a release version",
    'Switch all vignettes and tests to use "ffscrapr-tests-v1.x.x" and download "archive/v1.x.x"'
  )

  # nocov end
}

#' Mappings for nflfastr to fantasy platform scoring
#'
#' A small helper dataframe for connecting nflfastr to specific fantasy platform rules.
#'
#' @format A data frame with ~85 rows and 3 variables:
#' \describe{
#'   \item{nflfastr_event}{the column name of the statistic in the nflfastr_weekly dataset}
#'   \item{platform}{specific platform that this mapping applies to}
#'   \item{ff_event}{name of the statistic for that platform}
#' }
#'
"nflfastr_stat_mapping"
