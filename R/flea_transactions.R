#### Fleaflicker TRANSACTIONS ####

#' Get full transactions table
#'
#' @param conn the list object created by `ff_connect()`
#' @param franchise_id fleaflicker returns transactions grouped by franchise id, pass a list here to filter
#' @param ... additional args for other methods
#'
#' @describeIn ff_transactions Fleaflicker: returns all transactions, including free agents, waivers, and trades.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(season = 2020, league_id = 312861)
#'   ff_transactions(conn)
#' }) # end try
#' }
#'
#' @export
ff_transactions.flea_conn <- function(conn, franchise_id = NULL, ...) {
  franchises <- ff_franchises(conn)

  if (!is.null(franchise_id)) {
    franchises <- franchises %>%
      dplyr::filter(.data$franchise_id %in% .env$franchise_id)
  }

  raw_transactions <- franchises %>%
    dplyr::select("franchise_id") %>%
    dplyr::mutate(transactions = purrr::map(.data$franchise_id, .flea_team_transactions, conn)) %>%
    tidyr::unnest_longer("transactions") %>%
    tidyr::unnest_wider("transactions") %>%
    tidyr::hoist("transaction", "type", "franchise" = "team") %>%
    dplyr::mutate(
      timestamp = (as.numeric(.data$timeEpochMilli) / 1000) %>% .as_datetime(),
      timeEpochMilli = NULL,
      type = stringr::str_remove(.data$type, "TRANSACTION_") %>% tidyr::replace_na("ADD")
    )

  transactions_trade <- .flea_transactions_trade(conn)

  transaction_functions <- list(
    add = .flea_transactions_add,
    drop = .flea_transactions_drop,
    claim = .flea_transactions_claim
  )

  transactions <- purrr::map_dfr(transaction_functions, rlang::exec, raw_transactions) %>%
    dplyr::mutate(player_id = as.character(.data$player_id)) %>%
    dplyr::bind_rows(transactions_trade) %>%
    dplyr::arrange(dplyr::desc(.data$timestamp), .data$franchise_id)

  return(transactions)
}

