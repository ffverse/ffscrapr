#### NFLFASTR IMPORT ####

#' Import latest nflfastr weekly stats
#'
#' Fetches a copy of the latest week-level stats from nflfastr's data repository.
#' The same output as nflfastr's load_player_stats() function.
#'
#' The goal of this data is to replicate the NFL's official weekly stats, which
#' can diverge a bit from what fantasy data feeds display.
#'
#' If you have any issues with the output of this data, please open an issue in
#' the nflfastr repository.
#'
#' @param type One of "offense", "defense", or "all" - currently, only "offense" is available.
#'
#' @seealso <https://www.nflfastr.com/reference/load_player_stats.html>
#'
#' @examples
#' \donttest{
#' try( # try only shown here because sometimes CRAN checks are weird
#'   nflfastr_weekly()
#' )
#' }
#'
#' @return Weekly stats for all passers, rushers and receivers in the nflfastR play-by-play data from the 1999 season to the most recent season
#'
#' @export
nflfastr_weekly <- function(type = c("offense", "defense", "all")) {
  file_name <- match.arg(type)

  url_query <- "https://github.com/nflverse/nflfastR-data/raw/master/data/player_stats.rds"

  response <- httr::RETRY("GET", url_query)

  if (httr::http_error(response)) {
    stop(glue::glue("GitHub request failed with error: <{httr::status_code(response)}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  raw_weekly <- httr::content(response, as = "raw")

  df_weekly <- parse_raw_rds(raw_weekly)

  return(df_weekly)
}

#' Import nflfastr roster data
#'
#' Fetches a copy of roster data from nflfastr's data repository.
#' The same input/output as nflfastr's fast_scraper_roster function.
#'
#' If you have any issues with the output of this data, please open an issue in
#' the nflfastr repository.
#'
#' @param seasons A numeric vector of seasons, earliest of which is 1999
#'
#' @seealso <https://www.nflfastr.com/reference/fast_scraper_roster.html>
#'
#' @examples
#' \donttest{
#' try( # try only shown here because sometimes CRAN checks are weird
#'   nflfastr_rosters(seasons = 2019:2020)
#' )
#' }
#'
#' @return Data frame where each individual row represents a player in the roster of the given team and season
#'
#' @export

nflfastr_rosters <- function(seasons) {
  checkmate::assert_numeric(seasons, lower = 1999, upper = lubridate::year(Sys.Date()))

  urls <- glue::glue("https://github.com/nflverse/nflfastR-roster/raw/master/data/seasons/roster_{seasons}.rds")

  df_rosters <- purrr::map_df(urls, .nflfastr_roster)

  return(df_rosters)
}

.nflfastr_roster <- function(url_query) {
  response <- httr::RETRY("GET", url_query)

  if (httr::http_error(response)) {
    stop(glue::glue("GitHub request failed with error: <{httr::status_code(response)}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  df_roster <- response %>%
    httr::content(as = "raw") %>%
    parse_raw_rds()

  return(df_roster)
}

#' Parse Raw RDS
#'
#' Useful for parsing the raw-content of RDS files downloaded from nflfastr repo, c/o Seb.
#'
#' @param raw raw-content that is known to be an RDS file
#'
#' @seealso `httr::set_cookies`
#'
#' @keywords internal

parse_raw_rds <- function(raw) {
  con <- gzcon(rawConnection(raw))

  on.exit(close(con))

  readRDS(con) %>%
    tibble::tibble()
}
