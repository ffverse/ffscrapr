#### ESPN TRANSACTIONS ####

#' Get full transactions table
#'
#' @param conn the list object created by `ff_connect()`
#' @param limit number of most recent transactions to return
#' @param ... additional args
#'
#' @describeIn ff_transactions ESPN: returns adds, drops, and trades. Requires private/auth-cookie.
#'
#' @examples
#' \dontrun{
#' # Marked as don't run because this endpoint requires private authentication
#'
#' conn <- espn_connect(
#'   season = 2020,
#'   league_id = 1178049,
#'   swid = Sys.getenv("TAN_SWID"),
#'   espn_s2 = Sys.getenv("TAN_ESPN_S2")
#' )
#' ff_transactions(conn)
#' }
#'
#' @export

ff_transactions.espn_conn <- function(conn, limit = 1000, ...) {
  if (conn$season < 2019) stop("Transactions not available before 2019")

  xff <- list(topics = list(
    filterType = list(value = list("ACTIVITY_TRANSACTIONS")),
    limit = limit,
    limitPerMessageSet = list(value = limit),
    filterIncludeMessageTypeIds = list(value = list(178, 180, 179, 239, 181, 244)),
    sortMessageDate = list(
      sortPriority = 1,
      sortAsc = FALSE
    )
  )) %>%
    jsonlite::toJSON(auto_unbox = TRUE)

  xff <- httr::add_headers(`x-fantasy-filter` = xff)

  url_query <- glue::glue(
    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/",
    "{conn$season}/segments/0/leagues/{conn$league_id}/",
    "communication/?view=kona_league_communication"
  )

  transactions_response <- espn_getendpoint_raw(conn, url_query, xff)

  all_transactions_list <- transactions_response %>%
    purrr::pluck("content", "topics")

  if (is.null(all_transactions_list)) {
    warning(glue::glue("No transactions found for {conn$season} - {conn$league_id}!"),
      call. = FALSE
    )

    return(NULL)
  }

  all_transactions <- all_transactions_list %>%
    tibble::tibble() %>%
    purrr::set_names("x") %>%
    tidyr::hoist("x", "messages", "date") %>%
    dplyr::mutate(
      timestamp = .as_datetime(.data$date / 1000),
      x = NULL
    ) %>%
    tidyr::unnest_longer("messages") %>%
    tidyr::hoist("messages", "from", "for", "to", "messageTypeId", "player_id" = "targetId") %>%
    dplyr::mutate(
      t = .espn_activity_map()[as.character(.data$messageTypeId)],
      franchise_id = dplyr::case_when(
        .data$messageTypeId == 244 ~ .data$from,
        .data$messageTypeId == 239 ~ .data[["for"]],
        TRUE ~ .data$to
      ),
      bbid_spent = dplyr::case_when(.data$messageTypeId == 180 ~ .data$from),
      trade_partner = dplyr::case_when(
        .data$messageTypeId == 244 ~ .data$to,
        TRUE ~ NA_integer_
      ),
      messages = NULL,
      date = NULL,
      `for` = NULL,
      `from` = NULL,
      `to` = NULL,
      `messageTypeId` = NULL
    ) %>%
    tidyr::separate("t", c("type", "type_desc"), sep = "\\|")

  if ("TRADE" %in% all_transactions$type) {
    trade_transactions <- all_transactions %>%
      dplyr::filter(.data$type == "TRADE") %>%
      dplyr::select(
        trade_partner = "franchise_id",
        franchise_id = "trade_partner",
        "player_id",
        "timestamp"
      ) %>%
      dplyr::mutate(type_desc = "traded_for")

    all_transactions <- dplyr::bind_rows(all_transactions, trade_transactions) %>%
      dplyr::arrange(dplyr::desc(.data$timestamp), .data$franchise_id)
  }

  players_endpoint <- espn_players(conn) %>%
    dplyr::select("player_id", "player_name", "pos", "team")

  franchises_endpoint <- ff_franchises(conn) %>%
    dplyr::select("franchise_id", "franchise_name")

  df_transactions <- all_transactions %>%
    dplyr::left_join(players_endpoint, by = "player_id") %>%
    dplyr::left_join(franchises_endpoint, by = "franchise_id") %>%
    dplyr::select(
      dplyr::any_of(c(
        "timestamp", "type", "type_desc",
        "franchise_id", "franchise_name",
        "player_id", "player_name", "pos", "team",
        "bbid_spent", "trade_partner"
      )),
      dplyr::everything()
    )

  return(df_transactions)
}
