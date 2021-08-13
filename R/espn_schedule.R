## ff_schedule (ESPN) ##

#' Get a dataframe detailing every game for every franchise
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   espn_conn <- espn_connect(season = 2020, league_id = 899513)
#'   ff_schedule(espn_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_schedule ESPN: returns schedule data, one row for every franchise for every week. Completed games have result data.
#'
#' @export
ff_schedule.espn_conn <- function(conn, ...) {
  matchup_endpoint <-
    espn_getendpoint(
      conn = conn,
      view = "mMatchup"
    )

  schedule <-
    matchup_endpoint %>%
    purrr::pluck("content") %>%
    purrr::pluck("schedule")

  .pluck_team <- function(x) {
    schedule %>%
      purrr::map(~ purrr::pluck(.x, x))
  }
  # .pluck_team_score <- function(x) {
  #    x %>% purrr::map(~purrr::pluck(.x, "cumulativeScore"))
  # }

  h <- .pluck_team("home")
  a <- .pluck_team("away")
  # h_score <- h %>% .pluck_team_score()
  # a_score <- a %>% .pluck_team_score()

  # Not sure if I should use the "winner" field or just manually calculate the result later.
  # There could be differences with how games that are yet-to-be-completed are treated.
  scores <-
    tibble::tibble(
      "week" = schedule %>% purrr::map_int(~ purrr::pluck(.x, "matchupPeriodId")),
      # "winner" = schedule %>% purrr::map_chr(~purrr::pluck(.x, "winner")),
      "home_id" = h %>% purrr::map_int(~ purrr::pluck(.x, "teamId", .default = NA_integer_)),
      "away_id" = a %>% purrr::map_int(~ purrr::pluck(.x, "teamId", .default = NA_integer_)),
      # "home_w" = h_score %>% purrr::map_dbl(~purrr::pluck(.x, "wins")),
      "home_points" = h %>% purrr::map_dbl(~ purrr::pluck(.x, "totalPoints", .default = 0)),
      "away_points" = a %>% purrr::map_dbl(~ purrr::pluck(.x, "totalPoints", .default = 0))
    )
  scores2 <- scores
  names(scores2) <- c("week", "away_id", "home_id", "away_points", "home_points")
  schedule <-
    dplyr::bind_rows(scores, scores2) %>%
    dplyr::arrange(.data$week, .data$home_id, .data$away_id) %>%
    dplyr::rename(
      "franchise_id" = .data$home_id,
      "opponent_id" = .data$away_id,
      "franchise_score" = .data$home_points,
      "opponent_score" = .data$away_points
    ) %>%
    dplyr::mutate(
      result = dplyr::case_when(
        .data$franchise_score > .data$opponent_score ~ "W",
        .data$franchise_score < .data$opponent_score ~ "L",
        # Game has not been played yet.
        .data$franchise_score == 0 & .data$opponent_score == 0 ~ NA_character_,
        TRUE ~ "T"
      )
    ) %>%
    dplyr::select(
      .data$week,
      .data$franchise_id,
      .data$franchise_score,
      .data$result,
      .data$opponent_id,
      .data$opponent_score
    ) %>%
    dplyr::filter(!is.na(.data$franchise_id))
  return(schedule)
}