.flea_team_transactions <- function(franchise_id, conn) {
  initial_results <- fleaflicker_getendpoint("FetchLeagueTransactions",
    league_id = conn$league_id,
    team_id = franchise_id,
    result_offset = 0
  ) %>%
    purrr::pluck("content")

  result_offset <- initial_results[["resultOffsetNext"]]

  items <- initial_results$items

  rm(initial_results)

  while (!is.null(result_offset)) {
    results <- fleaflicker_getendpoint(
      endpoint = "FetchLeagueTransactions",
      sport = "NFL",
      league_id = conn$league_id,
      team_id = franchise_id,
      result_offset = result_offset
    ) %>%
      purrr::pluck("content")

    items <- c(items, results$items)

    result_offset <- results[["resultOffsetNext"]]

    rm(results)
  }

  return(items)
}
.flea_transactions_add <- function(raw_transactions) {
  adds <- raw_transactions %>%
    dplyr::filter(.data$type == "ADD")

  if (nrow(adds) == 0) {
    return(NULL)
  }

  adds <- adds %>%
    tidyr::hoist("franchise", "franchise_id" = "id", "franchise_name" = "name") %>%
    dplyr::mutate(
      transaction = purrr::map(.data$transaction, purrr::pluck, "player", "proPlayer"),
      type = "free_agency",
      type_desc = "added"
    ) %>%
    tidyr::hoist("transaction",
      "player_id" = "id",
      "player_name" = "nameFull",
      "pos" = "position",
      "team" = "proTeamAbbreviation"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp",
      "type",
      "type_desc",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "team"
    )))

  return(adds)
}
.flea_transactions_drop <- function(raw_transactions) {
  drops <- raw_transactions %>%
    dplyr::filter(.data$type == "DROP")

  if (nrow(drops) == 0) {
    return(NULL)
  }

  drops <- drops %>%
    tidyr::hoist("franchise", "franchise_id" = "id", "franchise_name" = "name") %>%
    dplyr::mutate(
      transaction = purrr::map(.data$transaction, purrr::pluck, "player", "proPlayer"),
      type = "free_agency",
      type_desc = "dropped"
    ) %>%
    tidyr::hoist("transaction",
      "player_id" = "id",
      "player_name" = "nameFull",
      "pos" = "position",
      "team" = "proTeamAbbreviation"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp",
      "type",
      "type_desc",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "team"
    )))

  return(drops)
}
.flea_transactions_claim <- function(raw_transactions) {
  claims <- raw_transactions %>%
    dplyr::filter(.data$type == "CLAIM")

  if (nrow(claims) == 0) {
    return(NULL)
  }

  claims <- claims %>%
    tidyr::hoist("franchise", "franchise_id" = "id", "franchise_name" = "name") %>%
    tidyr::unnest_wider("transaction") %>%
    dplyr::mutate(player = purrr::map(.data$player, purrr::pluck, "proPlayer")) %>%
    tidyr::hoist("player",
      "player_id" = "id",
      "player_name" = "nameFull",
      "pos" = "position",
      "team" = "proTeamAbbreviation"
    ) %>%
    dplyr::select(-.data$player, -.data$franchise)

  if ("waiverResolutionTeams" %in% names(claims)) {
    claims <- claims %>%
      tidyr::unnest_longer("waiverResolutionTeams") %>%
      tidyr::hoist("waiverResolutionTeams", "loser") %>%
      dplyr::filter(is.na(.data$loser) | !.data$loser) %>%
      dplyr::mutate(waiverResolutionTeams = purrr::map_dbl(.data$waiverResolutionTeams,
        purrr::pluck, "team", "id",
        .default = NA
      )) %>%
      dplyr::filter(is.na(.data$waiverResolutionTeams) | .data$franchise_id == .data$waiverResolutionTeams)
  }

  claims <- claims %>%
    dplyr::mutate(
      type = "waiver",
      type_desc = "added"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp",
      "type",
      "type_desc",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "team",
      "bbid_amount" = "bbidAmount"
    )))

  return(claims)
}
.flea_transactions_trade <- function(conn) {
  initial_results <- fleaflicker_getendpoint("FetchTrades",
    league_id = conn$league_id,
    filter = "TRADES_COMPLETED",
    result_offset = 0
  ) %>%
    purrr::pluck("content")

  result_offset <- initial_results[["resultOffsetNext"]]

  items <- initial_results[["trades"]]

  rm(initial_results)

  while (!is.null(result_offset)) {
    results <- fleaflicker_getendpoint(
      endpoint = "FetchTrades",
      sport = "NFL",
      filter = "TRADES_COMPLETED",
      league_id = conn$league_id,
      result_offset = 80
    ) %>%
      purrr::pluck("content")

    items <- c(items, results$trades)

    result_offset <- results[["resultOffsetNext"]]

    rm(results)
  }

  if (length(items) == 0) {
    return(tibble::tibble())
  }

  trades <- items %>%
    purrr::map(`[`, c("id", "teams", "description", "status", "approvedOn")) %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::unnest_longer("teams") %>%
    tidyr::hoist("teams", "franchise" = "team", "playersObtained", "picksObtained", "playersReleased") %>%
    dplyr::mutate_at(c("playersObtained", "picksObtained", "playersReleased"), purrr::map, as.list) %>%
    tidyr::hoist("franchise", "franchise_id" = "id", "franchise_name" = "name") %>%
    dplyr::mutate(
      trade_id = .data$id,
      timestamp = (as.numeric(.data$approvedOn) / 1000) %>% .as_datetime()
    ) %>%
    dplyr::select(-"franchise", -"approvedOn")

  player_trades <- trades %>%
    dplyr::select("timestamp", "trade_id", "franchise_id", "franchise_name", "playersObtained") %>%
    tidyr::unnest_longer("playersObtained") %>%
    dplyr::mutate(playersObtained = purrr::map(.data$playersObtained, purrr::pluck, "proPlayer")) %>%
    tidyr::hoist("playersObtained", "player_id" = "id", "player_name" = "nameFull", "pos" = "position", "team" = "proTeamAbbreviation") %>%
    dplyr::filter(!is.na(.data$player_id)) %>%
    dplyr::mutate(
      type = "trade",
      player_id = as.character(.data$player_id)
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp",
      "type",
      "trade_id",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "team"
    )))

  if (nrow(player_trades) == 0) player_trades <- tibble::tibble()

  pick_trades <- trades %>%
    dplyr::select("timestamp", "trade_id", "franchise_id", "franchise_name", "picksObtained") %>%
    tidyr::unnest_longer("picksObtained") %>%
    dplyr::mutate_at("picksObtained", purrr::map, as.list) %>%
    tidyr::hoist("picksObtained", "season", "slot", "originalOwner", ) %>%
    dplyr::mutate_at(c("slot", "originalOwner"), purrr::map, as.list) %>%
    tidyr::hoist("slot", "round", ) %>%
    tidyr::hoist("originalOwner", "original_id" = "id", "original_name" = "name") %>%
    dplyr::filter(!is.na(.data$original_id)) %>%
    dplyr::mutate(
      player_id = glue::glue("{.data$season}_{.data$round}_{.data$original_id}"),
      player_name = glue::glue("{.data$season} round {.data$round} pick from {.data$original_name}"),
      pos = "PICK",
      type = "trade"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp",
      "type",
      "trade_id",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos"
    )))

  if (nrow(pick_trades) == 0) trade_cuts <- tibble::tibble()

  trade_cuts <- trades %>%
    dplyr::select("timestamp", "trade_id", "franchise_id", "franchise_name", "playersReleased") %>%
    tidyr::unnest_longer("playersReleased") %>%
    dplyr::mutate_at("playersReleased", purrr::map, as.list) %>%
    tidyr::hoist("playersReleased", "proPlayer") %>%
    dplyr::mutate_at(c("proPlayer"), purrr::map, as.list) %>%
    tidyr::hoist("proPlayer", "player_id" = "id", "player_name" = "nameFull", "pos" = "position", "team" = "proTeamAbbreviation") %>%
    dplyr::filter(!is.na(.data$player_id)) %>%
    dplyr::mutate(
      type = "free_agency",
      player_id = as.character(.data$player_id),
      type_desc = "dropped"
    ) %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp",
      "type",
      "trade_id",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "team"
    )))

  if (nrow(trade_cuts) == 0) trade_cuts <- tibble::tibble()

  df_trades <- dplyr::bind_rows(player_trades, pick_trades, trade_cuts) %>%
    dplyr::group_by(.data$timestamp, .data$type, .data$trade_id, .data$franchise_id, .data$franchise_name) %>%
    tidyr::nest() %>%
    dplyr::ungroup() %>%
    dplyr::rename("traded_for" = "data")

  crossing <- df_trades %>%
    dplyr::left_join(
      df_trades %>%
        dplyr::select("trade_id", "trade_partner_id" = "franchise_id", "trade_partner_name" = "franchise_name", "traded_away" = "traded_for"),
      by = "trade_id"
    ) %>%
    dplyr::filter(.data$franchise_id != .data$trade_partner_id) %>%
    tidyr::pivot_longer(c("traded_for", "traded_away"), names_to = "type_desc", values_to = "player") %>%
    tidyr::unnest("player") %>%
    dplyr::distinct(.data$trade_id, .data$franchise_id, .data$franchise_name, .data$type_desc, .data$player_id, .keep_all = TRUE) %>%
    dplyr::mutate(type_desc = dplyr::case_when(
      .data$type == "free_agency" ~ "dropped",
      TRUE ~ .data$type_desc
    )) %>%
    dplyr::select(dplyr::any_of(c(
      "timestamp",
      "type",
      "type_desc",
      "franchise_id",
      "franchise_name",
      "player_id",
      "player_name",
      "pos",
      "team",
      "trade_partner_id",
      "trade_partner_name",
      "trade_id"
    )))

  return(crossing)
}
