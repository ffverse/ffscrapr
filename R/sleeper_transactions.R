#### Sleeper TRANSACTIONS ####

#' Get full transactions table
#'
#' @param conn the list object created by \code{ff_connect()}
#' @param week A week filter for transactions - 1 returns all offseason transactions. Default 1:17 returns all transactions.
#' @param ... additional args for other methods
#'
#' @describeIn ff_transactions Sleeper: returns all transactions, including free agents, waivers, and trades.
#'
#' @examples
#' jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#' ff_transactions(jml_conn)
#' @export
ff_transactions.sleeper_conn <- function(conn,week = 1:17, ...) {

  checkmate::assert_numeric(week, lower = 1, upper = 21)

  max_week <- sleeper_getendpoint(glue::glue("league/{conn$league_id}")) %>%
    purrr::pluck("content", "settings", "last_scored_leg")

  week <- week[week <= max_week]

  raw_transactions <- glue::glue("league/{conn$league_id}/transactions/{week}") %>%
    purrr::map_dfr(.sleeper_raw_transactions)

  transaction_functions <- list(
    free_agent = .mfl_transactions_freeagent,
    waiver = .mfl_transactions_bbid_waiver,
    trade = .mfl_transactions_trade
  )

  players_endpoint <- sleeper_players() %>%
    dplyr::select("player_id", "player_name", "pos", "team")

  purrr::map_dfr(transaction_functions, rlang::exec, raw_transactions) %>%
    dplyr::arrange(dplyr::desc(.data$timestamp)) %>%
    dplyr::left_join(
      players_endpoint,
      by = "player_id"
    ) %>%
    dplyr::left_join(
      dplyr::select(ff_franchises(conn), "franchise_id", "franchise_name"),
      by = c("franchise" = "franchise_id")
    ) %>%
    dplyr::select(
      dplyr::any_of(c("timestamp", "type", "type_desc",
                      "franchise_id" = "franchise", "franchise_name",
                      "player_id", "player_name", "pos", "team",
                      "bbid_spent", "trade_partner", "comments"
      )),
      dplyr::everything()
    )

}

.sleeper_raw_transactions <- function(url){

  url %>%
    sleeper_getendpoint() %>%
    purrr::pluck('content') %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1)

}

.sleeper_transactions_freeagent <- function(raw_transactions){

  fa_transactions <- raw_transactions %>%
    dplyr::filter(.data$type == "free_agent",.data$status == "complete")

  if(nrow(fa_transactions) == 0) return(NULL)

  name_vector <- c('status_updated','type','roster_ids','adds','drops')

  if(any(!name_vector %in% names(fa_transactions))){

    name_vector <- name_vector[!name_vector %in% names(fa_transactions)]

    x <- matrix(ncol = length(name_vector)) %>%
      as.data.frame() %>%
      setNames(name_vector)

    fa_transactions <- fa_transactions %>%
      tibble::add_column(x)

  }

  fa_transactions <- fa_transactions %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp" = "status_updated",
      "type",
      "roster_id" = "roster_ids",
      "added" = "adds",
      "dropped" = "drops"
    ))) %>%
    dplyr::mutate(
      added = purrr::map(.data$added, names),
      added = purrr::map(.data$added,~replace(.x,is.null(.x),NA_character_)),
      dropped = purrr::map(.data$dropped, names),
      dropped = purrr::map(.data$dropped,~replace(.x,is.null(.x),NA_character_)),
      roster_id = purrr::map_chr(.data$roster_id,unlist),
      timestamp = .data$timestamp/1000,
      timestamp = lubridate::as_datetime(.data$timestamp)
    ) %>%
    tidyr::pivot_longer(cols = c('added','dropped'),
                        names_to = 'type_desc',
                        values_to = "player_id") %>%
    tidyr::unnest("player_id") %>%
    dplyr::filter(!is.na(.data$player_id))

  return(fa_transactions)
}

.sleeper_transactions_waiver <- function(raw_transactions){

  waiver_transactions <- raw_transactions %>%
    dplyr::filter(.data$type == "waiver") %>%
    tidyr::unnest_wider('settings') %>%
    dplyr::rename(dplyr::any_of(c(
      "timestamp" = "status_updated",
      "type",
      "roster_id" = "roster_ids",
      "added" = "adds",
      "dropped" = "drops",
      "bbid_spent" = "waiver_bid",
      "waiver_status" = "status",
      "metadata"
    ))) %>%
    dplyr::mutate(
      added = purrr::map(.data$added, names),
      added = purrr::map_chr(.data$added,~replace(.x,is.null(x),NA_character_)),
      dropped = purrr::map(.data$dropped, names),
      dropped = purrr::map_chr(.data$dropped,~replace(.x,is.null(.x),NA_character_)),
      roster_id = purrr::map_chr(.data$roster_id,unlist),
      timestamp = .data$timestamp/1000,
      timestamp = lubridate::as_datetime(.data$timestamp),
      metadata = purrr::map_chr(.data$metadata,unlist),
      type = dplyr::case_when(
        .data$waiver_status == "failed"~ paste0(.data$type,"_",.data$waiver_status),
        TRUE ~ .data$type)
    ) %>%
    tidyr::pivot_longer(cols = c('added','dropped'),
                        names_to = 'type_desc',
                        values_to = "player_id") %>%
    tidyr::unnest("player_id") %>%
    dplyr::filter(!is.na(.data$player_id))

}
