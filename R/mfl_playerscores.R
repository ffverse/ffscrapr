#### MFL Player Scores ####

#' MFL PlayerScores
#'
#' @param conn the list object created by `ff_connect()`
#' @param season the season of interest - generally only the most recent 2-3 seasons are available
#' @param week a numeric vector (ie 1:17) or one of YTD (year-to-date) or AVG (average to date)
#' @param ... other arguments
#'
#' @describeIn ff_playerscores MFL: returns the player fantasy scores for each week (not the actual stats)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   sfb_conn <- mfl_connect(2020, league_id = 65443)
#'   ff_playerscores(conn = sfb_conn, season = 2019, week = "YTD")
#' }) # end try
#' }
#' @export

ff_playerscores.mfl_conn <- function(conn, season, week, ...) {
  earliest_year <- ff_league(conn) %>%
    dplyr::pull(years_active) %>%
    stringr::str_extract("^[0-9]+")

  raw_playerscores <- tidyr::crossing(season = season, week = week) %>%
    dplyr::transmute(playerscore = purrr::map2(.data$season, .data$week, .mfl_playerscore, conn = conn)) %>%
    tidyr::unnest(playerscore)

  players <- dplyr::tibble(season = season) %>%
    dplyr::mutate(
      connection = purrr::map_if(
        .x = .data$season,
        .p = .data$season >= earliest_year,
        .f = ~ mfl_connect(.x, conn$league_id),
        .else = ~ mfl_connect(.x)
      ),
      players = purrr::map(
        .data$connection,
        ~ mfl_players(.x) %>%
          dplyr::select("player_id", "player_name", "pos", "team")
      ),
      connection = NULL
    ) %>%
    tidyr::unnest("players")

  player_scores <- raw_playerscores %>%
    dplyr::left_join(
      players,
      by = c("season", "player_id")
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "season",
        "week",
        "player_id",
        "player_name",
        "pos",
        "team",
        "points",
        "is_available"
      )),
      dplyr::everything()
    )

  return(player_scores)
}

.mfl_playerscore <- function(season, week, conn) {
  if (!(is.numeric(week) | week %in% c("AVG", "YTD"))) {
    stop("week should be either a numeric or one of AVG or YTD")
  }

  df <- mfl_getendpoint(conn, "playerScores", YEAR = season, W = week, RULES = 1) %>%
    purrr::pluck("content", "playerScores", "playerScore") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::mutate(
      season = season,
      week = week,
      score = as.numeric(.data$score)
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "season",
        "week",
        "player_id" = "id",
        "points" = "score",
        "is_available" = "isAvailable"
      )),
      dplyr::everything()
    )

  return(df)
}
