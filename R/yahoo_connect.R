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
                          token = NULL,
                          ...) {
  
  conn <- structure(
    list(
      platform = "Yahoo Fantasy Sports",
      league_id = as.character(league_id),
      token = as.character(token)
    ),
    class = "yahoo_conn"
  )

  conn$user_leagues <- ff_userleagues(conn)
  if (missing(league_id)) {
    print(conn$user_leagues)
    stop("league_id is a required field.  Try again using one of your league_ids shown.", call. = FALSE)
  }
  
  if (!league_id %in% conn$user_leagues$league_id) {
    stop(glue::glue("league_id <{league_id}> not in userleagues"), call. = FALSE)
  }
  
  return(conn)
}

# Define a separate function for get_league_key
get_league_key <- function(conn) { 
  subset_df <- subset(conn$user_leagues, league_id == conn$league_id)
  
  if (nrow(subset_df) == 0) {
    stop(glue::glue("user doesn't have access to league_id <{conn$league_id}>"), call. = FALSE)
  } else {
    game_id <- subset_df$game_id[1]
    return(glue::glue("{game_id}.l.{conn$league_id}"))
  }
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