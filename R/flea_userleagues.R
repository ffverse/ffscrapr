#### flea MY LEAGUES ####

#' Get User Leagues
#'
#' @param conn a connection object created by `ff_connect()`
#' @param user_email the username to look up - defaults to user created in conn if available
#' @param season the season to look up leagues for
#' @param ... arguments that may be passed to other methods (for method consistency)
#'
#' @describeIn ff_userleagues flea: returns a listing of leagues for a given user_email
#'
#' @seealso [fleaflicker_userleagues()] to call this function for flea leagues without first creating a connection object.
#'
#' @export

ff_userleagues.flea_conn <- function(conn = NULL, user_email = NULL, season = NULL, ...) {
  if (is.null(user_email) && is.null(conn)) {
    stop("Please supply either a user_email or a flea_conn object!")
  }

  if (is.null(user_email) && !is.null(conn)) user_email <- conn$user_email

  if (is.null(season) && !is.null(conn)) season <- conn$season

  fleaflicker_userleagues(user_email, season)
}

#' Fleaflicker - Get User Leagues
#'
#' This function returns the leagues that a specific user is in.
#' This variant can be used without first creating a connection object.
#'
#' @param user_email the username to look up
#' @param season the season to return leagues from - defaults to current year based on heuristics
#'
#' @seealso [ff_userleagues()]
#'
#' @return a dataframe of leagues for the specified user
#' @export

fleaflicker_userleagues <- function(user_email, season = NULL) {
  if (is.null(season)) season <- .fn_choose_season()

  df_leagues <- fleaflicker_getendpoint("FetchUserLeagues", email = user_email, season = season, sport = "NFL") %>%
    purrr::pluck("content", "leagues") %>%
    purrr::map(`[`, c("name", "id", "ownedTeam")) %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::rename(
      league_name = "name",
      league_id = "id"
    ) %>%
    tidyr::hoist("ownedTeam", "franchise_id" = "id", "franchise_name" = "name") %>%
    dplyr::select(-"ownedTeam")

  return(df_leagues)
}
