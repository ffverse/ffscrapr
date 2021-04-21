#' Connect to Fleaflicker League
#'
#' This function creates a connection object which stores parameters and a user ID if available.
#'
#' @param season Season to access on Fleaflicker - if missing, will guess based on system date (current year if March or later, otherwise previous year)
#' @param league_id League ID
#' @param user_email Optional - attempts to get user's user ID by email
#' @param user_agent User agent to self-identify (optional)
#' @param rate_limit TRUE by default - turn off rate limiting with FALSE
#' @param rate_limit_number number of calls per `rate_limit_seconds`, suggested is under 1000 calls per 60 seconds
#' @param rate_limit_seconds number of seconds as denominator for rate_limit
#' @param ... other arguments (for other methods, for R compat)
#'
#' @export
#'
#' @return a list that stores Fleaflicker connection objects

fleaflicker_connect <- function(season = NULL,
                                league_id = NULL,
                                user_email = NULL,
                                user_agent = NULL,
                                rate_limit = TRUE,
                                rate_limit_number = NULL,
                                rate_limit_seconds = NULL,
                                ...) {
  # nocov start

  ## USER AGENT ##
  # Self-identifying is mostly about being polite.
  if (length(user_agent) > 1) stop("user_agent must be a character vector of length one!")
  if (!is.null(user_agent)) .fn_set_useragent(user_agent)

  ## RATE LIMIT ##
  # For more info, see: https://api.myfantasyleague.com/2020/api_info

  if (!is.logical(rate_limit)) stop("rate_limit should be logical")
  if (!rate_limit || !(is.null(rate_limit_number) | is.null(rate_limit_seconds))) {
    .fn_set_ratelimit(rate_limit, "fleaflicker", rate_limit_number, rate_limit_seconds)
  }

  # nocov end

  ## Season ##
  # Fleaflicker organizes things by league year and tends to roll over around February.
  # Sensible default seems to be calling the current year if in March or later, otherwise previous year if in Jan/Feb

  if (is.null(season) || is.na(season)) {
    season <- .fn_choose_season()
    message(glue::glue("No season supplied - choosing {season} based on system date."))
  }

  structure(
    list(
      platform = "Fleaflicker",
      season = as.character(season),
      user_email = user_email,
      league_id = as.character(league_id)
    ),
    class = "flea_conn"
  )
}

# nocov start
#' @noRd
#' @export
print.flea_conn <- function(x, ...) {
  cat("<Fleaflicker connection ", x$season, "_", x$league_id, ">\n", sep = "")
  str(x)
  invisible(x)
}
# nocov end
