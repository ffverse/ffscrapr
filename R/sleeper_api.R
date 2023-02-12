#### SLEEPER GET API ####

#' GET any Sleeper endpoint
#'
#' The endpoint names and HTTP parameters (i.e. argument names) are CASE SENSITIVE and should be passed in exactly as displayed on the Sleeper API reference page.
#'
#' Check out the vignette for more details and example usage.
#'
#' @param endpoint a string defining which endpoint to return from the API
#' @param ... Arguments which will be passed as "argumentname = argument" in an HTTP query parameter
#'
#' @seealso <https://docs.sleeper.com>
#' @seealso `vignette("sleeper_getendpoint")`
#'
#' @return A list object containing the query, response, and parsed content.
#' @export

sleeper_getendpoint <- function(endpoint, ...) {

  # PREP URL
  url_query <- httr::modify_url(
    url = glue::glue("https://api.sleeper.app/v1/{endpoint}"),
    query = list(
      ...
    )
  )

  ## GET FFSCRAPR ENV

  fn_get <- get("get.sleeper", envir = .ffscrapr_env, inherits = TRUE)

  user_agent <- get("user_agent", envir = .ffscrapr_env, inherits = TRUE)

  ## DO QUERY

  response <- fn_get(url_query, user_agent)

  ## CHECK QUERY
  # nocov start

  if (httr::http_error(response) && httr::status_code(response) == 429) {
    stop(glue::glue("You've hit a rate limit wall! Please adjust the
                    built-in rate_limit arguments in sleeper_connect()!"), call. = FALSE)
  }

  if (httr::http_error(response)) {
    stop(glue::glue("Sleeper API request failed with error: <{httr::http_status(response)$message}> \n
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

  cat("<Sleeper - GET - ", httr::http_status(x$response)$message, ">\n", sep = "")

  cat("QUERY: <", x$query, ">\n", sep = "")

  str(x$content, max.level = 1)

  invisible(x)

  # nocov end
}
