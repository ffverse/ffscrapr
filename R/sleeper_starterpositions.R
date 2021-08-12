#### Sleeper ff_starter_positions ####

#' Get starters and bench
#'
#' @param conn the list object created by `ff_connect()`
#' @param ... other arguments (currently unused)
#'
#' @describeIn ff_starter_positions Sleeper: returns minimum and maximum starters for each player position.
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- sleeper_connect(league_id = "652718526494253056", season = 2021)
#'   ff_starter_positions(jml_conn)
#' }) # end try
#' }
#'
#' @export
ff_starter_positions.sleeper_conn <- function(conn, ...) {
  df_positions <- sleeper_getendpoint(glue::glue("league/{conn$league_id}")) %>%
    purrr::pluck("content", "roster_positions") %>%
    tibble::tibble() %>%
    purrr::set_names("pos") %>%
    dplyr::filter(.data$pos != "BN") %>%
    dplyr::group_by(.data$pos) %>%
    dplyr::count(name = "min") %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      total_starters = sum(.data$min, na.rm = TRUE),
      pos = purrr::map_chr(.data$pos, unlist)
    )

  flex <- ifelse(length(df_positions$min[df_positions$pos == "FLEX"]) == 0, 0, df_positions$min[df_positions$pos == "FLEX"])
  wrrb_flex <- ifelse(length(df_positions$min[df_positions$pos == "WRRB_FLEX"]) == 0, 0, df_positions$min[df_positions$pos == "WRRB_FLEX"])
  rec_flex <- ifelse(length(df_positions$min[df_positions$pos == "REC_FLEX"]) == 0, 0, df_positions$min[df_positions$pos == "REC_FLEX"])
  super_flex <- ifelse(length(df_positions$min[df_positions$pos == "SUPER_FLEX"]) == 0, 0, df_positions$min[df_positions$pos == "SUPER_FLEX"])
  idp_flex <- ifelse(length(df_positions$min[df_positions$pos == "IDP_FLEX"]) == 0, 0, df_positions$min[df_positions$pos == "IDP_FLEX"])

  df_positions %>%
    dplyr::mutate(
      max = dplyr::case_when(
        .data$pos == "QB" ~ as.integer(.data$min + super_flex),
        .data$pos == "RB" ~ as.integer(.data$min + wrrb_flex + super_flex + flex),
        .data$pos == "WR" ~ as.integer(.data$min + wrrb_flex + rec_flex + super_flex + flex),
        .data$pos == "TE" ~ as.integer(.data$min + rec_flex + super_flex + flex),
        .data$pos %in% c("DL", "LB", "DB") ~ as.integer(.data$min + idp_flex),
        TRUE ~ as.integer(.data$min)
      ),
      total_starters = sum(.data$min, na.rm = TRUE),
      offense_starters = sum(
        .data$pos %in% c("QB", "RB", "WR", "TE", "FLEX", "WRRB_FLEX", "REC_FLEX", "SUPER_FLEX") * .data$min,
        na.rm = TRUE
      ),
      defense_starters = sum(.data$pos %in% c("IDP_FLEX", "DL", "LB", "DB") * .data$min, na.rm = TRUE),
      kdef = sum(.data$pos %in% c("K", "DEF") * .data$min, na.rm = TRUE)
    ) %>%
    dplyr::filter(stringr::str_detect(.data$pos, "FLEX", negate = TRUE)) %>%
    dplyr::select(
      "pos", "min", "max", "offense_starters", "defense_starters", "total_starters"
    )
}
