#### ESPN GET API ####

#' GET ESPN fantasy league endpoint
#'
#' This function is used to call the ESPN Fantasy API for league-based endpoints.
#'
#' The ESPN Fantasy API is undocumented and this should be used by advanced users
#' familiar with the API.
#'
#' It chooses the correct league endpoint based on the year (eg leagueHistory
#' for <2018), checks the x_fantasy_filter for valid JSON input, builds a url
#' with any optional query parameters, and executes the request with authentication
#' and rate limiting.
#'
#' HTTP query parameters (i.e. arguments to ...) are Case Sensitive.
#'
#' Please see the vignette for more on usage.
#'
#' @param conn a connection object created by `espn_connect` or `ff_connect()`
#' @param ... Arguments which will be passed as "argumentname = argument" in an HTTP query parameter
#' @param x_fantasy_filter a JSON-encoded character string that specifies a filter for the data
#'
#' @seealso `vignette("espn_getendpoint")`
#' @seealso `espn_getendpoint_raw`
#'
#' @return A list object containing the query, response, and parsed content.
#' @export

espn_getendpoint <- function(conn, ..., x_fantasy_filter = NULL) {
  xff <- NULL

  if (!is.null(x_fantasy_filter) && !jsonlite::validate(x_fantasy_filter)) {
    rlang::abort("x_fantasy_filter is not formatted as valid JSON")
  }

  if (!is.null(x_fantasy_filter)) {
    xff <- httr::add_headers(`X-Fantasy-Filter` = x_fantasy_filter)
  }

  if (as.numeric(conn$season) < 2018) {
    url_query <- httr::modify_url(
      url = glue::glue("https://fantasy.espn.com/apis/v3/games/ffl/leagueHistory/{conn$league_id}?seasonId={conn$season}"),
      query = list(...)
    )
  }

  if (as.numeric(conn$season) >= 2018) {
    url_query <- httr::modify_url(
      url = glue::glue("https://fantasy.espn.com/apis/v3/games/ffl/seasons/{conn$season}/segments/0/leagues/{conn$league_id}"),
      query = list(...)
    )
  }

  endpoint_raw <- espn_getendpoint_raw(conn, url_query, xff)

  if (as.numeric(conn$season) < 2018) {
    endpoint_raw$content <- endpoint_raw$content[[1]]
  }

  return(endpoint_raw)
}

#' GET ESPN endpoint (raw)
#'
#' This function is the lower-level function that powers the API call:
#' it takes a URL and headers and executes the http request with rate-limiting
#' and authentication. It checks for JSON return and any warnings/errors,
#' parses the json, and returns an espn_api object with the parsed content,
#' the raw response, and the actual query.
#'
#' @param conn a connection object created by ff_connect or equivalent - used for authentication
#' @param url_query a fully-formed URL to call
#' @param ... any headers or other httr request objects to pass along
#'
#' @seealso `espn_getendpoint()` - a higher level wrapper that checks JSON and prepares the url query
#' @seealso `vignette("espn_getendpoint")`
#'
#' @return object of class espn_api with parsed content, request, and response
#'
#' @export

espn_getendpoint_raw <- function(conn, url_query, ...) {

  ## GET FFSCRAPR ENV

  fn_get <- get("get.espn", envir = .ffscrapr_env, inherits = TRUE)

  user_agent <- get("user_agent", envir = .ffscrapr_env, inherits = TRUE)

  ## DO QUERY

  response <- fn_get(url_query, user_agent, conn$cookies, ...)

  # nocov start

  if (httr::http_error(response) && httr::status_code(response) == 429) {
    warning(glue::glue("You've hit a rate limit wall! Please adjust the
                    built-in rate_limit arguments in espn_connect()!"), call. = FALSE)
  }

  if (httr::http_error(response)) {
    warning(glue::glue("ESPN API request failed with <{httr::http_status(response)$message}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  if (httr::http_type(response) != "application/json") {
    warning(glue::glue("ESPN API did not return json while calling {url_query}"),
      call. = FALSE
    )
  }

  if (httr::http_type(response) == "application/json") {
    parsed <- jsonlite::parse_json(httr::content(x = response, as = "text"))
  }

  if (!is.null(parsed$error)) {
    warning(glue::glue("ESPN says: {parsed$error[[1]]}"), call. = FALSE)
  }

  # nocov end

  structure(
    list(
      content = parsed,
      query = url_query,
      response = response
    ),
    class = "espn_api"
  )
}

## PRINT METHOD ESPN_API OBJ ##
#' @noRd
#' @export
print.espn_api <- function(x, ...) {

  # nocov start

  cat("<ESPN - GET - ", httr::http_status(x$response)$message, ">\n", sep = "")
  cat("QUERY: <", x$query, ">\n", sep = "")

  str(x$content, max.level = 1)

  invisible(x)

  # nocov end
}
