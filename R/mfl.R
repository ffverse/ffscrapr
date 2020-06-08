#### MFL-specific functions ####

## SCORING SETTINGS ## ----

#' Get a dataframe of scoring settings
#'
#' @param conn the list object created by \code{mfl_connect()}
#'
#' @seealso \url{https://api.myfantasyleague.com/2020/api_info?STATE=details}
#'
#' @return the league endpoint for MFL
#'
#' @export mfl_scoring_settings

mfl_scoring_settings <- function(conn){

  rules <- mfl_getendpoint(conn,"rules")
  rules <- purrr::pluck(rules,"content","rules","positionRules")
  rules <- tibble::tibble(rules)
  rules <- tidyr::unnest_wider(rules,1)
  rules <- dplyr::mutate(rules,
                         vec_depth = purrr::map_dbl(.data$rule,purrr::vec_depth),
                         rule = dplyr::case_when(.data$vec_depth == 3 ~ purrr::map_depth(.data$rule,2,`[[`,1),
                                                 .data$vec_depth == 4 ~ purrr::map_depth(.data$rule,-2,`[[`,1)),
                         rule = dplyr::case_when(.data$vec_depth == 4 ~ purrr::map(.data$rule,dplyr::bind_rows),
                                          TRUE ~ .data$rule))
  rules <- dplyr::select(rules,-.data$vec_depth)
  rules <- tidyr::unnest_wider(rules, 'rule')
  rules <- tidyr::unnest(rules, c('points','event','range'))
  rules <- tidyr::separate_rows(rules, 'positions', sep = "\\|")
  rules <- dplyr::left_join(rules,rule_library_mfl, by = c('event'='abbrev'))
  rules <- dplyr::mutate_at(rules, c('is_player','is_team','is_coach'),~as.logical(as.numeric(.x)))
  rules <- dplyr::mutate(rules, points = purrr::map_if(.data$points,grepl("\\/",.data$points),.fn_parsedivide),
                                points = purrr::map_if(.data$points,grepl("\\*",.data$points),.fn_parsemultiply),
                                points = as.double(.data$points))

  rules
}

#' @noRd
.fn_parsemultiply <- function(points){
  as.numeric(gsub("\\*","",points))
}

#' @noRd
.fn_parsedivide <- function(points) {

  x <- strsplit(points,"/")
  x <- unlist(x)
  x <- as.numeric(x)
  return(x[[1]]/x[[2]])
}

# ff_settings_roster ----

# ff_transactions ----

# ff_rosters ----
