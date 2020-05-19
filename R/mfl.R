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

  if(is.null(user_agent)){user_agent <- glue::glue("fantasyscrapR/{utils::packageVersion('fantasyscrapr')}")}

  if(is.null(season) || is.na(season)){
    season <- .mfl_choose_season()
    message(glue::glue("No season supplied - choosing {season} based on system date."))
  }

  m_cookie <- NA

  if(!is.null(username) && is.null(password)){message("Username supplied but no password - skipping login cookie call!")}
  if(!is.null(password) && is.null(username)){message("Password supplied but no username - skipping login cookie call!")}

  if(!is.null(username) && !is.null(password)){
    # message('Has both user and password - trying login!')
    m_cookie <- .mfl_logincookie(username,password,season,user_agent)
  }

  list(
    platform = "MFL",
    season = season,
    leagueID = leagueID,
    APIKEY = APIKEY,
    user_agent = httr::user_agent(user_agent),
    auth_cookie = m_cookie)
}

#' Choose correct MFL season
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

#' Read MFL league settings
#'
#' Get MFL league settings endpoint based on the predefined terms in mfl_connect()
#'
#' @param conn_object the list object created by \code{mfl_connect()}
#'
#' @return the league endpoint for MFL
#'
#' @examples
#' mfl_connect(season = 2020, leagueID = 54040) %>% mfl_get_league()
#'
#' @export mfl_get_league

mfl_get_league <- function(conn_object){

  arg_apikey <- ifelse(!is.null(conn_object$APIKEY),glue("&APIKEY={conn_object$APIKEY}"),"")

  request <- httr::GET(glue::glue("https://www03.myfantasyleague.com/{conn_object$season}",
                 "/export?TYPE=league&L={conn_object$leagueID}{arg_apikey}",
                 "&JSON=1"),conn_object$user_agent,conn_object$auth_cookie)

  response <- httr::content(request,'text')

  response <- jsonlite::parse_json(response)

  response <- purrr::pluck(response,"league")

}
