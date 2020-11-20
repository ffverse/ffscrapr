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

  x <- fleaflicker_getendpoint("FetchLeagueScoreboard",
                               sport = "NFL",
                               league_id = conn$league_id,
                               season = conn$season) %>%
    purrr::pluck('content',"eligibleSchedulePeriods") %>%
    purrr::map_int(`[[`,"value") %>%
    tibble::tibble(week = .) %>%
    dplyr::mutate(score = purrr::map(.data$week,.flea_schedule,conn)) %>%
    tidyr::unnest("score")

  if("franchise_score" %in% names(x)){
    x <- x %>%
      dplyr::mutate(
        franchise_score = purrr::map_dbl(.data$franchise_score,~replace(.x,is.null(.x),NA)),
        opponent_score = purrr::map_dbl(.data$opponent_score,~replace(.x,is.null(.x),NA)))
  }

  return(x)

}
#'
.flea_schedule <- function(week,conn){

  x <- fleaflicker_getendpoint("FetchLeagueScoreboard",
                               sport = "NFL",
                               league_id = conn$league_id,
                               scoring_period = week,
                               season = conn$season) %>%
    purrr::pluck('content',"games")

  if(is.null(x)) return(tibble::tibble())

  x <- x %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    tidyr::hoist('home',"franchise_id"='id',"franchise_name" = "name") %>%
    tidyr::hoist("away","opponent_id"="id","opponent_name" = "name") %>%
    dplyr::mutate_at(c('homeScore','awayScore'),purrr::map,~purrr::pluck(.x,1,"value")) %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id",
      "franchise_name",
      "franchise_score" = "homeScore",
      "result" = "homeResult",
      "opponent_id",
      "opponent_name",
      "opponent_score" = "awayScore",
      "opponent_result" = "awayResult"
    )))

  y <- x %>%
    dplyr::rename(dplyr::any_of(c(
      "franchise_id" = .data$opponent_id,
      "franchise_name" = .data$opponent_name,
      "franchise_score" = .data$opponent_score,
      "result" = .data[["opponent_result"]],
      "opponent_id" = .data$franchise_id,
      "opponent_name" = .data$franchise_name,
      "opponent_score" = .data$franchise_score,
      "opponent_result" = .data[['result']]))) %>%
    dplyr::bind_rows(x) %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id","franchise_name","franchise_score","result",
      "opponent_id","opponent_name","opponent_score")))

  return(y)
}


