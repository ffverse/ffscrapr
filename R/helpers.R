#### Helpers ####

#' @keywords internal
#' @importFrom rlang .data
#' @importFrom utils str

NULL

#' Choose current season
#'
#' A helper function to return the current year if March or later, otherwise assume previous year
#'
#' @noRd
#' @keywords internal

.fn_choose_season <- function(date = NULL){

  if(is.null(date)){date <- Sys.Date()}

  if(class(date)!="Date") {date <- as.Date(date)}

  if(as.numeric(format(date,"%m"))>2){return(format(date,"%Y"))}

  return(format(date-365.25,"%Y"))

}

#' Rate limited httr::GET
#'
#' A helper function wrapping rate limit if toggled TRUE
#' @param toggle a logical to turn on rate_limiting if TRUE and off if FALSE
#' @param rate_number number of calls per \code{rate_seconds}
#' @param rate_seconds number of seconds
#'
#' @noRd
#' @keywords internal

.fn_get <- function(toggle = TRUE,rate_number,rate_seconds){

  if(toggle){return(ratelimitr::limit_rate(httr::GET,ratelimitr::rate(rate_number,rate_seconds)))}
  if(!toggle){return(httr::GET)}

}

