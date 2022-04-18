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

#' Clean Names
#'
#' Applies some name-cleaning heuristics to facilitate joins. These heuristics may include:
#'  - removing periods and apostrophes
#'  - removing common suffixes, such as Jr, Sr, II, III, IV
#'  - converting to lowercase
#'  - using `dp_name_mapping` to do common name substitutions, such as Mitch Trubisky to Mitchell Trubisky
#'
#' @param player_name a character (or character vector)
#' @param lowercase defaults to FALSE - if TRUE, converts to lowercase
#' @param convert_lastfirst converts names from "Last, First" to "First Last" (i.e. MFL style)
#' @param use_name_database uses internal name database to do common substitutions (Mitchell Trubisky to Mitch Trubisky etc)
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
#' @seealso `dp_name_mapping`
#'
#' @return a character vector of cleaned names
#'
#' @export

dp_cleannames <- function(player_name, lowercase = FALSE, convert_lastfirst = TRUE, use_name_database = TRUE) {
  checkmate::assert_character(player_name)
  checkmate::assert_flag(lowercase)
  checkmate::assert_flag(convert_lastfirst)
  checkmate::assert_flag(use_name_database)

  n <- player_name

  if (convert_lastfirst) n <- stringr::str_replace_all(n, "^(.+), (.+)$", "\\2 \\1")

  n <- stringr::str_remove_all(n, "( Jr\\.$)|( Sr\\.$)|( III$)|( II$)|( IV$)|( V$)|(\\')|(\\.)")

  n <- stringr::str_squish(n)

  if (use_name_database) n <- unname(dplyr::coalesce(ffscrapr::dp_name_mapping[n], n))

  if (lowercase) n <- tolower(n)

  return(n)
}

#' @export
#' @rdname dp_cleannames
dp_clean_names <- dp_cleannames

#' Alternate name mappings
#'
#' A named character vector mapping common alternate names
#'
#' @examples
#' \donttest{
#' dp_name_mapping[c("Chatarius Atwell", "Robert Kelley")]
#' }
#'
#' @format A named character vector
#' \describe{
#'   \item{name attribute}{The "alternate" name.}
#'   \item{value attribute}{The "correct" name.}
#' }
#'
"dp_name_mapping"

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
