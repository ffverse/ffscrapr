#' Connect to Sleeper League
#'
#' This function creates a connection object which stores parameters and gets a login-cookie if available.
#'
#' @param season Season to access on Sleeper - if missing, will guess based on system date (current year if March or later, otherwise previous year)
#' @param leagueID LeagueID (currently assuming one league at a time)
#' @param username Sleeper username - optional - attempts to get user's userID
#' @param user_agent User agent to self-identify (optional)
#' @param rate_limit_toggle TRUE by default - turn off with FALSE
#' @param rate_
#'
#' @export
#' @return a list that stores MFL connection objects


sleeper_connect <- function(season = NULL,
                            leagueID=NULL,
                            username = NULL,
                            user_agent = NULL,
                            rate_limit_toggle = TRUE,
                            rate_limit_number = 100,
                            rate_limit_seconds = 60){

  ## USER AGENT ##
  # Self-identifying is mostly about being polite!

  if(is.null(user_agent)){
    user_agent <- glue::glue("https://github.com/dynastyprocess/fantasyscrapr/",
                             "{utils::packageVersion('fantasyscrapr')}")
    }

  user_agent <- httr::user_agent(user_agent)

  ## RATE LIMIT ##
  # For more info, see: https://docs.sleeper.app

  if(!is.logical(rate_limit_toggle)){stop("rate_limit_toggle should be logical")}

  .get <- .fn_get(rate_limit_toggle,rate_limit_number,rate_limit_seconds)

  ## Season ##
  # Sleeper organizes things by league year and tends to roll over around February.
  # Sensible default seems to be calling the current year if in March or later, otherwise previous year if in Jan/Feb

  if(is.null(season) || is.na(season)){
    season <- .choose_season()
    message(glue::glue("No season supplied - choosing {season} based on system date."))
  }

  ## Username/Password Login ##

  if(!is.null(username)){
    user_id <- .sleeper_userid(.get,username,user_agent)}

  structure(
    list(
      platform = "Sleeper",
      get = .get,
      season = season,
      leagueID = leagueID,
      user_name = user_name,
      user_id = user_id,
      user_agent = user_agent),
    class = 'sleeper_conn')
}

#' @noRd
#' @export
print.sleeper_conn <- function(x, ...) {

  cat("<Sleeper connection ",x$season,"_",x$leagueID, ">\n", sep = "")
  str(x)
  invisible(x)

}


# DO NOT EXPORT
#' Get Sleeper User ID
#'
#' Docs: https://docs.sleeper.app
#'
#' @param username
#' @param season Season
#'
#' @keywords internal
#' @noRd
#'
#' @return a login cookie, which should be included as a parameter in an httr GET request

.sleeper_userid <- function(fn_get,username,user_agent){

  user_object <- fn_get(glue::glue("https://api.sleeper.app/v1/user/{username}"),user_agent)

  if (httr::http_type(user_object) != "application/json") {
    stop("API call for username object did not return JSON", call. = FALSE)
  }

  parsed <- jsonlite::parse_json(httr::content(user_object,"text"))

  if (httr::http_error(user_object)) {
    stop(glue::glue("Sleeper API request failed [{httr::status_code(user_object)}]\n",
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
#' @examples
#' get_mfl_endpoint(conn,endpoint,...)
#'
#' @export

#' get_sleeper_endpoint <- function(conn,endpoint,...){
#'
#'   url_query <- httr::modify_url(url = glue::glue("https://api.myfantasyleague.com/{conn$season}/export"),
#'                                 query = list("TYPE"=endpoint,
#'                                              "L" = conn$leagueID,
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
#' print.mfl_api <- function(x, ...) {
#'
#'   cat("<MFL - GET ",x$query,">\n", sep = "")
#'   str(x$content)
#'   invisible(x)
#'
#' }

