#### espn MY LEAGUES ####

#' Get User Leagues
#'
#' @param conn a connection object created by `ff_connect()`
#' @param ... arguments that may be passed to other methods (for method consistency)
#'
#' @describeIn ff_userleagues ESPN: does not support a lookup of user leagues by email or user ID at this time.
#'
#' @export

ff_userleagues.espn_conn <- function(conn = NULL, ...) {
  rlang::warn("ESPN does not support looking up leagues by user.")

  return(NULL)
}
