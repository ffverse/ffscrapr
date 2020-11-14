#### MFL ff_starters ####

#' MFL ff_starters
#'
#' @param conn the list object created by \code{ff_connect()}
#' @param season the season of interest - generally only the most recent 2-3 seasons are available
#' @param week a numeric or one of YTD (year-to-date) or AVG (average to date)
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_playerscores MFL: returns the player fantasy scores for each week (not the actual stats)
#'
#' @examples
#' dlf_conn <- mfl_connect(2020, league_id = 37920)
#' ff_playerscores(conn = dlf_conn, season = 2019, week = "YTD")
#' @export
ff_starters.mfl_conn <- function(conn,week = "all", year = NULL, ...){

  if(is.character(week) && week == "all") week <- c(1:17)

  if(is.null(year)) year <- conn$season

  checkmate::assert_numeric(week,lower = 1, upper = 21)
  checkmate::assert_number(year)

  weekly_starters <- tibble::tibble(
    season = year,
    week = week
  ) %>%
    dplyr::mutate(starters = purrr::map2(week,season,.mfl_weeklystarters,conn)) %>%
    tidyr::unnest(.data$starters) %>%
    dplyr::mutate(player_score = as.numeric(.data$player_score),
                  should_start = as.numeric(.data$should_start))

  return(weekly_starters)
}

.mfl_weeklystarters <- function(week, year, conn){

  weekly_result <- mfl_getendpoint(conn,"weeklyResults", W=week, YEAR = year) %>%
    purrr::pluck('content','weeklyResults','matchup') %>%
    purrr::map('franchise') %>%
    tibble::tibble()

  errortibble <- tibble::tibble("franchise_id" = character(),
                                "starter_status" = character(),
                                "player_id" = character(),
                                "player_score" = character(),
                                "should_start" = character())

  if(nrow(weekly_result)==0) return(errortibble)


  weekly_result <- weekly_result %>%
    tidyr::unnest_longer(1) %>%
    tidyr::unnest_wider(1)

  if(!'player'%in% names(weekly_result)) return(errortibble)


  weekly_result %>%
    dplyr::select("franchise_id"='id','player') %>%
    tidyr::unnest_longer('player') %>%
    tidyr::unnest_wider('player') %>%
    dplyr::select(dplyr::any_of(c(
      'franchise_id',
      "starter_status" = 'status',
      "player_id" = 'id',
      "player_score" = 'score',
      "should_start" = "shouldStart"
    )))
}
