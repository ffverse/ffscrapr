#### MFL MY LEAGUES ####

#' Get User Leagues
#'
#' This function retrieves a tibble of all user leagues and requires an
#' authentication cookie to be stored inside the MFL conn object
#' (which were created via username/password args)
#'
#' @param conn a connection object created by \code{ff_connect()}
#' @param season the MFL platform season to look for
#' @param ... arguments that may be passed to other methods (for method consistency)
#'
#' @rdname ff_userleagues
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
        "league_name" = .data$name,
        "franchise_id", "franchise_name",
        "league_url" = .data$url
      )
  }

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

  return(df)
}
