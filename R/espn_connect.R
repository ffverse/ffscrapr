#' Connect to ESPN League
#'
#' This function creates a connection object which stores parameters and a user ID if available.
#'
#' @param season Season to access on Fleaflicker - if missing, will guess based on system date (current year if March or later, otherwise previous year)
#' @param league_id League ID
#' @param user_agent User agent to self-identify (optional)
#' @param swid SWID parameter for accessing private leagues - see vignette for details
#' @param espn_s2 ESPN_S2 parameter for accessing private leagues - see vignette for details
#' @param rate_limit TRUE by default - turn off rate limiting with FALSE
#' @param rate_limit_number number of calls per `rate_limit_seconds`, suggested is under 1000 calls per 60 seconds
#' @param rate_limit_seconds number of seconds as denominator for rate_limit
#' @param ... other arguments (for other methods, for R compat)
#'
#' @examples
#' \donttest{
#' conn <- espn_connect(
#'   season = 2018,
#'   league_id = 1178049,
#'   espn_s2 = Sys.getenv("TAN_ESPN_S2"),
#'   swid = Sys.getenv("TAN_SWID")
#' )
#' }
#'
#' @export espn_connect
#'
#' @return a list that stores ESPN connection objects

espn_connect <- function(season = NULL,
                         league_id = NULL,
                         swid = NULL,
                         espn_s2 = NULL,
                         # user_name = NULL,
                         # password = NULL,
                         user_agent = NULL,
                         rate_limit = TRUE,
                         rate_limit_number = NULL,
                         rate_limit_seconds = NULL,
                         ...) {
  checkmate::assert_character(user_agent, null.ok = TRUE)
  checkmate::assert_logical(rate_limit, len = 1)
  checkmate::assert_numeric(rate_limit_number, null.ok = TRUE)
  checkmate::assert_numeric(rate_limit_seconds, null.ok = TRUE)

  # nocov start
  ## USER AGENT ##
  # Self-identifying is mostly about being polite.
  if (!is.null(user_agent)) .fn_set_useragent(user_agent)

  ## RATE LIMIT ##
  if (!rate_limit || !(is.null(rate_limit_number) | is.null(rate_limit_seconds))) {
    .fn_set_ratelimit(rate_limit, "espn", rate_limit_number, rate_limit_seconds)
  }

  # nocov end

  ## Season ##
  # Most APIs organize things by league year and tend to roll over around February.
  # Sensible default seems to be calling the current year if in March or later, otherwise previous year if in Jan/Feb

  if (is.null(season) || is.na(season)) {
    season <- .fn_choose_season()
    message(glue::glue("No season supplied - choosing {season} based on system date."))
  }

  ## Cookies ##
  cookies <- NULL

  if (!is.null(swid) & !is.null(espn_s2)) {
    cookies <- set_unescaped_cookies(
      espn_s2 = espn_s2,
      SWID = swid
    )
  }

  structure(
    list(
      platform = "ESPN",
      season = as.character(season),
      league_id = as.character(league_id),
      cookies = cookies
    ),
    class = "espn_conn"
  )
}

# nocov start
#' @noRd
#' @export
print.espn_conn <- function(x, ...) {
  cat("<ESPN connection ", x$season, "_", x$league_id, ">\n", sep = "")
  str(x)
  invisible(x)
}
# nocov end
