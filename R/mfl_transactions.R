#### MFL TRANSACTIONS ####

#' Get full transactions table
#'
#' Create a cleaned table of MFL transactions
#'
#' @param conn the list object created by \code{ff_connect()}
#' @param ... additional args
#'
#' @rdname ff_transactions
#'
#' @examples
#' dlf_conn <- mfl_connect(2020,league_id = 37920)
#' ff_transactions(dlf_conn)
#'
#' @return a tibble detailing every transaction since X date
#' @export

ff_transactions.mfl_conn <- function(conn,...){

  df_transactions <- mfl_getendpoint(conn,"transactions") %>%
    purrr::pluck("content",'transactions','transaction') %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::mutate_at('timestamp',~as.numeric(.x) %>% lubridate::as_datetime())

  transaction_functions <- list(
    auction = .mfl_transactions_auction,
    trade = .mfl_transactions_trade
  )

  purrr::map_dfr(transaction_functions,rlang::exec,df_transactions) %>%
    arrange(desc(.data$timestamp))

}

## AUCTION ##
#' @noRd
#' @keywords internal

.mfl_transactions_auction <- function(df_transactions){

  auction_transactions <- df_transactions %>%
    dplyr::filter(.data$type %in% c('AUCTION_INIT','AUCTION_BID','AUCTION_WON'))

  if(nrow(auction_transactions)==0){return(NULL)}

  auction_transactions %>%
    dplyr::select('timestamp','type','franchise','transaction') %>%
    tidyr::separate('transaction',into = c('player_id','bid_amount','comments'),sep = "\\|") %>%
    dplyr::mutate('comments' = ifelse(stringr::str_length(.data$comments)==0,
                                      NA_character_,
                                      .data$comments)) %>%
    dplyr::left_join(
      dplyr::select(mfl_players(),'player_id','player_name','pos','age','team'),
      by = 'player_id'
    )
  }

## TRADE ##
# Create a tibble where each team's transaction is represented in one line
#' @noRd
#' @keywords internal

.mfl_transactions_trade <- function(df_transactions){

  trade_transactions <- df_transactions %>%
    dplyr::filter(.data$type == "TRADE")

  if(nrow(trade_transactions)==0){return(NULL)}

  parsed_trades <- trade_transactions %>%
    dplyr::select('timestamp','type',
                  'franchise','franchise1_gave_up',
                  'franchise2','franchise2_gave_up',
                  'comments') %>%
    dplyr::mutate_at(c('franchise1_gave_up','franchise2_gave_up'),~stringr::str_replace(.x,",$","")) %>%
    dplyr::mutate_at(c('franchise1_gave_up','franchise2_gave_up'),~stringr::str_split(.x,","))

  df <- dplyr::select(parsed_trades,
                .data$timestamp,
                .data$type,
                'franchise'=.data$franchise2,
                'franchise2'=.data$franchise,
                'franchise1_gave_up'=.data$franchise2_gave_up,
                'franchise2_gave_up'=.data$franchise1_gave_up,
                .data$comments) %>%
    dplyr::bind_rows(parsed_trades) %>%
    dplyr::rename('trade_partner' = .data$franchise2,
                  'traded_for' = .data$franchise2_gave_up,
                  'traded_away' = .data$franchise1_gave_up) %>%
    dplyr::arrange(desc(.data$timestamp))


}


## Will need to write functions to parse each of these, then row bind them back together afterwards.
# WAIVER
# BBID_WAIVER
# BBID_AUTO_PROCESS_WAIVERS
# FREE_AGENT
# WAIVER_REQUEST
# BBID_WAIVER_REQUEST
# TRADE
# IR
# TAXI
# SURVIVOR_PICK
# POOL_PICK
