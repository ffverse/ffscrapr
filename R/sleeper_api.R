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
#' @param ... Arguments which will be passed as "argumentname = argument" in an HTTP query parameter
#'
#' @seealso \url{https://docs.sleeper.app}
#'
#' @return A list object containing the query, response, and parsed content.
#' @export

sleeper_getendpoint <- function(conn,
                                endpoint,
                                suffixes = NULL,
                                ...){

  base_url <- "https://api.sleeper.app/v1/"



}
