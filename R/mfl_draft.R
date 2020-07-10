#### ff_draft (MFL) ####

#' Get a dataframe of draft results.
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @examples
#' ssb_conn <- ff_connect(platform = "mfl",league_id = 54040,season = 2020)
#' ff_rosters(ssb_conn)
#'
#'
#' @seealso \url{http://www03.myfantasyleague.com/2020/scoring_rules#rules}
#'
#' @rdname ff_draft
#' @export

# Notes on draft endpoint: "draft unit" can dictate handling of whether it's a "league" or "division" based draft

mfl_draft <- function(conn){

  df_draftresults <- mfl_getendpoint(conn,"draftResults")

}
