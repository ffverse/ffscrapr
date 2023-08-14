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
#'
#' @seealso `nflreadr::clean_player_names()`
#'
#' @return a character vector of cleaned names
#'
#' @export
dp_clean_names <- function(player_name, lowercase = FALSE, convert_lastfirst = TRUE, use_name_database = TRUE) {

  lifecycle::deprecate_soft(
    when = "1.4.8",
    "ffscrapr::dp_clean_names()",
    "nflreadr::clean_player_names()"
  )

  nflreadr::clean_player_names(
    player_name,
    lowercase = lowercase,
    convert_lastfirst = convert_lastfirst,
    use_name_database = use_name_database
  )
}

#' @export
#' @rdname dp_clean_names
dp_cleannames <- dp_clean_names
