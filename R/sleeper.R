#' Connect to Sleeper League
#'
#' This function creates a connection object which stores parameters and a user ID if available.
#'
#' @param season Season to access on Sleeper - if missing, will guess based on system date (current year if March or later, otherwise previous year)
#' @param league_id League ID (currently assuming one league at a time)
#' @param user_name Sleeper user_name - optional - attempts to get user's user ID
#' @param user_agent User agent to self-identify (optional)
#' @param rate_limit TRUE by default - turn off rate limiting with FALSE
#' @param rate_limit_number number of calls per \code{rate_limit_seconds}, suggested is 100 calls per 60 seconds
#' @param rate_limit_seconds number of seconds as denominator for rate_limit
#'
#' @export
#' @return a list that stores MFL connection objects

sleeper_connect <- function(season = NULL,
                            league_id = NULL,
                            user_name = NULL,
                            user_agent = NULL,
                            rate_limit = TRUE,
                            rate_limit_number = 100,
                            rate_limit_seconds = 60) {

  ## USER AGENT ##
  # Self-identifying is mostly about being polite, although MFL has a program to give verified clients more bandwidth!
  # See: https://www03.myfantasyleague.com/2020/csetup?C=APICLI

  if (length(user_agent) > 1) {
    stop("user_agent must be a character vector of length one!")
  }

  if (!is.null(user_agent)) {
    .fn_set_useragent(user_agent)
  }

  ## RATE LIMIT ##
  # For more info, see: https://api.myfantasyleague.com/2020/api_info

  if (!is.logical(rate_limit)) {
    stop("rate_limit should be logical")
  }

  .fn_set_ratelimit(rate_limit, rate_limit_number, rate_limit_seconds)

  ## Season ##
  # Sleeper organizes things by league year and tends to roll over around February.
  # Sensible default seems to be calling the current year if in March or later, otherwise previous year if in Jan/Feb

  if (is.null(season) || is.na(season)) {
    season <- .fn_choose_season()
    message(glue::glue("No season supplied - choosing {season} based on system date."))
  }

  ## Fetch User ID ##

  user_id <- NULL

  if (!is.null(user_name)) {
    user_id <- .sleeper_userid(user_name)
  }

  structure(
    list(
      platform = "Sleeper",
      # get = .get,
      # user_agent = user_agent
      season = season,
      league_id = league_id,
      user_name = user_name,
      user_id = user_id
    ),
    class = "sleeper_conn"
  )
}

#' @noRd
#' @export
print.sleeper_conn <- function(x, ...) {
  cat("<Sleeper connection ", x$season, "_", x$league_id, ">\n", sep = "")
  str(x)
  invisible(x)
}

# DO NOT EXPORT
#' Get Sleeper User ID
#'
#' Docs: https://docs.sleeper.app
#'
#' @param user_name Sleeper username
#' @param season Season
#'
#' @keywords internal
#' @noRd
#'
#' @return a login cookie, which should be included as a parameter in an httr GET request

.sleeper_userid <- function(user_name) {
  env <- get(".ffscrapr_env", inherits = TRUE)

  user_object <- env$get(glue::glue("https://api.sleeper.app/v1/user/{user_name}"), env$user_agent)

  if (httr::http_type(user_object) != "application/json") {
    stop("API call for user_name object did not return JSON", call. = FALSE)
  }

  parsed <- jsonlite::parse_json(httr::content(user_object, "text"))

  if (httr::http_error(user_object)) {
    stop(glue::glue(
      "Failed to retrieve user ID [{httr::status_code(user_object)}]\n",
      parsed$message
    ),
    call. = FALSE
    )
  }

  parsed$user_id
}

#' GET Sleeper endpoint
#' ## NOT YET WORKING ##
#'
#' Create a GET request to any MFL export endpoint
#'
#' @param conn the list object created by \code{mfl_connect()}
#' @param endpoint a string defining which endpoint to return from the API
#' @param ... Arguments which will be passed as "argumentname = argument" in an HTTP query parameter
#'
#' @seealso \url{https://api.myfantasyleague.com/2020/api_info?STATE=details}
#'
#' @return the league endpoint for MFL
#'
#'
#' @export

#' sleeper_getendpoint <- function(conn,endpoint,...){
#'
#'   url_query <- httr::modify_url(url = glue::glue("https://api.sleeper.app/v1/"),
#'                                 query = list("TYPE"=endpoint,
#'                                              "L" = conn$league_id,
#'                                              'APIKEY'=conn$APIKEY,
#'                                              # ...,
#'                                              "JSON"=1))
#'
#'   response <- .fn_get(url_query,conn$user_agent,conn$auth_cookie)
#'
#'   if (httr::http_type(response) != "application/json") {
#'     stop("API did not return json", call. = FALSE)
#'   }
#'
#'   parsed <- jsonlite::parse_json(httr::content(response,"text"))
#'
#'   if (httr::http_error(response)) {
#'     stop(glue::glue("Sleeper API request failed [{httr::status_code(response)}]\n",
#'                     parsed$message
#'     ),
#'     call. = FALSE
#'     )
#'   }
#'
#'   structure(
#'     list(
#'       content = parsed,
#'       query = url_query,
#'       response = response
#'     ),
#'     class = "sleeper_api"
#'   )
#'
#' }
#'
#' #' @noRd
#' #' @export
#' print.sleeper_api <- function(x, ...) {
#'
#'   cat("<Sleeper - GET ",x$query,">\n", sep = "")
#'   str(x$content)
#'   invisible(x)
#'
#' }
