#### ESPN LEAGUE SUMMARY ####

#' Get a summary of common league settings
#'
#' @param conn the connection object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'
#'   conn <- espn_connect(season = 2020, league_id = 899513)
#'
#'   ff_league(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_league ESPN: returns a summary of league features.
#'
#' @export
ff_league.espn_conn <- function(conn) {
  league_endpoint <-
    espn_getendpoint(
      conn = conn,
      view = "mSettings"
    )

  franchise_count <- league_endpoint$content$settings$size
  roster_size <- .espn_roster_size(league_endpoint)
  player_copies <- 1

  tibble::tibble(
    league_id = conn$league_id,
    league_name = league_endpoint$content$settings$name,
    season = as.integer(conn$season),
    league_type = .espn_is_keeper(league_endpoint),
    franchise_count = franchise_count,
    qb_type = .espn_is_qbtype(league_endpoint)$type,
    idp = .espn_is_idp(league_endpoint),
    scoring_flags = .espn_scoring_flags(league_endpoint),
    best_ball = FALSE,
    salary_cap = FALSE, # this may actually be possible to get
    player_copies = player_copies,
    years_active = .espn_leaguehistory(conn, league_endpoint),
    qb_count = .espn_is_qbtype(league_endpoint)$count,
    roster_size = roster_size,
    league_depth = roster_size * franchise_count / player_copies,
    keeper_count = league_endpoint$content$settings$draftSettings$keeperCount
  )
}

#' @noRd
.espn_is_qbtype <- function(league_endpoint) {
  position_map <- .espn_lineupslot_map()
  qb_pos <- position_map["QB"]
  tqb_pos <- position_map["TQB"]
  op_pos <- position_map["OP"]

  qb_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[[qb_pos]]
  tqb_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[[tqb_pos]]
  op_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[[op_pos]]

  type <- dplyr::case_when(
    qb_count == 1 & op_count < 1 ~ "1QB",
    qb_count == 1 & op_count == 1 ~ "2QB/SF",
    tqb_count == 1 ~ "1QB",
    TRUE ~ "2+QB/SF"
  )

  count <- dplyr::case_when(
    op_count > 0 ~ paste(qb_count + tqb_count, qb_count + op_count + tqb_count, sep = "-"),
    op_count == 0 ~ paste(qb_count + tqb_count)
  )

  list(
    count = count,
    type = type
  )
}

#' @noRd
.espn_leaguehistory <- function(conn, league_endpoint) {
  start_year <- utils::head(league_endpoint$content$status$previousSeasons, 1) %>% unlist()

  paste0(start_year, "-", conn$season)
}

#' @noRd
.espn_is_idp <- function(league_endpoint) {
  position_map <- .espn_lineupslot_map()
  def_pos <- position_map[c("DT", "DE", "LB", "DL", "CB", "S", "DB", "DP")]
  def_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[def_pos]
  has_def <- sum(unlist(def_count)) > 0
  has_def
}

#' @noRd
.espn_check_ppr <- function(league_endpoint) {
  stat_map <- .espn_stat_map()
  ppr <- league_endpoint %>%
    purrr::pluck("content", "settings", "scoringSettings", "scoringItems") %>%
    purrr::map(`[`, c("statId", "points")) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(
      stat_name = .espn_stat_map()[as.character(.data$statId)]
    ) %>%
    dplyr::filter(.data$stat_name == "receivingReceptions") %>%
    dplyr::pull("points")

  ifelse(length(ppr) > 0 && ppr != 0, paste0(ppr, "_ppr"), "zero_ppr")
}

#' @noRd
.espn_check_teprem <- function(league_endpoint) {
  # I don't think ESPN allows TEs to get more points than WRs
  NA_character_
}

#' @noRd
.espn_check_firstdown <- function(league_endpoint) {
  # Another thing ESPN doesn't allow to be customized
  NA_character_
}

#' @noRd
.espn_scoring_flags <- function(league_endpoint) {
  ppr_flag <- .espn_check_ppr(league_endpoint)
  teprem_flag <- .espn_check_teprem(league_endpoint)
  firstdown_flag <- .espn_check_firstdown(league_endpoint)

  flags <- list(ppr_flag, teprem_flag, firstdown_flag)

  paste(flags[!is.na(flags) & !is.null(flags)], collapse = ", ")
}

#' @noRd
.espn_roster_size <- function(league_endpoint) {
  # scoring_settings <- ff_scoring(conn)
  roster_size <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts %>%
    purrr::map_int(~.x) %>%
    sum()
  roster_size
}

.espn_is_keeper <- function(league_endpoint) {
  x <- purrr::pluck(league_endpoint, "content", "settings", "draftSettings", "keeperCount")

  dplyr::case_when(
    x == 0 ~ "redraft",
    TRUE ~ "keeper"
  )
}
