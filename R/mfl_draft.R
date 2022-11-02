#### ff_draft (MFL) ####

#' Get Draft Results
#'
#' @param conn a conn object created by `ff_connect()`
#' @param custom_players `r lifecycle::badge("deprecated")` - now returns custom players by default
#' @param ... args for other methods
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   ssb_conn <- ff_connect(platform = "mfl", league_id = 54040, season = 2020)
#'   ff_draft(ssb_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_draft MFL: returns a table of drafts for the current year - can handle devy/startup-rookie-picks by specifying custom_players (slower!)
#'
#' @export
ff_draft.mfl_conn <- function(conn, custom_players = deprecated(), ...) {
  if (lifecycle::is_present(custom_players)) {
    lifecycle::deprecate_soft("1.3.0", "ffscrapr::ff_draft.mfl_conn(custom_players=)")
  }

  # Notes on draft endpoint: "draft unit" can dictate handling of whether it's a "league" or "division" based draft

  players_endpoint <- mfl_players(conn)

  players_endpoint <- players_endpoint %>%
    dplyr::select("player_id", "player_name", "pos", "team", "birthdate")

  raw_draftresults <- mfl_getendpoint(conn, "draftResults") %>%
    purrr::pluck("content", "draftResults", "draftUnit")

  if (!is.null(raw_draftresults$unit) && raw_draftresults$unit == "LEAGUE") {
    df_draftresults <- .mfl_parse_draftunit(raw_draftresults)

    if (is.null(df_draftresults)) {
      return(NULL)
    }

    df_draftresults <- df_draftresults %>%
      dplyr::left_join(
        ff_franchises(conn) %>%
          dplyr::select("franchise_id", "franchise_name"),
        by = c("franchise_id")
      ) %>%
      dplyr::left_join(
        players_endpoint,
        by = c("player_id")
      ) %>%
      dplyr::transmute(
        "timestamp" = .as_datetime(as.numeric(.data$timestamp)),
        .data$round,
        .data$pick,
        .data$overall,
        .data$franchise_id,
        .data$franchise_name,
        .data$player_id,
        .data$player_name,
        .data$pos,
        age = round(as.numeric(.as_date(.data$timestamp) - .data$birthdate) / 365.25, 1),
        .data$team
      )
  } else {
    df_draftresults <- purrr::map_df(raw_draftresults, .mfl_parse_draftunit)

    if (is.null(df_draftresults)) {
      return(NULL)
    }

    df_draftresults <- df_draftresults %>%
      dplyr::left_join(
        ff_franchises(conn) %>%
          dplyr::select("franchise_id", "division", "division_name", "franchise_name"),
        by = c("franchise_id")
      ) %>%
      dplyr::left_join(
        players_endpoint,
        by = c("player_id")
      ) %>%
      dplyr::transmute(
        "timestamp" = .as_datetime(as.numeric(.data$timestamp)),
        .data$division,
        .data$division_name,
        .data$round,
        .data$pick,
        .data$overall,
        .data$franchise_id,
        .data$franchise_name,
        .data$player_id,
        .data$player_name,
        .data$pos,
        age = round(as.numeric(.as_date(.data$timestamp) - .data$birthdate) / 365.25, 1),
        .data$team
      )
  }

  return(df_draftresults)
}

#' @noRd
.mfl_parse_draftunit <- function(raw_draftresults) {
  df_1 <- raw_draftresults %>%
    purrr::pluck("draftPick")

  if (is.null(df_1)) {
    return(NULL)
  }

  df_1 %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::mutate(
      overall = dplyr::row_number()
    ) %>%
    dplyr::rename(
      "franchise_id" = "franchise",
      "player_id" = "player"
    )
}
