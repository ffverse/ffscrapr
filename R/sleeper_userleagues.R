#### SLEEPER MY LEAGUES ####

#' Get User Leagues
#'
#' @param conn a connection object created by `ff_connect()`
#' @param user_name the username to look up - defaults to user created in conn if available
#' @param season the season to look up leagues for
#' @param ... arguments that may be passed to other methods (for method consistency)
#'
#' @describeIn ff_userleagues Sleeper: returns a listing of leagues for a given user_id or user_name
#'
#' @seealso [sleeper_userleagues()] to call this function for Sleeper leagues without first creating a connection object.
#'
#' @export

ff_userleagues.sleeper_conn <- function(conn = NULL, user_name = NULL, season = NULL, ...) {
  if (!is.null(user_name)) {
    user_id <- .sleeper_userid(user_name)
  }

  if (is.null(user_name) && is.null(conn)) {
    stop("Please supply either a user_name or a Sleeper connection object!")
  }

  if (is.null(user_name)) {
    user_id <- conn$user_id
  }

  if (is.null(season) && !is.null(conn)) season <- conn$season

  if (is.null(season)) season <- .fn_choose_season()

  df_leagues <- sleeper_getendpoint(glue::glue("user/{user_id}/leagues/nfl/{season}")) %>%
    purrr::pluck("content") %>%
    purrr::map_dfr(`[`, c("name", "league_id")) %>%
    dplyr::rename(league_name = "name") %>%
    dplyr::mutate(
      league_id = as.character(league_id),
      franchise_name = purrr::map_chr(.data$league_id, .sleeper_userteams, user_id),
      franchise_id = user_id
    )

  return(df_leagues)
}

#' Sleeper - Get User Leagues
#'
#' This function returns the leagues that a specific user is in.
#' This variant can be used without first creating a connection object.
#'
#' @param user_name the username to look up
#' @param season the season to return leagues from - defaults to current year based on heuristics
#'
#' @seealso [ff_userleagues()]
#'
#' @return a dataframe of leagues for the specified user
#' @export

sleeper_userleagues <- function(user_name, season = NULL) {
  ff_userleagues.sleeper_conn(user_name = user_name, season = season)
}

#' Get User Teams
#' @noRd

.sleeper_userteams <- function(league_id, user_id) {
  df_teams <- sleeper_getendpoint(glue::glue("league/{league_id}/users")) %>%
    purrr::pluck("content") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "franchise_id" = "user_id", "display_name", "metadata") %>%
    tidyr::hoist("metadata", "franchise_name" = "team_name") %>%
    dplyr::mutate("franchise_name" = dplyr::coalesce(.data$franchise_name, .data$display_name)) %>%
    dplyr::filter(.data$franchise_id == user_id) %>%
    dplyr::pull("franchise_name")

  return(df_teams)
}
