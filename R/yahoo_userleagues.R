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
  response <- yahoo_getendpoint(conn, glue::glue("users;use_login=1/games/leagues/teams"))
  xml_doc <- xml2::read_xml(response$response$content)
  xml2::xml_ns_strip(xml_doc)

  result_df <- data.frame(
    league_name = character(),
    league_id = character(),
    franchise_name = character(),
    franchise_id = character(),
    game_id = character(),
    season = character(),
    stringsAsFactors = FALSE
  )

  user_nodes <- xml2::xml_find_all(xml_doc, "//user")
  for (user_node in user_nodes) {
    user_id <- xml2::xml_text(xml2::xml_find_first(user_node, "./guid"))
    game_nodes <- xml2::xml_find_all(user_node, ".//game")
    for (game_node in game_nodes) {
      game_id <- xml2::xml_text(xml2::xml_find_first(game_node, "./game_id"))
      season <- xml2::xml_text(xml2::xml_find_first(game_node, "./season"))
      league_nodes <- xml2::xml_find_all(game_node, ".//league")
      for (league_node in league_nodes) {
        league_id <- xml2::xml_text(xml2::xml_find_first(league_node, "./league_id"))
        league_name <- xml2::xml_text(xml2::xml_find_first(league_node, "./name"))
        franchise_name <- xml2::xml_text(xml2::xml_find_first(league_node, ".//team/name"))
        # Add a new row to the result dataframe
        result_df <- rbind(result_df, list(
            league_name = league_name,
            league_id = league_id,
            franchise_name = franchise_name,
            franchise_id = user_id,
            game_id = game_id,
            season = season
        ))
      }
    }
  }
  return(result_df)
}
