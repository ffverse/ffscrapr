#### Helpers ####
## Internal code written for re-use

#' Choose current season
#'
#' A helper function to return the current year if March or later, otherwise assume previous year
#'
#' @noRd
#' @keywords internal

.fn_choose_season <- function(date = NULL) {
  if (is.null(date)) {
    date <- Sys.Date()
  }

  if (class(date) != "Date") {
    date <- as.Date(date)
  }

  if (as.numeric(format(date, "%m")) > 2) {
    return(format(date, "%Y"))
  }

  return(format(date - 365.25, "%Y"))
}

#' Set rate limit
#'
#' A helper function that creates a new copy of the httr::GET function and stores it
#' in the .ffscrapr_env hidden object
#'
#' @param toggle a logical to turn on rate_limiting if TRUE and off if FALSE
#' @param rate_number number of calls per \code{rate_seconds}
#' @param rate_seconds number of seconds
#'
#' @noRd
#' @keywords internal

.fn_set_ratelimit <- function(toggle = TRUE, rate_number, rate_seconds) {
  if (toggle) {
    fn_get <- ratelimitr::limit_rate(httr::GET, ratelimitr::rate(rate_number, rate_seconds))
    fn_post <- ratelimitr::limit_rate(httr::POST, ratelimitr::rate(rate_number, rate_seconds))
  }

  if (!toggle) {
    fn_get <- httr::GET
    fn_post <- httr::POST
  }

  assign("get", fn_get, envir = .ffscrapr_env)
  assign("post", fn_post, envir = .ffscrapr_env)

  invisible(list(get = fn_get, post = fn_post))
}

#' Set user agent
#'
#' Self-identifying is mostly about being polite, although MFL has a program to give verified clients more bandwidth!
#' See: https://www03.myfantasyleague.com/2020/csetup?C=APICLI
#'
#' @noRd
#' @keywords internal

.fn_set_useragent <- function(user_agent) {
  user_agent <- httr::user_agent(user_agent)
  assign("user_agent", user_agent, envir = .ffscrapr_env)

  invisible(user_agent)
}

#' Drop nulls from a list/vector
#' @keywords internal
#' @noRd
.fn_drop_nulls <- function (x)
{
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}
