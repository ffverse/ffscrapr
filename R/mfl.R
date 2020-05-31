#### MFL-specific functions ####


## CONNECT ## ----

#' Connect to MFL League
#'
#' This function creates a connection object which stores parameters and gets a login-cookie if available
#' @param season Season to access on MFL - if missing, will guess based on system date (current year if March or later, otherwise previous year)
#' @param league league_id Numeric ID parameter for each league, typically found in the URL
#' @param APIKEY APIKEY - optional - allows access to private leagues. Key is unique for each league and accessible from Developer's API page (currently assuming one league at a time)
#' @param user_name MFL user_name - optional - when supplied in conjunction with a password, will attempt to retrieve authentication token
#' @param password MFL password - optional - when supplied in conjunction with user_name, will attempt to retrieve authentication token
#' @param user_agent A string representing the user agent to be used to identify calls - may find improved rate_limits if verified token
#' @param rate_limit TRUE by default, pass FALSE to turn off rate limiting
#' @param rate_limit_number number of calls per \code{rate_limit_seconds}, suggested is 60 calls per 60 seconds
#' @param rate_limit_seconds number of seconds as denominator for rate_limit
#'
#' @export mfl_connect
#'
#' @examples
#' mfl_connect(season = 2020, league_id = 54040)
#' mfl_connect(season = 2019, league_id = 54040, rate_limit = FALSE)
#'
#' @return a list that stores MFL connection objects

mfl_connect <- function(season = NULL,
                        league_id=NULL,
                        APIKEY = NULL,
                        user_name = NULL,
                        password = NULL,
                        user_agent = NULL,
                        rate_limit = TRUE,
                        rate_limit_number = 60,
                        rate_limit_seconds = 60){

  ## LEAGUE ID ##


  ## USER AGENT ##
  # Self-identifying is mostly about being polite, although MFL has a program to give verified clients more bandwidth!
  # See: https://www03.myfantasyleague.com/2020/csetup?C=APICLI

  if(is.null(user_agent)){
    user_agent <- glue::glue("ffscrapr/",
                             "{utils::packageVersion('ffscrapr')}",
                             " API client package",
                             " https://github.com/dynastyprocess/ffscrapr")}

  user_agent <- httr::user_agent(user_agent)

  ## RATE LIMIT ##
  # For more info, see: https://api.myfantasyleague.com/2020/api_info

  if(!is.logical(rate_limit)){stop("rate_limit should be logical")}

  .get <- .fn_get(rate_limit,rate_limit_number,rate_limit_seconds)

  ## SEASON ##
  # MFL organizes things by league year and tends to roll over around February.
  # Sensible default seems to be calling the current year if in March or later, otherwise previous year if in Jan/Feb

  if(is.null(season) || is.na(season)){
    season <- .fn_choose_season()
    message(glue::glue("No season supplied - choosing {season} based on system date."))
  }

  ## Username/Password Login ##
  m_cookie <- NULL

  if(!is.null(user_name) && is.null(password)){
    message("User_name supplied but no password - skipping login cookie call!")}
  if(!is.null(password) && is.null(user_name)){
    message("Password supplied but no user_name - skipping login cookie call!")}

  if(!is.null(user_name) && !is.null(password)){
    m_cookie <- .mfl_logincookie(.get,user_name,password,season,user_agent)}

  ## Collect all of the connection pieces and store in an S3 object ##

  structure(
  list(
    platform = "MFL",
    get = .get,
    season = season,
    league_id = as.character(league_id),
    APIKEY = APIKEY,
    user_agent = user_agent,

    auth_cookie = m_cookie),
  class = 'mfl_conn')
}

## Print Method for Conn Obj ##

#' @noRd
#' @export
print.mfl_conn <- function(x, ...) {
  cat("<MFL connection ",x$season,"_",x$league_id, ">\n", sep = "")
  str(x)
  invisible(x)
}

## LOGIN ## ----
# Do Not Export
#
#' Get MFL Login Cookie
#'
#' Gets login cookie for MFL based on user_name/password
#' Docs: https://api.myfantasyleague.com/2020/api_info#login_info
#'
#' @param user_name MFL user_name (as string)
#' @param password MFL password (as string)
#' @param season Season
#'
#' @keywords internal
#' @noRd
#'
#' @return a login cookie, which should be included as a parameter in an httr GET request

