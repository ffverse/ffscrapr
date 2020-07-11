#### DYNASTYPROCESS IMPORT ####

#' Import latest DynastyProcess values
#'
#' Fetches a copy of the latest DynastyProcess dynasty trade values sheet
#'
#' @param file one of \code{c("values.csv","values-players.csv","values-picks.csv")}
#'
#' @seealso \url{https://github.com/DynastyProcess/data}
#'
#' @return a tibble of trade values
#' @export

dp_values <- function(file = c("values.csv","values-players.csv","values-picks.csv")){

  file_name <- match.arg(file)

  read.csv(glue::glue("https://github.com/DynastyProcess/data/raw/master/files/{file_name}"),
           stringsAsFactors = FALSE) %>%
    dplyr::mutate(scrape_date = lubridate::as_date(scrape_date)) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("id")),as.character)

}
