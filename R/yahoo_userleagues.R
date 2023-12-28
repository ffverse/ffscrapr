#' Get a dataframe of user_leagues
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   yahoo_conn <- ff_connect(platform = "yahoo", league_id = "423.l.77275", token = NULL)
#'   ff_userleagues(yahoo_conn)
#' }) # end try
#' }
#' @describeIn ff_userleagues Yahoo: Returns all userleagues.
#' @export
ff_userleagues.yahoo_conn <- function(conn, ...) {
  glue::glue("users;use_login=1/games/leagues/teams") %>%
    yahoo_getendpoint(conn) %>%
    .yahoo_process_userleagues_response(.$xml_doc)
}

.yahoo_process_userleagues_response <- function(xml_doc) {
  # Process all user nodes
  user_nodes <- xml_doc %>%
    xml2::xml_find_all("//user")
  purrr::map_df(user_nodes, .yahoo_process_user_node)
}

# Function to process each user node
.yahoo_process_user_node <- function(user_node) {
  user_id <- user_node %>%
    xml2::xml_find_first("./guid") %>%
    xml2::xml_text()
  game_nodes <- user_node %>%
    xml2::xml_find_all(".//game")
  purrr::map_df(game_nodes, ~ .yahoo_process_game_node(.x, user_id))
}

# Function to process each game node
.yahoo_process_game_node <- function(game_node, user_id) {
  game_id <- game_node %>%
    xml2::xml_find_first("./game_id") %>%
    xml2::xml_text()
  season <- game_node %>%
    xml2::xml_find_first("./season") %>%
    xml2::xml_integer()
  league_nodes <- game_node %>%
    xml2::xml_find_all(".//league")

  purrr::map_df(league_nodes, ~ .yahoo_process_league_node(.x, user_id, game_id, season))
}

# Function to process each league node
.yahoo_process_league_node <- function(league_node, user_id, game_id, season) {
  league_id <- league_node %>%
    xml2::xml_find_first("./league_id") %>%
    xml2::xml_text()
  league_name <- league_node %>%
    xml2::xml_find_first("./name") %>%
    xml2::xml_text()
  franchise_name <- league_node %>%
    xml2::xml_find_first(".//team/name") %>%
    xml2::xml_text()
  tibble::tibble(
    league_name = league_name,
    league_id = league_id,
    franchise_name = franchise_name,
    franchise_id = user_id,
    game_id = game_id,
    season = season
  )
}
