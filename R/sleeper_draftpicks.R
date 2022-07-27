#### ff_draftpicks - Sleeper ####

#' Sleeper Draft Picks
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_draftpicks Sleeper: retrieves current and future draft picks
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_draftpicks(jml_conn)
#' }) # end try
#' }
#' @export

ff_draftpicks.sleeper_conn <- function(conn, ...) {

  current_drafts <- glue::glue("league/{conn$league_id}/drafts") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content") %>%
    purrr::map(`[`, c("draft_id", "season", "status", "draft_order")) %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::filter(.data$status != "complete")

  include_current <- nrow(current_drafts) > 0

  # check on current drafts.
  # if there are incomplete drafts, add current season to future pick seasons

  future_picks <- .sleeper_futurepicks(conn, include_current = include_current)

  picks <- dplyr::bind_rows(current_drafts, future_picks) %>%
    dplyr::left_join(
      ff_franchises(conn) %>% dplyr::select("franchise_id", "franchise_name"),
      by = "franchise_id"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "season", "franchise_id", "franchise_name",
      "round", "pick", "original_franchise_id"
    )))

  return(picks)
}

.sleeper_currentpicks <- function(conn) {
  current_drafts <- glue::glue("league/{conn$league_id}/drafts") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content") %>%
    purrr::map_dfr(`[`, c("draft_id", "season", "status")) %>%
    dplyr::filter(.data$status != "complete") %>%
    dplyr::mutate(picks = purrr::map(.data$draft_id, .sleeper_currentdraft)) %>%
    tidyr::unnest("picks") %>%
    dplyr::select(dplyr::any_of(c(
      "season", "round", "pick", "franchise_id"
    )))

  return(current_drafts)
}

.sleeper_currentdraft <- function(draft_id) {
  picks <- glue::glue("draft/{draft_id}/picks") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content") %>%
    purrr::map(`[`, c("round", "draft_slot", "roster_id", "player_id", "metadata")) %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::hoist("metadata", "auction_amount" = "amount") %>%
    dplyr::select(dplyr::any_of(c("round", "pick" = "draft_slot", "franchise_id" = "roster_id", "player_id", "auction_amount")))

  if (all(is.na(picks$auction_amount))) {
    picks$auction_amount <- NULL
  } else {
    picks$auction_amount <- as.numeric(picks$auction_amount)
  }

  return(picks)
}

.sleeper_futurepicks <- function(conn, include_current = FALSE) {
  league_settings <- glue::glue("league/{conn$league_id}") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content")

  draft_rounds <- league_settings %>%
    purrr::pluck("settings", "draft_rounds")

  draft_rounds <- seq_len(draft_rounds)

  # Seems to be that you can only trade three years in advance, hard-coded into the platform
  seasons <- league_settings %>%
    purrr::pluck("season") %>%
    as.numeric() %>%
    {
      function(.x) seq.int(.x + 1, .x + 3, 1)
    }() %>%
    as.character()

  franchises <- ff_franchises(conn) %>%
    dplyr::select("franchise_id")

  traded_picks <- glue::glue("league/{conn$league_id}/traded_picks") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content") %>%
    dplyr::bind_rows() %>%
    dplyr::select(dplyr::any_of(c(
      "season",
      "round",
      "original_franchise_id" = "roster_id",
      "franchise_id" = "owner_id"
    ))) %>%
    dplyr::filter(.data$season %in% seasons)

  future_picks <- tidyr::crossing(
    season = seasons,
    round = draft_rounds,
    franchises
  ) %>%
    dplyr::mutate("original_franchise_id" = .data$franchise_id) %>%
    dplyr::anti_join(traded_picks, by = c("original_franchise_id", "season", "round")) %>%
    dplyr::bind_rows(traded_picks) %>%
    dplyr::arrange(.data$franchise_id, .data$season, .data$round)

  return(future_picks)
}
