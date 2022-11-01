#### Sleeper TRANSACTIONS ####

#' Get full transactions table
#'
#' @param conn the list object created by `ff_connect()`
#' @param week A week filter for transactions - 1 returns all offseason transactions. Default 1:17 returns all transactions.
#' @param ... additional args for other methods
#'
#' @describeIn ff_transactions Sleeper: returns all transactions, including free agents, waivers, and trades.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_transactions(jml_conn, week = 1:2)
#' }) # end try
#' }
#'
#' @export
ff_transactions.sleeper_conn <- function(conn, week = 1:17, ...) {
  checkmate::assert_numeric(week, lower = 1, upper = 21)

  max_week <- sleeper_getendpoint(glue::glue("league/{conn$league_id}")) %>%
    purrr::pluck("content", "settings", "last_scored_leg")

  max_week <- max_week %||% 1

  week <- week[week <= max_week]

  raw_transactions <- glue::glue("league/{conn$league_id}/transactions/{week}") %>%
    purrr::map_dfr(.sleeper_raw_transactions)

  transaction_functions <- list(
    free_agent = .sleeper_transactions_freeagent,
    waiver = .sleeper_transactions_waiver,
    trade = .sleeper_transactions_trade
  )

  players_endpoint <- sleeper_players() %>%
    dplyr::select("player_id", "player_name", "pos", "team")

  transactions <- purrr::map_dfr(transaction_functions, rlang::exec, raw_transactions) %>%
    dplyr::arrange(dplyr::desc(.data$timestamp)) %>%
    dplyr::left_join(
      players_endpoint,
      by = "player_id"
    ) %>%
    dplyr::left_join(
      ff_franchises(conn) %>%
        dplyr::select("franchise_id", "franchise_name") %>%
        dplyr::mutate_at("franchise_id", as.character),
      by = c("franchise_id" = "franchise_id")
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "timestamp", "type", "type_desc",
        "franchise_id", "franchise_name",
        "player_id", "player_name", "pos", "team",
        "bbid_amount", "trade_partner", "comments"
      )),
      dplyr::everything()
    )

  return(transactions)
}

.sleeper_raw_transactions <- function(url) {
  url %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1)
}

.sleeper_transactions_freeagent <- function(raw_transactions) {
  fa_transactions <- raw_transactions %>%
    dplyr::filter(.data$type == "free_agent", .data$status == "complete")

  if (nrow(fa_transactions) == 0) {
    return(NULL)
  }

  name_vector <- c("status_updated", "type", "roster_ids", "adds", "drops")

  if (any(!name_vector %in% names(fa_transactions))) {
    name_vector <- name_vector[!name_vector %in% names(fa_transactions)]

    x <- matrix(
      ncol = length(name_vector),
      dimnames = list(NULL, name_vector)
    ) %>%
      as.data.frame()

    fa_transactions <- fa_transactions %>%
      tibble::add_column(x)
  }

  fa_transactions <- fa_transactions %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp" = "status_updated",
      "type",
      "franchise_id" = "roster_ids",
      "added" = "adds",
      "dropped" = "drops"
    ))) %>%
    dplyr::mutate(
      added = purrr::map(.data$added, names),
      added = purrr::map(.data$added, ~ replace(.x, is.null(.x), NA_character_)),
      dropped = purrr::map(.data$dropped, names),
      dropped = purrr::map(.data$dropped, ~ replace(.x, is.null(.x), NA_character_)),
      franchise_id = purrr::map_chr(.data$franchise_id, ~as.character(unlist(.x))),
      timestamp = .data$timestamp / 1000,
      timestamp = .as_datetime(.data$timestamp)
    ) %>%
    tidyr::pivot_longer(
      cols = c("added", "dropped"),
      names_to = "type_desc",
      values_to = "player_id"
    ) %>%
    tidyr::unnest("player_id") %>%
    dplyr::filter(!is.na(.data$player_id))

  return(fa_transactions)
}

.sleeper_transactions_waiver <- function(raw_transactions) {
  waiver_transactions <- raw_transactions %>%
    dplyr::filter(.data$type == "waiver")

  if (nrow(waiver_transactions) == 0) {
    return(NULL)
  }

  name_vector <- c("status_updated", "type", "roster_ids", "adds", "drops")

  if (any(!name_vector %in% names(waiver_transactions))) {
    name_vector <- name_vector[!name_vector %in% names(waiver_transactions)]

    x <- matrix(
      ncol = length(name_vector),
      dimnames = list(NULL, name_vector)
    ) %>%
      as.data.frame()

    waiver_transactions <- waiver_transactions %>%
      tibble::add_column(x)
  }

  df_waivers <- waiver_transactions %>%
    tidyr::unnest_wider("settings") %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp" = "status_updated",
      "type",
      "franchise_id" = "roster_ids",
      "added" = "adds",
      "dropped" = "drops",
      "bbid_amount" = "waiver_bid",
      "waiver_priority" = "priority",
      "waiver_status" = "status",
      "settings",
      "metadata"
    ))) %>%
    dplyr::mutate(
      added = purrr::map(.data$added, names),
      added = purrr::map(.data$added, ~ replace(.x, is.null(.x), NA_character_)),
      dropped = purrr::map(.data$dropped, names),
      dropped = purrr::map(.data$dropped, ~ replace(.x, is.null(.x), NA_character_)),
      franchise_id = purrr::map_chr(.data$franchise_id, ~as.character(unlist(.x))),
      timestamp = .data$timestamp / 1000,
      timestamp = .as_datetime(.data$timestamp),
      comment = purrr::map_chr(.data$metadata, `[[`, "notes")
    ) %>%
    tidyr::pivot_longer(
      cols = c("added", "dropped"),
      names_to = "type_desc",
      values_to = "player_id"
    ) %>%
    tidyr::unnest("player_id") %>%
    dplyr::filter(!is.na(.data$player_id)) %>%
    dplyr::mutate(
      type = paste(.data$type, .data$waiver_status, sep = "_"),
      comment = ifelse(.data$waiver_status == "complete", NA_character_, .data$comment)
    ) %>%
    dplyr::mutate_at(
      dplyr::vars(dplyr::contains("bbid_amount")),
      ~ dplyr::case_when(
        .data$type_desc == "dropped" ~ NA_integer_,
        TRUE ~ .x
      )
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "timestamp",
        "type",
        "franchise_id",
        "type_desc",
        "player_id",
        "bbid_amount",
        "waiver_priority",
        "comment"
      ))
    )
}



