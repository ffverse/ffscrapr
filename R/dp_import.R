#### DYNASTYPROCESS IMPORT ####

#' Import latest DynastyProcess values
#'
#' Fetches a copy of the latest DynastyProcess dynasty trade values sheets
#'
#' @param file one of \code{c("values.csv","values-players.csv","values-picks.csv")}
#'
#' @seealso \url{https://github.com/DynastyProcess/data}
#'
#' @examples
#' \donttest{
#'  dp_values()
#' }
#'
#' @return a tibble of trade values from DynastyProcess
#'
#' @export

dp_values <- function(file = c("values.csv", "values-players.csv", "values-picks.csv")) {
  file_name <- match.arg(file)

  utils::read.csv(
    glue::glue("https://github.com/DynastyProcess/data/raw/master/files/{file_name}"),
    stringsAsFactors = FALSE) %>%
    dplyr::mutate(scrape_date = lubridate::as_date(.data$scrape_date)) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("id")), as.character) %>%
    tibble::tibble()
}

#' Import latest DynastyProcess player IDs
#'
#' Fetches a copy of the latest DynastyProcess player IDs csv
#'
#' @examples
#' \donttest{
#' dp_playerids()
#' }
#'
#' @seealso \url{https://github.com/DynastyProcess/data}
#'
#' @return a tibble of player IDs
#'
#' @export


dp_playerids <- function() {
  read.csv(
    glue::glue("https://github.com/DynastyProcess/data/raw/master/files/db_playerids.csv"),
    stringsAsFactors = FALSE
  ) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("id")), as.character) %>%
    tibble::tibble()
}

