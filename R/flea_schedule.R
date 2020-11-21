## ff_schedule (MFL) ##

#' Get a dataframe detailing every game for every franchise
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @examples
#' \donttest{
#' conn <- fleaflicker_connect(season = 2020, league_id = 206154)
#' ff_schedule(conn)
#' }
#'
#' @describeIn ff_schedule MFL: returns schedule data, one row for every franchise for every week. Completed games have result data.
#'
#' @export

ff_schedule.flea_conn <- function(conn, ...) {

  weeks <- fleaflicker_getendpoint("FetchLeagueScoreboard",
                               sport = "NFL",
                               league_id = conn$league_id,
                               season = conn$season) %>%
    purrr::pluck('content',"eligibleSchedulePeriods") %>%
    purrr::map_int(`[[`,"value")

  schedule <- tibble::tibble(week = weeks) %>%
    dplyr::mutate(score = purrr::map(.data$week,.flea_schedule,conn)) %>%
    tidyr::unnest("score")

  return(schedule)

}
#'
.flea_schedule <- function(week,conn){

  schedule_raw <- fleaflicker_getendpoint("FetchLeagueScoreboard",
                               sport = "NFL",
                               league_id = conn$league_id,
                               scoring_period = week,
                               season = conn$season) %>%
    purrr::pluck('content',"games")

  if(is.null(schedule_raw)) return(tibble::tibble())

  schedule_raw <- schedule_raw %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::hoist('home',"home_id"='id',"home_name" = "name") %>%
    tidyr::hoist("away","away_id"="id","away_name" = "name") %>%
    dplyr::mutate_at(c('homeScore','awayScore'),purrr::map,~purrr::pluck(.x,1,"value")) %>%
    dplyr::select(dplyr::any_of(c(
      "game_id"="id",
      "home_id",
      "home_name",
      "home_score" = "homeScore",
      "home_result" = "homeResult",
      "away_id",
      "away_name",
      "away_score" = "awayScore",
      "away_result" = "awayResult"
    )))

  home_schedule <- schedule_raw %>%
    dplyr::rename(dplyr::any_of(c(
      "franchise_id" = 'home_id',
      "franchise_name" = 'home_name',
      "franchise_score" = 'home_score',
      "result" = 'home_result',
      "opponent_id" = 'away_id',
      "opponent_name" = 'away_name',
      "opponent_score" = "away_score"
    )))

  away_schedule <- schedule_raw %>%
    dplyr::rename(dplyr::any_of(c(
      "franchise_id" = "away_id",
      "franchise_name" = "away_name",
      "franchise_score" = "away_score",
      "result" = "away_result",
      "opponent_id" = "home_id",
      "opponent_name" = "home_name",
      "opponent_score" = 'home_score'
    )))

  schedule <- dplyr::bind_rows(home_schedule, away_schedule) %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id",
      "franchise_name",
      "franchise_score",
      "result",
      "opponent_id",
      "opponent_name",
      "opponent_score",
      "game_id"
    ))) %>%
    dplyr::mutate(dplyr::across(dplyr::contains("_score"),purrr::map_dbl,~replace(.x,is.null(.x),NA)))

  return(schedule)
}


