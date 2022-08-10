#### ff_standings (MFL) ####

#' Get a dataframe of league standings
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... arguments passed to other methods
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   ssb_conn <- ff_connect(platform = "mfl", league_id = 54040, season = 2020)
#'   ff_standings(ssb_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_standings MFL: returns H2H/points/all-play/best-ball data in a table.
#'
#' @export
ff_standings.mfl_conn <- function(conn, ...) {
  standings_endpoint <- mfl_getendpoint(conn, "leagueStandings", ALL=1) %>%
    purrr::pluck("content", "leagueStandings", "franchise") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::left_join(
      ff_franchises(conn) %>% dplyr::select("franchise_id", "franchise_name"),
      by = c("id" = "franchise_id")
    ) %>%
    dplyr::mutate_all(~gsub(pattern = "\\$",replacement = "",x = .x)) %>%
    dplyr::mutate_at(dplyr::vars(-.data$id, -.data$franchise_name, -dplyr::matches("streak|strk|wlt")), as.numeric) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::matches("wlt")),~gsub(x = .x, pattern = "&#8209;", replacement = "-",fixed = TRUE)) %>%
    dplyr::mutate_if(is.numeric, round, 3) %>%
    dplyr::select(dplyr::any_of(c(
      "franchise_id" = "id",
      "franchise_name",
      "h2h_wins" = "h2hw",
      "h2h_losses" = "h2hl",
      "h2h_ties" = "h2ht",
      "h2h_winpct" = "h2hpct",
      "h2h_wlt" = "h2hwlt",
      "allplay_wins" = "all_play_w",
      "allplay_losses" = "all_play_l",
      "allplay_ties" = "all_play_t",
      "allplay_winpct" = "all_play_pct",
      "allplay_wlt" = "all_play_wlt",
      "points_for" = "pf",
      "points_against" = "pa",
      "avg_points_for" = "avgpf",
      "avg_points_against" = "avgpa",
      "max_points_against" = "maxpa",
      "min_points_against" = "minpa",
      "potential_points" = "pp",
      "victory_points" = "vp",
      "offensive_points" = "op",
      "defensive_points" = "dp",
      "streak" = "strk",
      "streak_type",
      "streak_len",
      "power_rank" = "pwr",
      "power_rank_alt" = "altpwr",
      "accounting_balance" = "acct",
      "faab_balance" = "bbidbalance",
      "salary"
    )))

  return(standings_endpoint)
}
