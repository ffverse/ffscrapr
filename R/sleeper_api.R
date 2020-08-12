#### SLEEPER GET API ####

#' GET any SLEEPER endpoint
#'
#' Create a GET request to any MFL export endpoint.
#'
#' This function will read the connection object and automatically pass in the rate-limiting, league ID, and/or user ID found in the object.
#'
#' The endpoint names and HTTP parameters (i.e. argument names) are CASE SENSITIVE and should be passed in exactly as displayed on the Sleeper API reference page.
#'
#' Check out the vignette for more details and example usage.
#'
#' @param conn the list object created by \code{sleeper_connect()}
#' @param endpoint a string defining which endpoint to return from the API
#' @param ... All other arguments are passed in order as slash-separated components of the url
#'
#' @seealso \url{https://docs.sleeper.app}
#'
#' @return A list object containing the query, response, and parsed content.
#' @export

sleeper_getendpoint <- function(conn,
                                endpoint,
                                ...){

  # PREP URL

  base_url <- "https://api.sleeper.app/v1/"

  suffixes <- list(...) %>%
    unname() %>%
    as.character() %>%
    .fn_drop_nulls() %>%
    paste0(collapse = "/")

  url_query <- paste0(base_url,suffixes,sep = "/")

  ## GET FFSCRAPR ENV

  fn_get <- get("get", envir = .ffscrapr_env, inherits = TRUE)

  user_agent <- get("user_agent", envir = .ffscrapr_env, inherits = TRUE)

  ## DO QUERY

  response <- fn_get(url_query,user_agent)

  ## CHECK QUERY
  # nocov start

  if (httr::http_error(response) && httr::status_code(response) == 429) {
    stop(glue::glue("You've hit a rate limit wall! Please adjust the
                    built-in rate_limit arguments in sleeper_connect()!"), call. = FALSE)
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
    parsed <- jsonlite::parse_json(httr::content(response, "text"))
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
#'
print.sleeper_api <- function(x, ...) {

  # nocov start

  cat("<SLEEPER - GET ", x$query, ">\n", sep = "")

  str(x$content)

  invisible(x)

  # nocov end
}
