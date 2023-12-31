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
  # get the game_id for the season. 
  # game_ids are the same for all Yahoo users but it's easier to make the api call then maintain a static dictionary in this repo.
  glue::glue("games;game_codes=nfl;seasons={season}") %>%
    yahoo_getendpoint(conn) %>%
    {
      xml2::xml_find_first(.$xml_doc, "//game_id")
    } %>%
    xml2::xml_text()
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