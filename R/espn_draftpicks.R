#### ff_draftpicks - ESPN ####

#' ESPN Draft Picks
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_draftpicks ESPN: does not support future/draft pick trades - for draft results, please use ff_draft.
#'
#' @examples
#' \donttest{
#' conn <- espn_connect(
#'   season = 2018,
#'   league_id = 1178049,
#'   espn_s2 = Sys.getenv("TAN_ESPN_S2"),
#'   swid = Sys.getenv("TAN_SWID")
#' )
#'
#' ff_draftpicks(conn)
#' }
#'
#' @export
ff_draftpicks.espn_conn <- function(conn, ...) {
  rlang::warn("ESPN does not support draft pick trades. For draft results, please use ff_draft()")

  return(NULL)
}
