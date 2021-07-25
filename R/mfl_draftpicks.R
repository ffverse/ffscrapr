#### MFL Future Draft Picks ####

#' MFL Draft Picks
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_draftpicks MFL: returns current and future picks
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   dlf_conn <- mfl_connect(2020, league_id = 37920)
#'   ff_draftpicks(conn = dlf_conn)
#' }) # end try
#' }
#'
#' @export

ff_draftpicks.mfl_conn <- function(conn, ...) {
  future_picks <- .mfl_futurepicks(conn)

  current_picks <- .mfl_currentpicks(conn)

  dplyr::bind_rows(current_picks, future_picks) %>%
    dplyr::left_join(
      dplyr::select(
        ff_franchises(conn),
        dplyr::any_of(c("franchise_id", "franchise_name", "division", "division_name"))
      ),
      by = c("franchise_id")
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "season", "division", "division_name",
        "franchise_id", "franchise_name", "round",
        "pick", "original_franchise_id"
      ))
    )
}

#' @keywords internal

.mfl_futurepicks <- function(conn) {
  future_picks <- mfl_getendpoint(conn, "futureDraftPicks") %>%
    purrr::pluck("content", "futureDraftPicks", "franchise")

  if (length(future_picks) == 0) {
    return(NULL)
  }

  future_picks %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "futureDraftPick" = "futureDraftPick", "franchise_id" = "id") %>%
    tidyr::unnest_longer("futureDraftPick") %>%
    tidyr::hoist("futureDraftPick", "season" = "year", "round" = "round", "original_franchise_id" = "originalPickFor") %>%
    dplyr::mutate_at(c("season", "round"), as.numeric)
}

#' @keywords internal

.mfl_currentpicks <- function(conn) {
  raw_draftresults <- mfl_getendpoint(conn, "draftResults") %>%
    purrr::pluck("content", "draftResults", "draftUnit")

  if (!is.null(raw_draftresults$unit) && raw_draftresults$unit == "LEAGUE") {
    df_draftresults <- .mfl_parse_draftunit(raw_draftresults)

    if (is.null(df_draftresults)) {
      return(NULL)
    }

    df_draftresults <- df_draftresults %>%
      dplyr::filter(.data$player_id == "") %>%
      dplyr::select("franchise_id", "round", "pick") %>%
      dplyr::mutate(season = conn$season) %>%
      dplyr::mutate_at(c("season", "round", "pick"), as.numeric)

    return(df_draftresults)
  } else {
    df_draftresults <- purrr::map_df(raw_draftresults, .mfl_parse_draftunit)

    if (is.null(df_draftresults)) {
      return(NULL)
    }

    df_draftresults <- df_draftresults %>%
      dplyr::filter(.data$player_id == "") %>%
      dplyr::select("franchise_id", "round", "pick") %>%
      dplyr::mutate(season = conn$season) %>%
      dplyr::mutate_at(c("season", "round", "pick"), as.numeric)

    return(df_draftresults)
  }
}
