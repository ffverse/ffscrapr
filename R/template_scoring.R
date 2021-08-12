#' Get a dataframe of scoring settings
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' template_ppr <- ff_template(scoring_type = "ppr")
#' ff_scoring(template_ppr)
#' }
#'
#' @describeIn ff_scoring Template: returns MFL style scoring settings in a flat table, one row per position per rule.
#'
#' @export
ff_scoring.template_conn <- function(conn) {
  out <- switch(conn$scoring_type,
    "ppr" = scoring_ppr,
    "half_ppr" = scoring_hppr,
    "zero_ppr" = scoring_zeroppr,
    "sfb11" = scoring_sfb11,
    stop(glue::glue("Could not find scoring template for {conn$scoring_type}"), call. = FALSE)
  )

  return(out)
}
