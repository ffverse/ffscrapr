#### UTILS ####
# External functions imported and sometimes re-exported

#' @keywords internal
#' @importFrom rlang .data `%||%` .env
#' @importFrom utils str
#' @importFrom lifecycle deprecated

NULL

#' Pipe operator
#'
#' See [`magrittr::%>%`](https://magrittr.tidyverse.org/reference/pipe.html) for details.
#'
#' @name %>%
#' @rdname pipe
#' @export
#' @importFrom magrittr %>%
NULL

#' date utils
#' @keywords internal
.as_datetime <- function(x){
  origin <- structure(0, class = c("POSIXct", "POSIXt"), tzone = "UTC")
  as.POSIXct(x,origin = origin, tz = "UTC")
}

#' date utils
#' @keywords internal
.as_date <- function(x){
  as.Date(x, tz = "UTC")
}

#' ffverse sitrep
#'
#' See [`nflreadr::ffverse_sitrep`](https://nflreadr.nflverse.com/reference/sitrep.html) for details.
#'
#' @name ffverse_sitrep
#' @rdname sitrep
#' @export
#' @importFrom nflreadr ffverse_sitrep
NULL
