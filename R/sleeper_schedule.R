## ff_schedule (Sleeper) ##

#' Get a dataframe detailing every game for every franchise
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @examples
#' jml_conn <- ff_connect(platform = "sleeper", league_id = 522458773317046272, season = 2020)
#' ff_schedule(jml_conn)
#'
#'
#' @rdname ff_schedule
#' @export
ff_schedule.sleeper_conn <- function(conn,...){

  league_path <- glue::glue("league/{conn$league_id}")

  regular_season_end <- sleeper_getendpoint(league_path) %>%
    purrr::pluck("content","settings","playoff_week_start") - 1

  weeks <- seq_len(regular_season_end)

  matchups <- purrr::map_dfr(weeks,.sleeper_matchup,conn)

  return(matchups)
}

#' @keywords internal
.sleeper_matchup <- function(week,conn){

  endpoint <- glue::glue("league/{conn$league_id}/matchups/{week}")

  df_matchup <- sleeper_getendpoint(endpoint) %>%
    purrr::pluck("content") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::select(
      dplyr::any_of(
        c("franchise_id" = 'roster_id',
          "franchise_score" = 'points',
          'matchup_id')
      ))

  df_matchups <- df_matchup %>%
    dplyr::left_join(
      dplyr::select(
        df_matchup,
        dplyr::any_of(c(
          'opponent_id' = 'franchise_id',
          'opponent_score' = 'franchise_score',
          'matchup_id'
        )
        )),
      by = 'matchup_id') %>%
    dplyr::filter(.data$franchise_id != .data$opponent_id) %>%
    dplyr::mutate(week = week) %>%
    dplyr::select(dplyr::any_of(c('week','franchise_id','franchise_score','opponent_id','opponent_score')))

  if(!'franchise_score' %in% names(df_matchups)) {
    df_matchups <- df_matchups %>%
      dplyr::mutate(result = NA_character_)
  }

  if('franchise_score' %in% names(df_matchups)){
    df_matchups <- df_matchups %>%
      dplyr::mutate(result = dplyr::case_when(.data$franchise_score > .data$opponent_score ~ "W",
                                       .data$franchise_score < .data$opponent_score ~ "L",
                                       .data$franchise_score == .data$opponent_score ~ "T",
                                       TRUE ~ NA_character_))
  }

  return(df_matchups)
}

