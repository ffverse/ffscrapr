#' Default `conn` objects
#'
#' This function creates a connection to a few league templates, and can be used instead of a real conn object in the following functions: `ff_scoring()`, `ff_scoringhistory()`, `ff_starterpositions()`.
#'
#' Scoring types defined here are:
#'
#' - `ppr`: 6 pt passing/rushing/receiving touchdowns, 0.1 for rushing/receiving yards, 1 point per reception, -2 for fumbles/interceptions
#' - `half_ppr`: same as `ppr` but with 0.5 points per reception
#' - `zero_ppr`: same as `ppr` but with 0 points per reception
#' - `te_prem`: same as `ppr` but TEs get 1.5 points per reception
#' - `sfb11`: SFB11 scoring as defined by <https://scottfishbowl.com>
#'
#' Roster settings defined here are:
#'
#' - `1qb`:  Starts 1 QB, 2 RB, 3 WR, 1 TE, 2 FLEX
#' - `superflex`: Starts 1 QB, 2 RB, 3 WR, 1 TE, 2 FLEX, 1 SUPERFLEX
#' - `sfb11`: Starts 1 QB, 2 RB, 3 WR, 1 TE, 3 FLEX, 1 SUPERFLEX (flex positions can also start a kicker)
#' - `idp`: Starts same as 1QB but also starts 3 DL, 3 LB, 3 DB, and two IDP FLEX
#'
#' @param scoring_type One of c("default", "ppr", "half_ppr", "zero_ppr", "te_prem", "sfb11")
#' @param roster_type One of c("1qb", "superflex","sfb11", "idp")
#'
#' @return a connection object that can be used with `ff_scoring()`, `ff_scoringhistory()`, and `ff_starterpositions()`
#' @export

ff_template <- function(scoring_type = c("ppr", "half_ppr", "zero_ppr", "sfb11"),
                        roster_type = c("1qb", "superflex", "sfb11", "idp")) {
  scoring_type <- match.arg(scoring_type)
  roster_type <- match.arg(roster_type)

  out <- structure(
    list(
      scoring_type = scoring_type,
      roster_type = roster_type
    ),
    class = "template_conn"
  )
  return(out)
}

# nocov start
#' @noRd
#' @export
print.template_conn <- function(x, ...) {
  cat("<Default league: ", x$scoring_type, " - ", x$roster_type, ">\n", sep = "")
  invisible(x)
}
# nocov end
