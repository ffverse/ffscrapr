#' Import latest nflfastr weekly stats
#'
#' Deprecated in favour of [`nflreadr::load_player_stats()`]
#'
#' @export
nflfastr_weekly <- function(...) {
  lifecycle::deprecate_stop(
    when = "1.4.8",
    what = "ffscrapr::nflfastr_weekly()",
    with = "nflreadr::load_player_stats()"
  )
}

#' Import nflfastr roster data
#'
#' Deprecated in favour of [`nflreadr::load_rosters()`]
#'
#' @export

nflfastr_rosters <- function(seasons) {
  lifecycle::deprecate_stop(
    when = "1.4.8",
    what = "ffscrapr::nflfastr_rosters()",
    with = "nflreadr::load_rosters()"
  )
}
