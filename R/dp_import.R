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
#' dp_values()
#' }
#'
#' @return a tibble of trade values from DynastyProcess
#'
#' @export

dp_values <- function(file = c("values.csv", "values-players.csv", "values-picks.csv")) {
  file_name <- match.arg(file)

  url_query <- glue::glue("https://github.com/DynastyProcess/data/raw/master/files/{file_name}")

  response <- httr::RETRY("GET", url_query)

  if (httr::http_error(response)) {
    stop(glue::glue("GitHub request failed with error: <{httr::status_code(response)}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  content <- response %>%
    httr::content() %>%
    utils::read.csv(text = .,stringsAsFactors = FALSE) %>%
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

  url_query <- "https://github.com/DynastyProcess/data/raw/master/files/db_playerids.csv"

  response <- httr::RETRY("GET",url_query)

  if (httr::http_error(response)) {
    stop(glue::glue("GitHub request failed with error: <{httr::status_code(response)}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  content <- response %>%
    httr::content() %>%
    utils::read.csv(text = .,stringsAsFactors = FALSE) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("id")), as.character) %>%
    tibble::tibble()

  return(content)
}

#' Clean Names
#'
#' Applies some name-cleaning heuristics to facilitate joins.
#' May eventually refer to a name-cleaning database, for now will just include basic regex.
#'
#' @param player_name a character (or character vector)
#' @param lowercase defaults to FALSE - if TRUE, converts to lowercase
#'
#' @examples
#' \donttest{
#' dp_cleannames(c("A.J. Green", "Odell Beckham Jr.", "Le'Veon Bell Sr."))
#' }
#'
#' @return a character vector of cleaned names
#'
#' @export

dp_cleannames <- function(player_name, lowercase= FALSE) {

  checkmate::assert_logical(lowercase)
  checkmate::assert_character(player_name)

  n <- stringr::str_remove_all(player_name, "( Jr\\.$)|( Sr\\.$)|( III$)|( II$)|( IV$)|( V$)|(\\')|(\\.)")

  if(lowercase) n <- tolower(n)

  n <- stringr::str_squish(n)

  return(n)
}
