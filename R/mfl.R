#' Connect to MFL League
#'
#' This function creates a connection object which stores parameters and gets a login-cookie if available.
#'
#' @param season Season to access on MFL - if missing, will guess based on system date (current year if March or later, otherwise previous year)
#' @param league LeagueID (currently assuming one league at a time)
#' @param APIKEY APIKEY - optional - allows access to private leagues. Key is unique for each league and accessible from Developer's API page (currently assuming one league at a time)
#' @param username MFL username - optional - when supplied in conjunction with a password, will attempt to retrieve authentication token
#' @param password MFL password - optional - when supplied in conjunction with username, will attempt to retrieve authentication token
#'
#' @export
#' @return a list that stores MFL connection objects


mfl_connect <- function(season = NULL,leagueID=NULL,APIKEY = NULL,username = NULL,password = NULL, user_agent = NULL){

  if(is.null(user_agent)){user_agent <- glue::glue("https://github.com/dynastyprocess/fantasyscrapr/{utils::packageVersion('fantasyscrapr')}")}


  if(is.null(season) || is.na(season)){
    season <- .mfl_choose_season()
    message(glue::glue("No season supplied - choosing {season} based on system date."))
  }

  m_cookie <- NULL

  if(!is.null(username) && is.null(password)){message("Username supplied but no password - skipping login cookie call!")}
  if(!is.null(password) && is.null(username)){message("Password supplied but no username - skipping login cookie call!")}


  if(!is.null(username) && !is.null(password)){
    # message('Has both user and password - trying login!')
    m_cookie <- .mfl_logincookie(username,password,season,user_agent)
  }


  structure(

  list(
    platform = "MFL",
    season = season,
    leagueID = leagueID,
    APIKEY = APIKEY,
    user_agent = httr::user_agent(user_agent),

    auth_cookie = m_cookie),
  class = 'mfl_conn')
}

print.mfl_conn <- function(x, ...) {

  cat("<MFL connection ",x$season,"_",x$leagueID, ">\n", sep = "")
  str(x)
  invisible(x)

}

#' Choose current MFL season
#'
#' A helper function to return the current year if March or later, otherwise assume previous year
#' @noRd
#' @keywords internal

.mfl_choose_season <- function(){

  if(as.numeric(format(Sys.Date(),"%m"))>2){return(format(Sys.Date(),"%Y"))}

  format(Sys.Date()-365.25,"%Y")
}


# DO NOT EXPORT
#' Get MFL Login Cookie
#'
#' Gets login cookie for MFL based on username/password
#' Docs: https://api.myfantasyleague.com/2020/api_info#login_info
#'
#' @param username MFL username (as string)
#' @param password MFL password (as string)
#' @param season Season
#'
#' @keywords internal
#' @noRd
#'
#' @return a login cookie, which should be included as a parameter in an httr GET request

.mfl_logincookie <- function(username,password,season,user_agent){

  m_cookie <- httr::GET(glue::glue(
    "https://api.myfantasyleague.com/{season}/login?USERNAME={username}&PASSWORD={utils::URLencode(password,reserved=TRUE)}&XML=1"),httr::user_agent(user_agent))

  m_cookie <- purrr::pluck(m_cookie,'cookies','value')

  if(is.null(m_cookie)){stop("No login cookie available - please recheck username/password/season variables again!")}

  httr::set_cookies("MFL_USER_ID"=m_cookie[[1]],"MFL_PW_SEQ"=m_cookie[[2]])
}

#' GET any MFL endpoint
#'
#' Create a GET request to any MFL export endpoint, using the parameters defined in \code {mfl_connect()}
#'
#' @param conn the list object created by \code{mfl_connect()}
#' @param endpoint a string defining which endpoint to return from the API
#'
#' @seealso \url {https://api.myfantasyleague.com/2020/api_info?STATE=details}
#'
#' @return the league endpoint for MFL
#'
#' @examples
#' get_mfl_endpoint(conn,endpoint,...)
#'
#' @export

get_mfl_endpoint <- function(conn,endpoint,...){

  url_query <- httr::modify_url(url = glue::glue("https://www03.myfantasyleague.com/{conn$season}/export"),
                                   query = list("TYPE"='league',
                                                "L" = conn$leagueID,
                                                'APIKEY'=conn$APIKEY,
                                                # ...,
                                                "JSON"=1))

  response <- httr::GET(url_query,conn$user_agent,conn$auth_cookie)

  if (httr::http_type(response) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  parsed <- jsonlite::parse_json(httr::content(response,"text"))

  if (httr::http_error(response)) {
    stop(glue::glue("MFL API request failed [{httr::status_code(response)}]\n",
        parsed$message
      ),
      call. = FALSE
    )
  }

  structure(
    list(
      content = parsed,
      query = url_query,
      response = response
    ),
    class = "mfl_api"
  )

}

print.mfl_api <- function(x, ...) {

  cat("<MFL - GET ",x$query,">\n", sep = "")
  str(x$content)
  invisible(x)
}
