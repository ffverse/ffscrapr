#### MFL MY LEAGUES ####

#' Get User Leagues
#'
#' @param conn a connection object created by `ff_connect()`
#' @param season the MFL platform season to look for
#' @param ... arguments that may be passed to other methods (for method consistency)
#'
#' @describeIn ff_userleagues MFL: With username/password, it will return a list of user leagues.
#'
#' @export
ff_userleagues.mfl_conn <- function(conn, season = NULL, ...) {
  if (is.null(conn$auth_cookie)) {
    stop("No authentication cookie found in the conn object.
         Did you pass it the username and password when making it?",
      call. = FALSE
    )
  }

  season <- ifelse(is.null(season), conn$season, season)

  df_leagues <- mfl_getendpoint(conn, "myleagues", FRANCHISE_NAMES = 1, YEAR = season) %>%
    purrr::pluck("content", "leagues", "league")

  if (!is.null(df_leagues$franchise_id)) {
    df <- df_leagues %>%
      tibble::as_tibble() %>%
      dplyr::select("league_id",
        "league_name" = "name",
        "franchise_id", "franchise_name",
        "league_url" = "url"
      )
  }

  # nocov start

  if (is.null(df_leagues$franchise_id)) {
    df <- df_leagues %>%
      tibble::tibble() %>%
      tidyr::hoist(1,
        "league_id",
        "league_name" = "name",
        "franchise_id", "franchise_name",
        "league_url" = "url"
      )
  }

  # nocov end

  return(df)
}
