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

.sleeper_currentdraft <- function(draft_id) {
  picks_content <- glue::glue("draft/{draft_id}/picks") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content")

  # Check length of picks_content object to filter out empty drafts
  if(length(picks_content) == 0) return(data.frame(franchise_id = integer(),
                                                   player_id = character()))

  picks <-
    picks_content %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "round","pick_no", "draft_slot", "roster_id", "player_id", "metadata") %>%
    tidyr::hoist("metadata", "auction_amount" = "amount") %>%
    dplyr::mutate(
      auction_amount = if(all(is.na(.data$auction_amount))) NULL else as.numeric(.data$auction_amount),
      roster_id = ifelse(!is.na(.data$roster_id), .data$roster_id, .data$draft_slot)
    ) %>%
    dplyr::select(
      dplyr::any_of(
        c(
          "round",
          "pick" = "pick_no",
          "franchise_id" = "roster_id",
          "player_id",
          "auction_amount"
        )
      )
    )

  return(picks)
}

#' Get Sleeper Draft
#'
#' This function retrieves drafts by sleeper's draft ID. This better supports
#' mock drafts.
#'
#' @param draft_id draft ID as found in URL e.g. "https://sleeper.com/draft/nfl/{draft_id}"
#'
#' @export
#' @return draft dataframe
sleeper_draft <- function(draft_id){

  draft_id <- as.character(draft_id)

  draft_endpoint <- glue::glue("draft/{draft_id}") %>%
    sleeper_getendpoint()

  players_endpoint <- sleeper_players() %>%
    dplyr::select("player_id", "player_name", "pos", "team", "age")

  franchise_endpoint <- data.frame(
    franchise_id = integer(),
    franchise_name = character()
  )

  if(!is.null(draft_endpoint$content$league_id)){
    franchise_endpoint <- sleeper_connect(
      season = draft_endpoint$content$season,
      league_id = as.character(draft_endpoint$content$league_id)
    ) %>%
      ff_franchises() %>%
      dplyr::select("franchise_id", "franchise_name")
  }

  picks <- .sleeper_currentdraft(draft_id) %>%
    dplyr::left_join(franchise_endpoint, by = "franchise_id") %>%
    dplyr::left_join(players_endpoint, by = "player_id") %>%
    dplyr::mutate(
      draft_id = draft_id,
      status = draft_endpoint$content$status,
      type = draft_endpoint$content$metadata$type,
      franchise_name = ifelse(is.na(franchise_name), paste("Team",franchise_id), franchise_name)
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
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
      ))
    )

  return(picks)

}
