#' Import latest nflfastr weekly stats
#'
#' Deprecated in favour of [`nflreadr::load_player_stats()`]
#'
#' @param ... deprecated
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
#' @param ... deprecated
#'
#' @export

nflfastr_rosters <- function(...) {
  lifecycle::deprecate_stop(
    when = "1.4.8",
    what = "ffscrapr::nflfastr_rosters()",
    with = "nflreadr::load_rosters()"
  )
}

#' Clean Player Names
#'
#' @examples
#' \donttest{
#'
#' dp_cleannames(c("A.J. Green", "Odell Beckham Jr.", "Le'Veon Bell Sr."))
#'
#' dp_cleannames(c("Trubisky, Mitch", "Atwell, Chatarius", "Elliott, Zeke", "Elijah Moore"),
#'   convert_lastfirst = TRUE,
#'   use_name_database = TRUE
#' )
#' }
#' @inherit nflreadr::clean_player_names
#' @inheritDotParams nflreadr::clean_player_names
#'
#' @seealso `nflreadr::clean_player_names()`
#'
#' @return a character vector of cleaned names
#'
#' @export
dp_clean_names <- function(...) {

  lifecycle::deprecate_soft(
    when = "1.4.8",
    "ffscrapr::dp_clean_names()",
    "nflreadr::clean_player_names()"
  )

  nflreadr::clean_player_names(
    ...
  )
}

#' @export
#' @rdname dp_clean_names
dp_cleannames <- dp_clean_names
