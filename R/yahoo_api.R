#' GET any Yahoo Fantasy Football API endpoint
#'
#' @param endpoint a string defining which endpoint to return from the Yahoo API
#' @param conn Yahoo ff_connect object
#'
#' @return A list object containing the query, response, and parsed content as an xml_doc.
#'
#' @seealso <https://developer.yahoo.com/fantasysports/guide/>
#'
#' @export
yahoo_getendpoint <- function(endpoint, conn) {
  # Construct API request headers with authentication token
  headers <- c("Authorization" = paste("Bearer", conn$token))

  # Construct the API URL with the provided endpoint and query parameters
  url_query <- httr::modify_url(
    url = glue::glue("https://fantasysports.yahooapis.com/fantasy/v2/{endpoint}"),
  )

  # Perform the API request
  response <- httr::GET(url_query, httr::add_headers(headers))

  # Check the API response for errors
  if (httr::http_error(response)) {
    cli::cli_abort(
      c(
        "Yahoo FF API request failed with error <{httr::http_status(response)$message}>",
        "while calling {.url {url_query}}"
      )
    )
  }
  xml_doc <- xml2::read_xml(response$content)
  xml2::xml_ns_strip(xml_doc)

  # Return an S3 object
  structure(
    list(
      query = url_query,
      response = response,
      xml_doc = xml_doc
    ),
    class = "yahoo_api"
  )
}

## PRINT METHOD YAHOO_API OBJ ##
#' @noRd
#' @export
print.yahoo_api <- function(x, ...) {
  cat("<Yahoo Fantasy Football API - GET - ", httr::http_status(x$response)$message, ">\n", sep = "")
  cat("QUERY: <", x$query, ">\n", sep = "")
  str(x$content, max.level = 1)
  invisible(x)
}
