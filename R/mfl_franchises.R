#### ff_franchises (MFL) ####

#' Get a dataframe of franchise information
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @examples
#' ssb_conn <- ff_connect(platform = "mfl",league_id = 54040,season = 2020)
#' ff_franchises(ssb_conn)
#'
#' @rdname ff_franchises
#' @export

ff_franchises.mfl_conn <- function(conn){

  mfl_getendpoint(conn, "league") %>%
    purrr::pluck("content","league","franchises","franchise") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::rename("franchise_name" = .data$name,
                  "franchise_id" = .data$id) %>%
    dplyr::select('franchise_id','franchise_name',dplyr::everything())
}
