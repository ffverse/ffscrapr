#### ESPN ff_starter_positions ####

#' Get starters and bench
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starter_positions ESPN: returns min/max starters for each main player position
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- espn_connect(season = 2020, league_id = 1178049)
#'   ff_starter_positions(conn)
#' }) # end try
#' }
#'
#' @export
ff_starter_positions.espn_conn <- function(conn, ...) {
  l_s <- espn_getendpoint(conn, view = "mSettings") %>%
    purrr::pluck("content", "settings", "rosterSettings", "lineupSlotCounts") %>%
    tibble::enframe(name = "lineup_id", value = "count") %>%
    dplyr::mutate(pos = .espn_lineupslot_map()[as.character(.data$lineup_id)]) %>%
    tidyr::unnest(c("pos", "count")) %>%
    # dplyr::left_join(.espn_pp_lineupkeys(), by = "lineup_id") %>%
    dplyr::mutate(
      min = ifelse(.data$pos %in% c(
        "QB", "RB", "WR", "TE",
        "TQB", "DT", "DE", "ER",
        "LB", "CB", "S",
        "K", "P", "DST", "HC"
      ), .data$count, NA_integer_),
      offense_starters = sum(.data$min * stringr::str_detect(.data$pos, "QB|RB|WR|TE|OP"), na.rm = TRUE),
      defense_starters = sum(.data$min * stringr::str_detect(.data$pos, "DE|DT|DL|LB|CB|^S$|ER|DP"), na.rm = TRUE),
      kdst_starters = sum(.data$min * .data$pos %in% c("K", "P", "DST", "HC"), na.rm = TRUE),
      total_starters = .data$offense_starters + .data$defense_starters + .data$kdst_starters
    )

  rbwr <- l_s$count[l_s$pos == "RB/WR"]
  wrte <- l_s$count[l_s$pos == "WR/TE"]
  rbwrte <- l_s$count[l_s$pos == "RB/WR/TE"]
  op <- l_s$count[l_s$pos == "OP"]
  dp <- l_s$count[l_s$pos == "DP"]
  dl <- l_s$count[l_s$pos == "DL"]
  db <- l_s$count[l_s$pos == "DB"]

  l_s %>%
    dplyr::mutate(
      max = dplyr::case_when(
        .data$pos == "QB" ~ .data$min + op,
        .data$pos == "RB" ~ .data$min + rbwr + rbwrte + op,
        .data$pos == "WR" ~ .data$min + rbwr + wrte + rbwrte + op,
        .data$pos == "TE" ~ .data$min + wrte + rbwrte + op,
        .data$pos == "DT" ~ .data$min + dl + dp,
        .data$pos == "DE" ~ .data$min + dl + dp,
        .data$pos == "CB" ~ .data$min + db + dp,
        .data$pos == "S" ~ .data$min + db + dp,
        TRUE ~ .data$min
      ),
    ) %>%
    dplyr::filter(!is.na(.data$min), .data$min > 0) %>%
    dplyr::select(
      "pos",
      "min",
      "max",
      dplyr::contains("_starters")
    )
}