.sleeper_transactions_trade <- function(raw_transactions) {
  trade_transactions_r <- raw_transactions %>%
    dplyr::filter(.data$type == "trade")

  if (nrow(trade_transactions_r) == 0) {
    return(NULL)
  }

  name_vector <- c("status_updated", "type", "roster_ids", "adds", "drops", "draft_picks", "waiver_budget")

  if (any(!name_vector %in% names(trade_transactions_r))) {
    name_vector <- name_vector[!name_vector %in% names(trade_transactions_r)]

    x <- matrix(
      ncol = length(name_vector),
      dimnames = list(NULL, name_vector)
    ) %>%
      as.data.frame()

    trade_transactions_r <- trade_transactions_r %>%
      tibble::add_column(x)
  }

  trade_transactions <- trade_transactions_r %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp" = "status_updated",
      "type",
      "status",
      "adds",
      "drops",
      "draft_picks",
      "waiver_budget"
    ))) %>%
    dplyr::mutate(
      timestamp = (.data$timestamp / 1000) %>% .as_datetime(),
      adds = purrr::map(
        .data$adds,
        ~ tibble::enframe(.x,
          name = "traded_for",
          value = "franchise_id"
        ) %>%
          tidyr::pivot_longer("traded_for",
            names_to = "type_desc",
            values_to = "player_id"
          ) %>%
          dplyr::mutate_all(as.character)
      ),
      drops = purrr::map(
        .data$drops,
        ~ tibble::enframe(.x,
          name = "traded_away",
          value = "franchise_id"
        ) %>%
          tidyr::pivot_longer("traded_away",
            names_to = "type_desc",
            values_to = "player_id"
          ) %>%
          dplyr::mutate_all(as.character)
      ),
      draft_picks = purrr::map_if(
        .data$draft_picks,
        is.list,
        ~ tibble::tibble(.x) %>%
          tidyr::unnest_wider(1) %>%
          dplyr::mutate(player_id = paste(.data$season,
            "round",
            .data$round,
            "pick_from_franchise",
            roster_id,
            sep = "_"
          )) %>%
          dplyr::select(
            "traded_for" = "owner_id",
            "traded_away" = "previous_owner_id",
            "player_id"
          ) %>%
          tidyr::pivot_longer(c("traded_for", "traded_away"),
            names_to = "type_desc",
            values_to = "franchise_id"
          ) %>%
          dplyr::mutate_all(as.character)
      ),
      waiver_budget = purrr::map_if(
        .data$waiver_budget,
        is.list,
        ~ tibble::tibble(.x) %>%
          tidyr::unnest_wider(1) %>%
          tidyr::pivot_longer(c("sender", "receiver"),
            names_to = "role",
            values_to = "franchise_id"
          ) %>%
          dplyr::mutate(
            bbid_amount = dplyr::case_when(
              .data$role == "sender" ~ -.data$amount,
              .data$role == "receiver" ~ .data$amount
            ),
            franchise_id = as.character(.data$franchise_id),
            player_id = paste0("bbid_", bbid_amount),
            type_desc = dplyr::case_when(
              .data$role == "sender" ~ "traded_away",
              .data$role == "receiver" ~ "traded_for"
            )
          ) %>%
          dplyr::select("franchise_id", "type_desc", "player_id", "bbid_amount")
      )
    ) %>%
    tidyr::pivot_longer(
      c("adds", "drops", "draft_picks", "waiver_budget"),
      names_to = "name",
      values_to = "value"
    ) %>%
    dplyr::filter(!is.na(.data$value)) %>%
    tidyr::unnest("value") %>%
    dplyr::select(-"name", -"status") %>%
    dplyr::group_by(.data$timestamp) %>%
    dplyr::mutate(
      trade_partner = list(unique(.data$franchise_id)),
      trade_partner = purrr::map2(
        .data$trade_partner,
        .data$franchise_id,
        ~ .x[!.x %in% .y]
      ) %>% as.character()
    ) %>%
    dplyr::ungroup()

  return(trade_transactions)
}
