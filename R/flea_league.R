#### Fleaflicker LEAGUE SUMMARY ####

#' Get a summary of common league settings
#'
#' @param conn the connection object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- fleaflicker_connect(2020, 206154)
#'   ff_league(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_league Flea: returns a summary of league features.
#'
#' @export
ff_league.flea_conn <- function(conn) {
  league_endpoint <- fleaflicker_getendpoint("FetchLeagueStandings", league_id = conn$league_id, sport = "NFL", season = conn$season) %>%
    purrr::pluck("content")

  tibble::tibble(
    league_id = as.character(conn$league_id),
    league_name = league_endpoint$league$name,
    season = as.integer(conn$season),
    league_type = .flea_isdyno(league_endpoint),
    franchise_count = as.numeric(league_endpoint$league[["capacity"]]),
    qb_type = .flea_qbtype(league_endpoint)$type,
    idp = .flea_isidp(league_endpoint),
    scoring_flags = .flea_flag_scoring(conn),
    best_ball = FALSE,
    salary_cap = FALSE,
    player_copies = 1,
    qb_count = .flea_qbtype(league_endpoint)$count,
    roster_size = league_endpoint$league$rosterRequirements$rosterSize,
    league_depth = as.numeric(.data$roster_size) * as.numeric(.data$franchise_count) / as.numeric(.data$player_copies),
    keeper_count = league_endpoint$league[["maxKeepers"]]
  )
}

.flea_isdyno <- function(league_endpoint) {
  max_keepers <- league_endpoint %>%
    purrr::pluck("league", "maxKeepers")

  if (is.null(max_keepers)) max_keepers <- 0

  team_count <- league_endpoint %>%
    purrr::pluck("league", "capacity")

  player_count <- max_keepers * team_count

  dplyr::case_when(
    player_count == 0 ~ "redraft",
    player_count <= 250 ~ "keeper",
    TRUE ~ "dynasty"
  )
}

.flea_qbtype <- function(league_endpoint) {
  x <- league_endpoint %>%
    purrr::pluck("league", "rosterRequirements", "positions") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "label", "start") %>%
    dplyr::filter(.data$label %in% c("QB", "QB/RB/WR/TE"))

  QB <- x$start[x$label == "QB"]
  SF <- x$start[x$label == "QB/RB/WR/TE"]

  if (length(QB) == 0) QB <- 0

  if (length(SF) == 0) SF <- 0

  y <- sum(QB, SF, na.rm = TRUE)

  type <- dplyr::case_when(
    y >= 2 ~ "2QB/SF",
    y == 1 ~ "1QB",
    y == 0 ~ "NoQB"
  )

  count <- dplyr::case_when(
    SF > 0 ~ paste(QB, QB + SF, sep = "-"),
    SF == 0 ~ paste(QB)
  )

  list(
    type = type,
    count = count
  )
}

.flea_isidp <- function(league_endpoint) {
  x <- league_endpoint %>%
    purrr::pluck("league", "rosterRequirements", "positions") %>%
    tibble::tibble() %>%
    tidyr::hoist(1, "label", "start")

  any(x$label %in% c("LB", "EDR", "DL", "IL", "LB", "DB", "CB", "S"))
}

.flea_flag_scoring <- function(conn) {
  scoring_settings <- ff_scoring(conn)

  ppr_flag <- .flea_check_ppr(scoring_settings)
  teprem_flag <- .flea_check_teprem(scoring_settings)
  firstdown_flag <- .flea_check_firstdown(scoring_settings)

  flags <- list(ppr_flag, teprem_flag, firstdown_flag)

  flags <- paste(flags[!is.na(flags) & !is.null(flags)], collapse = ", ")

  return(flags)
}

.flea_check_ppr <- function(scoring_settings) {
  x <- scoring_settings %>%
    dplyr::filter(.data$event == "Catch", .data$pos == "WR") %>%
    dplyr::pull(.data$points)

  ifelse(x > 0, paste0(x, "_ppr"), "zero_ppr")
}

.flea_check_teprem <- function(scoring_settings) {
  te_prem <- scoring_settings %>%
    dplyr::group_by(.data$pos) %>%
    dplyr::summarise(points = sum(.data$points))

  ifelse(
    te_prem$points[te_prem$pos == "TE"] > te_prem$points[te_prem$pos == "WR"],
    "TEPrem",
    NA_character_
  )
}

.flea_check_firstdown <- function(scoring_settings) {
  first_downs <- scoring_settings %>%
    dplyr::filter(stringr::str_detect(.data$event, "First Down"))

  ifelse(nrow(first_downs) > 0, "PP1D", NA_character_)
}
