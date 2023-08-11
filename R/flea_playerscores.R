#### Fleaflicker Player Scores ####

#' Fleaflicker Player Scores
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (for other platform/methods)
#' @param page_limit A numeric describing the number of pages to return - default NULL returns all available
#'
#' @describeIn ff_playerscores Fleaflicker: returns the season, season average, and standard deviation
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(2020, 312861)
#'   ff_playerscores(conn, page_limit = 2)
#' }) # end try
#' }
#' @export
ff_playerscores.flea_conn <- function(conn, page_limit = NULL, ...) {
  result_offset <- 0
  page_count <- 1
  if (is.null(page_limit)) page_limit <- Inf

  initial_results <- fleaflicker_getendpoint(
    endpoint = "FetchPlayerListing",
    sport = "NFL",
    league_id = conn$league_id,
    sort_season = conn$season,
    external_id_type = "SPORTRADAR",
    result_offset = result_offset
  ) %>%
    purrr::pluck("content")

  players <- initial_results$players

  result_offset <- initial_results[["resultOffsetNext"]]

  rm(initial_results)

  while (!is.null(result_offset) && page_count < page_limit) {
    results <- fleaflicker_getendpoint(
      endpoint = "FetchPlayerListing",
      sport = "NFL",
      league_id = conn$league_id,
      sort_season = conn$season,
      external_id_type = "SPORTRADAR",
      result_offset = result_offset
    ) %>%
      purrr::pluck("content")

    players <- c(players, results$players)

    result_offset <- results[["resultOffsetNext"]]

    page_count <- page_count + 1

    rm(results)
  }

  df_players <- players %>%
    tibble::tibble() %>%
    tidyr::hoist(1,
      "player" = "proPlayer",
      "score_total" = "seasonTotal",
      "score_avg" = "seasonAverage",
      "score_sd" = "seasonsStandartDeviation"
    ) %>%
    tidyr::hoist("player",
      "player_id" = "id",
      "player_name" = "nameFull",
      "pos" = "position",
      "team" = "proTeamAbbreviation"
    ) %>%
    dplyr::mutate(
      dplyr::across(
        c("score_total", "score_avg", "score_sd"),
        purrr::map_dbl,
        ~ purrr::pluck(.x, "value", .default = NA) %>% round(2)
      ),
      games = (.data$score_total / .data$score_avg) %>% round()
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "player_id", "player_name", "pos", "team", "games",
      "score_total", "score_avg", "score_sd"
    )))

  return(df_players)
}
