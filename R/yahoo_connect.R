#' Connect to Yahoo Fantasy Sports League
#'
#' This function creates a connection object for Yahoo Fantasy Sports league using the provided league_id and token.
#'
#' @param league_id League ID
#' @param token Token for authentication
#'
#' @examples
#' \donttest{
#' conn <- yahoo_connect(
#'   league_id = "12345",
#'   token = "your_token_here"
#' )
#' }
#'
#' @export yahoo_connect
#'
#' @return A list that stores Yahoo Fantasy Sports connection objects
yahoo_connect <- function(league_id = NULL,
                          season = NULL,
                          token = NULL,
                          ...) {
  if (length(token) == 0 || nchar(token) == 0) {
    stop("token is a required field.  Visit https://lemon-dune-0cd4b231e.azurestaticapps.net/ to get a token.", call. = FALSE)
  }
  conn <- structure(
    list(
      platform = "Yahoo Fantasy Sports",
      token = as.character(token)
    ),
    class = "yahoo_conn"
  )

  if (missing(league_id) | missing(season)) {
    user_leagues <- ff_userleagues(conn)
    print(user_leagues, n = Inf)
    stop("league_id and season are required.  You can use one of your leagues shown.", call. = FALSE)
  }

  # Set league_id and league_key
  conn$league_id <- as.character(league_id)
  game_id <- .yahoo_game_id(season)
  conn$league_key <- as.character(glue::glue("{game_id}.l.{conn$league_id}"))

  return(conn)
}

.yahoo_game_id <- function(season) {
  # .yahoo_season_to_game_id is populated from 1999 - 2023.
  # Can make a call to "https://fantasysports.yahooapis.com/fantasy/v2/games;game_codes=nfl" and get the game_id from the response instead
  # glue::glue("games;game_codes=nfl;seasons={season}") %>%
  #   yahoo_getendpoint(conn) %>%
  #   {
  #     xml2::xml_find_first(.$xml_doc, "//game_id")
  #   } %>%
  #   xml2::xml_text()
  .yahoo_season_to_game_id()[as.character(season)]
}

# nocov start
#' @noRd
#' @export
print.yahoo_conn <- function(x, ...) {
  cat("<Yahoo Fantasy Sports connection ", x$league_id, ">\n", sep = "")
  str(x)
  invisible(x)
}
# nocov end

.yahoo_season_to_game_id <- function() {
  c(
    "2002" = "49",
    "1999" = "50",
    "2000" = "53",
    "2001" = "57",
    "2003" = "79",
    "2004" = "101",
    "2005" = "124",
    "2006" = "153",
    "2007" = "175",
    "2008" = "199",
    "2009" = "222",
    "2010" = "242",
    "2011" = "257",
    "2012" = "273",
    "2013" = "314",
    "2014" = "331",
    "2015" = "348",
    "2016" = "359",
    "2017" = "371",
    "2018" = "380",
    "2019" = "390",
    "2020" = "399",
    "2021" = "406",
    "2022" = "414",
    "2023" = "423"
  )
}
