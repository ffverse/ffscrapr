#### ESPN GET API ####

#' GET any ESPN endpoint
#'
#' The endpoint names and HTTP parameters (i.e. argument names) are CASE SENSITIVE.
#' Best URL help page is TBD, possibly might just be the vignette.
#'
#' Check out the vignette for more details and example usage.
#'
#' @param conn a connection object created by \code{espn_connect} or \code{ff_connect()}
#' @param endpoint a string defining which endpoint to return from the API
#' @param ... Arguments which will be passed as "argumentname = argument" in an HTTP query parameter
#'
#' @seealso \code{vignette("espn_getendpoint")}
#'
#' @return A list object containing the query, response, and parsed content.
#' @export

espn_getendpoint <- function(conn, endpoint, ...) {
  if (conn$season < 2018) {
    url_query <- httr::modify_url(
      url = glue::glue("https://fantasy.espn.com/apis/v3/games/ffl/leagueHistory/{conn$league_id}"),
      query = list(
        seasonId = conn$season
      )
    )
  }

  if (conn$season >= 2018) {
    base_url <- glue("https://fantasy.espn.com/apis/v3/games/ffl//seasons/{conn$year}/segments/0/leagues/{conn$league_id}")
  }

  # PREP URL
  url_query <- httr::modify_url(
    url = glue::glue("https://api.sleeper.app/v1/{endpoint}"),
    query = list(
      ...
    )
  )

  ## GET FFSCRAPR ENV

  fn_get <- get("get.espn", envir = .ffscrapr_env, inherits = TRUE)

  user_agent <- get("user_agent", envir = .ffscrapr_env, inherits = TRUE)

  ## DO QUERY

  response <- fn_get(url_query, user_agent, conn$cookies)

  ## CHECK QUERY
  # nocov start

  if (httr::http_error(response) && httr::status_code(response) == 429) {
    stop(glue::glue("You've hit a rate limit wall! Please adjust the
                    built-in rate_limit arguments in espn_connect()!"), call. = FALSE)
  }

  if (httr::http_error(response)) {
    stop(glue::glue("Sleeper API request failed with error: <{httr::status_code(response)}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  if (httr::http_type(response) != "application/json") {
    warning(glue::glue("Sleeper API did not return json while calling {url_query}"),
      call. = FALSE
    )
  }

  if (httr::http_type(response) == "application/json") {
    parsed <- jsonlite::parse_json(httr::content(x = response, as = "text"))
  }

  if (!is.null(parsed$error)) {
    warning(glue::glue("Sleeper says: {parsed$error[[1]]}"), call. = FALSE)
  }

  # nocov end

  ## RETURN S3

  structure(
    list(
      content = parsed,
      query = url_query,
      response = response
    ),
    class = "sleeper_api"
  )
}

## PRINT METHOD SLEEPER_API OBJ ##
#' @noRd
#' @export
print.sleeper_api <- function(x, ...) {

  # nocov start

  cat("<SLEEPER - GET ", x$query, ">\n", sep = "")

  str(x$content, max.level = 1)

  invisible(x)

  # nocov end
}
