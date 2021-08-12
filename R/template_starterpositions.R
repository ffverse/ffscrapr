
#' Get starters and bench
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starter_positions Template: returns minimum and maximum starters for each player position.
#'
#' @examples
#' \donttest{
#' template_conn <- ff_template(roster_type = "idp")
#' ff_starter_positions(template_conn)
#' }
#'
#' @export
ff_starter_positions.template_conn <- function(conn, ...) {
  out <- switch(conn$roster_type,
    "1qb" = starterpositions_1qb,
    "sf" = ,
    "superflex" = starterpositions_sf,
    "sfb11" = starterpositions_sfb11,
    "idp" = starterpositions_idp,
    stop(glue::glue("Could not find starting position template for {conn$roster_type}"), call. = FALSE)
  )

  return(out)
}
