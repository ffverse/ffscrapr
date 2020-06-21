#### MFL GET API ####

#' GET any MFL endpoint
#'
#' Create a GET request to any MFL export endpoint
#' @param conn the list object created by \code{mfl_connect()}
#' @param endpoint a string defining which endpoint to return from the API
#' @param ... Arguments which will be passed as "argumentname = argument" in an HTTP query parameter
#'
#' @seealso \url{https://api.myfantasyleague.com/2020/api_info?STATE=details}
#'
#' @return output from the specified MFL API endpoint
#' @export

mfl_getendpoint <- function(conn,endpoint,...){

  url_query <- httr::modify_url(url = glue::glue("https://api.myfantasyleague.com/{conn$season}/export"),
                                query = list("TYPE"=endpoint,
                                             "L" = conn$league_id,
                                             'APIKEY'=conn$APIKEY,
                                             ...,
                                             "JSON"=1))

  response <- conn$get(url_query,conn$user_agent,conn$auth_cookie)

  if (httr::http_type(response) != "application/json") {
    stop("MFL API did not return json", call. = FALSE) }

  parsed <- jsonlite::parse_json(httr::content(response,"text"))

  if (httr::http_error(response)) {
    stop(glue::glue("MFL API request failed [{httr::status_code(response)}]\n", parsed$message),call. = FALSE) }

  if(!is.null(parsed$error)){
    warning(glue::glue("MFL says: {parsed$error[[1]]}"), call. = FALSE) }

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
print.mfl_api <- function(x, ...) {

  cat("<MFL - GET ",x$query,">\n", sep = "")
  str(x$content)

  invisible(x)
}
