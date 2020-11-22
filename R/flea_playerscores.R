#### Fleaflicker Player Scores ####

#' Fleaflicker Player Scores
#'
#' @param conn the list object created by \code{ff_connect()}
#' @param ... other arguments (for other platform/methods)
#'
#' @describeIn ff_playerscores Fleaflicker: returns the season, season average, and standard deviation
#'
#' @examples
#' \donttest{
#'
#' conn <- fleaflicker_connect(2020,312861)
#' x <- ff_playerscores(conn)
#'
#' }
#' @export
ff_playerscores.flea_conn <- function(conn, ...) {

  result_offset <- 0

  initial_results <- fleaflicker_getendpoint(
    endpoint = "FetchPlayerListing",
    sport = "NFL",
    league_id = conn$league_id,
    external_id_type = "SPORTRADAR",
    result_offset = result_offset) %>%
    purrr::pluck('content')

  players <- initial_results$players

  result_offset <- initial_results[['resultOffsetNext']]

  rm(initial_results)

  while(!is.null(result_offset)){

    results <- fleaflicker_getendpoint(endpoint = "FetchPlayerListing",
                                       sport = "NFL",
                                       league_id = conn$league_id,
                                       external_id_type = "SPORTRADAR",
                                       result_offset = result_offset) %>%
      purrr::pluck('content')

    players <- c(players,results$players)

    result_offset <- results[['resultOffsetNext']]

    rm(results)
  }

  df_players <- players %>%
    tibble::tibble() %>%
    tidyr::hoist(1,
                 "player"="proPlayer",
                 "score_total"="seasonTotal",
                 "score_avg"="seasonAverage",
                 "score_sd"="seasonsStandartDeviation") %>%
    tidyr::hoist("player",
                 "player_id"="id",
                 "player_name"="nameFull",
                 "pos"="position",
                 "team"="proTeamAbbreviation") %>%
    dplyr::mutate(
      dplyr::across(c("score_total","score_avg","score_sd"),
                    purrr::map_dbl,
                    ~ purrr::pluck(.x,"value",.default = NaN) %>% round(2))) %>%
    dplyr::select(dplyr::any_of(c(
      "player_id","player_name","pos","team",
      "score_total","score_avg","score_sd"
    )))

  return(df_players)

}