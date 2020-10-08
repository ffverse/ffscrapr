#### ff_standings (Sleeper) ####

#' Get a dataframe of league standings
#'
#' @param conn a conn object created by \code{ff_connect()}
#' @param ... arguments passed to other methods (currently none)
#'
#' @examples
#' jml_conn <- ff_connect(platform = "sleeper", league_id = 522458773317046272, season = 2020)
#' ff_standings(jml_conn)
#' @rdname ff_standings
#'
#' @export
ff_standings.sleeper_conn <- function(conn, ...) {

  standings <- ff_schedule(conn) %>%
    dplyr::filter(!is.na(.data$result)) %>%
    dplyr::group_by(.data$week) %>%
    dplyr::mutate(
      allplay_wins = rank(.data$franchise_score,) - 1,
      allplay_losses = dplyr::n() - 1 - .data$allplay_wins
    ) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(.data$franchise_id) %>%
    dplyr::summarise(
      h2h_wins = sum(c(.data$result == "W",0), na.rm = TRUE) ,
      h2h_losses = sum(c(.data$result == "L",0), na.rm = TRUE),
      h2h_ties = sum(c(.data$result == "T",0), na.rm = TRUE),
      h2h_winpct = .data$h2h_wins / (.data$h2h_wins + .data$h2h_losses + .data$h2h_ties),
      allplay_wins = sum(c(.data$allplay_wins,0), na.rm = TRUE),
      allplay_losses = sum(c(.data$allplay_losses,0),na.rm = TRUE),
      allplay_winpct = .data$allplay_wins/(.data$allplay_wins + .data$allplay_losses),
      points_for = sum(c(.data$franchise_score,0),na.rm = TRUE),
      points_against = sum(c(.data$opponent_score,0),na.rm = TRUE)
    ) %>%
    dplyr::arrange(dplyr::desc(.data$h2h_winpct))

  # TODO add franchise name call

  return(standings)
}
