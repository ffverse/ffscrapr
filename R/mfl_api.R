#### MFL GET API ####

#' GET any MFL endpoint
#'
#' Create a GET request to any MFL export endpoint.
#'
#' This function will read the connection object and automatically pass in the rate-limiting, league ID (L), authentication cookie, and/or API key (APIKEY) if configured in the connection object.
#'
#' The endpoint names and HTTP parameters (i.e. argument names) are CASE SENSITIVE and should be passed in exactly as displayed on the MFL API reference page.
#'
#' Check out the vignette for more details and example usage.
#'
#' @param conn the list object created by `mfl_connect()`
#' @param endpoint a string defining which endpoint to return from the API
#' @param ... Arguments which will be passed as "argumentname = argument" in an HTTP query parameter
#'
#' @seealso <https://api.myfantasyleague.com/2020/api_info?STATE=details>
#' @seealso `vignette("mfl_getendpoint")`
#'
#' @return A list object containing the query, response, and parsed content.
#' @export

mfl_getendpoint <- function(conn, endpoint, ...) {
  fn_get <- get("get.mfl", envir = .ffscrapr_env, inherits = TRUE)

  user_agent <- get("user_agent", envir = .ffscrapr_env, inherits = TRUE)

  url_query <- httr::modify_url(
    url = glue::glue("https://api.myfantasyleague.com/{conn$season}/export"),
    query = list(
      "TYPE" = endpoint,
      "L" = conn$league_id,
      "APIKEY" = conn$APIKEY,
      ...,
      "JSON" = 1
    )
  )

  response <- fn_get(url_query, user_agent, conn$auth_cookie)

  # nocov start

  if (httr::http_error(response) && httr::status_code(response) == 429) {
    stop(glue::glue("You've hit the MFL rate limit wall! Please adjust the
                    built-in rate_limit arguments in mfl_connect()!"), call. = FALSE)
  }

  if (httr::http_error(response)) {
    stop(glue::glue("MFL API request failed with <{httr::http_status(response)$message}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  if (httr::http_type(response) != "application/json") {
    warning(glue::glue("MFL API did not return json while calling {url_query}"),
      call. = FALSE
    )
  }


  if (httr::http_type(response) == "application/json") {
    parsed <- jsonlite::parse_json(httr::content(response, "text"))
  }

  if (!is.null(parsed$error)) {
    warning(glue::glue("MFL says: {parsed$error[[1]]}"), call. = FALSE)
  }

  # nocov end

  structure(
    list(
      content = parsed,
      query = url_query,
      response = response
    ),
    class = "mfl_api"
  )
}

## PRINT METHOD MFL_API OBJ ##
#' @noRd
#' @export
#'
print.mfl_api <- function(x, ...) {

  # nocov start

  cat("<MFL - GET - ", httr::http_status(x$response)$message, ">\n", sep = "")
  cat("QUERY: <", x$query, ">\n", sep = "")
  str(x$content, max.level = 1)

  invisible(x)

  # nocov end
}

# mfl_postendpoint <- function(){}
