#### ff_draft (Sleeper) ####

#' Get Draft Results
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... args for other methods
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_draft(jml_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_draft Sleeper: returns a dataframe of all drafts and draft selections, if available.
#'
#' @export
ff_draft.sleeper_conn <- function(conn, ...) {
  franchise_endpoint <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  players_endpoint <- sleeper_players() %>%
    dplyr::select("player_id", "player_name", "pos", "team", "age")

  df_drafts <- sleeper_getendpoint(glue::glue("league/{conn$league_id}/drafts")) %>%
    purrr::pluck("content") %>%
    purrr::map_dfr(`[`, c("season", "draft_id", "league_id", "status", "type")) %>%
    dplyr::mutate(picks = purrr::map(.data$draft_id, .sleeper_currentdraft)) %>%
    tidyr::unnest("picks") %>%
    dplyr::left_join(franchise_endpoint, by = "franchise_id") %>%
    dplyr::left_join(players_endpoint, by = "player_id") %>%
    dplyr::select(dplyr::any_of(c(
      "draft_id",
      "status",
      "type",
      "season",
      "round",
      "pick",
      "auction_amount",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "age",
      "team"
    )))

  return(df_drafts)
}
