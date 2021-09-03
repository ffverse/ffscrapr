#' Fleaflicker players library
#'
#' A cached table of Fleaflicker NFL players. Will store in memory for each session!
#' (via memoise in zzz.R)
#'
#' @param conn a conn object created by `ff_connect()`
#' @param page_limit A number limiting the number of players to return, or NULL (default) returns all
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(2020, 312861)
#'   player_list <- fleaflicker_players(conn, page_limit = 2)
#' }) # end try
#' }
#'
#' @return a dataframe containing all ~7000+ players in the Fleaflicker database
#' @export

fleaflicker_players <- function(conn, page_limit = NULL) {
  result_offset <- 0
  page_count <- 1

  if (is.null(page_limit)) page_limit <- Inf

  initial_results <- fleaflicker_getendpoint(
    endpoint = "FetchPlayerListing",
    sport = "NFL",
    league_id = conn$league_id,
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
    tidyr::hoist(1, "player" = "proPlayer") %>%
    tidyr::hoist("player",
      "player_id" = "id",
      "player_name" = "nameFull",
      "team" = "proTeamAbbreviation",
      "pos" = "position",
      "sportradar_id" = "externalIds",
      "position_eligibility" = "positionEligibility"
    ) %>%
    dplyr::select(
      "player_id",
      "player_name",
      "team",
      "pos",
      "sportradar_id",
      "position_eligibility"
    ) %>%
    dplyr::mutate(
      "sportradar_id" = purrr::map_chr(.data$sportradar_id, unlist),
      "position_eligibility" = purrr::map(.data$position_eligibility, unlist) %>% as.character()
    )


  return(df_players)
}
