#### DYNASTYPROCESS IMPORT ####

#' Import latest DynastyProcess values
#'
#' Fetches a copy of the latest DynastyProcess dynasty trade values sheets
#'
#' @param file one of `c("values.csv","values-players.csv","values-picks.csv")`
#'
#' @seealso <https://github.com/DynastyProcess/data>
#'
#' @examples
#' \donttest{
#' try( # try only shown here because sometimes CRAN checks are weird
#'   dp_values()
#' )
#' }
#'
#' @return a tibble of trade values from DynastyProcess
#'
#' @export
dp_values <- function(file = c("values.csv", "values-players.csv", "values-picks.csv")) {
  file_name <- match.arg(file)

  url_query <- glue::glue("https://github.com/DynastyProcess/data/raw/master/files/{file_name}")

  response <- httr::RETRY("GET", url_query, httr::accept("text/csv"))

  if (httr::http_error(response)) {
    stop(glue::glue("GitHub request failed with error: <{httr::status_code(response)}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  content <- response %>%
    httr::content() %>%
    utils::read.csv(text = ., stringsAsFactors = FALSE) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("id")), as.character) %>%
    tibble::tibble()

  return(content)
}

#' Import latest DynastyProcess player IDs
#'
#' Fetches a copy of the latest DynastyProcess player IDs csv
#'
#' @examples
#' \donttest{
#' try( # try only shown here because sometimes CRAN checks are weird
#'   dp_playerids()
#' )
#' }
#'
#' @seealso <https://github.com/DynastyProcess/data>
#'
#' @return a tibble of player IDs
#'
#' @export
dp_playerids <- function() {
  url_query <- "https://github.com/DynastyProcess/data/raw/master/files/db_playerids.csv"

  response <- httr::RETRY("GET", url_query, httr::accept("text/csv"))

  if (httr::http_error(response)) {
    stop(glue::glue("GitHub request failed with error: <{httr::status_code(response)}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  content <- response %>%
    httr::content() %>%
    utils::read.csv(text = ., stringsAsFactors = FALSE) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("id")), as.character) %>%
    tibble::tibble()

  return(content)
}

#' Remove HTML from string
#'
#' Applies some regex to clean html tags from strings. This is useful for platforms such as MFL that interpret HTML in their franchise name fields.
#'
#' @param names a character (or character vector)
#'
#' @examples
#'
#' c(
#'   "<b><font color= Cyan>Kevin OBrien (@kevinobrienff) </FONT></B>",
#'   "<em><font color= Purple> Other fun names</font></em>"
#' ) %>% dp_clean_html()
#' @return a character vector of cleaned strings
#'
#' @export
dp_clean_html <- function(names) {
  checkmate::assert_character(names)

  n <- stringr::str_remove_all(names, "<[^>]*>") %>% stringr::str_squish()

  return(n)
}
