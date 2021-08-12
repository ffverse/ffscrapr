#### MFL ff_starter_positions ####

#' MFL ff_starter_positions
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starter_positions MFL: returns minimum and maximum starters for each player position.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   dlfidp_conn <- mfl_connect(2020, league_id = 33158)
#'   ff_starter_positions(conn = dlfidp_conn)
#' }) # end try
#' }
#'
#' @export

ff_starter_positions.mfl_conn <- function(conn, ...) {
  starter_positions <- mfl_getendpoint(conn, "league") %>%
    purrr::pluck("content", "league", "starters") %>%
    list() %>%
    tibble::tibble() %>%
    tidyr::hoist(
      1,
      "total_starters" = "count",
      "defense_starters" = "idp_starters",
      "offense_starters" = "iop_starters",
      "position"
    ) %>%
    tidyr::unnest_longer("position") %>%
    tidyr::hoist("position", "pos" = "name", "limit") %>%
    tidyr::separate("limit", into = c("min", "max"), sep = "\\-", fill = "right") %>%
    dplyr::mutate(total_starters = dplyr::if_else(stringr::str_detect(.data$total_starters, "\\-"),
      stringr::str_extract(.data$total_starters, "([0-9]+)$") %>%
        unlist(),
      .data$total_starters
    )) %>%
    dplyr::mutate_at(c("min", "max", "total_starters"), as.integer) %>%
    dplyr::mutate(
      max = dplyr::coalesce(.data$max, .data$min),
      defense_starters = dplyr::coalesce(as.integer(.data[["defense_starters"]]), 0),
      kdst_starters = sum(.data$pos %in% c("DEF", "PK", "PN", "TMPK", "TMPN", "Coach", "ST") * .data$min),
      offense_starters = dplyr::coalesce(
        as.integer(.data[["offense_starters"]]),
        as.integer(.data$total_starters) - .data$defense_starters - .data$kdst_starters
      )
    ) %>%
    dplyr::select(
      "pos",
      "min",
      "max",
      "offense_starters",
      "defense_starters",
      "kdst_starters",
      "total_starters"
    )

  return(starter_positions)
}