.mfl_logincookie <- function(fn_get,user_name,password,season,user_agent){

  m_cookie <- fn_get(
    glue::glue(
      "https://api.myfantasyleague.com/{season}/login?",
      "USERNAME={user_name}&PASSWORD={utils::URLencode(password,reserved=TRUE)}&XML=1"),
    user_agent)

  m_cookie <- purrr::pluck(m_cookie,'cookies','value')

  if(is.null(m_cookie)){stop("No login cookie available - please recheck user_name/password/season variables again!")}

  httr::set_cookies("MFL_USER_ID"=m_cookie[[1]],"MFL_PW_SEQ"=m_cookie[[2]])
}

## GET API ## ----
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
    stop("MFL API did not return json", call. = FALSE)
  }

  parsed <- jsonlite::parse_json(httr::content(response,"text"))

  if (httr::http_error(response)) {
    stop(glue::glue("MFL API request failed [{httr::status_code(response)}]\n",
        parsed$message
      ),
      call. = FALSE
    )
  }

  if(!is.null(parsed$error)){
    warn(glue::glue("MFL says: {parsed$error[[1]]}"),
         call. = FALSE)
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

## PRINT METHOD MFL_API OBJ ##
#' @noRd
#' @export
print.mfl_api <- function(x, ...) {

  cat("<MFL - GET ",x$query,">\n", sep = "")
  str(x$content)
  invisible(x)

}

# ff_league ----

#' Get a summary of common league settings
#'
#' This function returns a data frame of common league settings - things like "1QB" or "2QB", best ball, team count etc
#'
#' @param conn the list object created by \code{mfl_connect()}
#'
#' @seealso \url{https://api.myfantasyleague.com/2020/api_info?STATE=details}
#'
#' @return the league endpoint for MFL
#' @export

mfl_league_summary <- function(conn){

  league_endpoint <- mfl_getendpoint(conn,endpoint = "league")

  league_endpoint <- purrr::pluck(league_endpoint,"content","league")

  tibble::tibble(
    league_id = conn$league_id,
    league_name = league_endpoint$name,
    franchise_count = league_endpoint$franchises$count,
    qb_type = .is_qbtype(league_endpoint)$type,
    idp = .is_idp(league_endpoint),
    scoring_type = NA,
    best_ball = league_endpoint$bestLineup,
    salary_cap = league_endpoint$usesSalaries,
    player_copies = league_endpoint$rostersPerPlayer,
    years_active = .years_active(league_endpoint),
    qb_count = .is_qbtype(league_endpoint)$count,
    roster_size = .roster_size(league_endpoint),
    league_depth = as.numeric(roster_size) * as.numeric(franchise_count) / as.numeric(player_copies)
  )

}

## League Summary Helper Functions ##
#' @noRd
.is_idp <- function(league_endpoint){
  ifelse(is.null(league_endpoint$starters$idp_starters) || league_endpoint$starters$idp_starters=="",FALSE,TRUE)
}
#' @noRd
.is_qbtype <- function(league_endpoint){

  starters <- purrr::pluck(league_endpoint,"starters","position")

  starters <- dplyr::bind_rows(starters)

  qb_count <- dplyr::filter(starters,name == "QB")[["limit"]]

  qb_type <- dplyr::case_when(qb_count == "1" ~ "1QB",
                   qb_count == "1-2" ~ "2QB/SF",
                   qb_count == "2" ~ "2QB/SF")

  list(count = qb_count,
       type = qb_type)
}
#' @noRd
.roster_size <- function(league_endpoint) {
  as.numeric(league_endpoint$rosterSize)+as.numeric(league_endpoint$taxiSquad)+as.numeric(league_endpoint$injuredReserve)
}
#' @noRd
.years_active <- function(league_endpoint){
  years_active <- league_endpoint$history$league
  years_active <- dplyr::bind_rows(years_active)
  years_active <- dplyr::arrange(years_active,year)
  years_active <- dplyr::slice(years_active,1,nrow(years_active))
  glue::glue_collapse(years_active$year,sep = "-")
}

# ff_settings_scoring ----

# ff_settings_roster ----

# ff_transactions ----

# ff_rosters ----
