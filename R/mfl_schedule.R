## ff_schedule (MFL) ##

#' Get a dataframe detailing every game for every franchise
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... for other platforms
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   ssb_conn <- ff_connect(platform = "mfl", league_id = 54040, season = 2020)
#'   ff_schedule(ssb_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_schedule MFL: returns schedule data, one row for every franchise for every week. Completed games have result data.
#'
#' @export

ff_schedule.mfl_conn <- function(conn, ...) {
  schedule_raw <- mfl_getendpoint(conn, "schedule") %>%
    purrr::pluck("content", "schedule", "weeklySchedule") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1)

  if (is.null(schedule_raw[["matchup"]])) {
    return(NULL)
  }

  schedule <- schedule_raw %>%
    dplyr::mutate(
      matchup_length = purrr::map(.data$matchup, length),
      matchup = purrr::map_if(.data$matchup, .data$matchup_length == 1, ~ list(.x))
    ) %>%
    tidyr::unnest_longer("matchup") %>%
    tidyr::unnest_wider("matchup") %>%
    tidyr::hoist("franchise", "away" = 1, "home" = 2) %>%
    tidyr::unnest_wider("away", names_sep = "_") %>%
    tidyr::unnest_wider("home", names_sep = "_") %>%
    dplyr::select(-dplyr::ends_with("isHome")) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::contains("score"), "week", dplyr::contains("spread")), as.numeric)

  home <- schedule %>%
    dplyr::rename_at(dplyr::vars(dplyr::contains("home")), ~ stringr::str_remove(.x, "home_")) %>%
    dplyr::rename_at(dplyr::vars(dplyr::contains("away")), ~ stringr::str_replace(.x, "away_", "opponent_")) %>%
    dplyr::select(dplyr::any_of(c("week",
      "franchise_id" = "id",
      "franchise_score" = "score",
      "spread",
      "result",
      "opponent_id",
      "opponent_score"
    )))

  away <- schedule %>%
    dplyr::rename_at(dplyr::vars(dplyr::contains("away")), ~ stringr::str_remove(.x, "away_")) %>%
    dplyr::rename_at(dplyr::vars(dplyr::contains("home")), ~ stringr::str_replace(.x, "home_", "opponent_")) %>%
    dplyr::select(dplyr::any_of(c("week",
      "franchise_id" = "id",
      "franchise_score" = "score",
      "spread",
      "result",
      "opponent_id",
      "opponent_score"
    )))

  full_schedule <- dplyr::bind_rows(home, away) %>%
    dplyr::arrange(.data$week, .data$franchise_id) %>%
    dplyr::filter(!is.na(.data$franchise_id))

  if("spread" %in% names(full_schedule)){
    full_schedule$result[(!is.na(full_schedule$spread)|full_schedule$spread==0) && full_schedule$result == "T"] <- NA
  }

  return(full_schedule)
}
