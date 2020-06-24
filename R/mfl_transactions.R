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

  df <- mfl_getendpoint(conn,"transactions") %>%
    purrr::pluck("content",'transactions','transaction') %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::mutate_at('timestamp',~as.numeric(.x) %>% lubridate::as_datetime())# %>%
    # dplyr::mutate_at('transaction',~stringr::str_split(.x,"\\|"))

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
# AUCTION_INIT
# AUCTION_BID
# AUCTION_WON
# SURVIVOR_PICK
# POOL_PICK
