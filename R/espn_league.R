#### ESPN LEAGUE SUMMARY ####

#' Get a summary of common league settings
#'
#' @param conn the connection object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' conn <- espn_connect(season = 2020, league_id = 899513)
#' ff_league(conn)
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
    season = conn$season,
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
  op_pos <- position_map["OP"]
  qb_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[[qb_pos]]
  op_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[[op_pos]]

  type <- dplyr::case_when(
    qb_count == 1 & op_count < 1 ~ "1QB",
    qb_count == 1 & op_count == 1 ~ "2QB/SF",
    TRUE ~ "2+QB/SF"
  )
  count <- dplyr::case_when(
    op_count > 0 ~ paste(qb_count, qb_count + op_count, sep = "-"),
    op_count == 0 ~ paste(qb_count)
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
  stat_ids <- league_endpoint$content$settings$scoringSettings$scoringItems %>% purrr::map_chr(~ .x$statId)
  stat_ids_named <- stat_map[stat_ids] # %>% purrr::discard(~is.na(.x))
  idx_rec <- which(stat_ids_named == "receivingReceptions")
  seq_stat_ids <- seq_along(stat_ids)
  ppr <- league_endpoint$content$settings$scoringSettings$scoringItems[idx_rec][[1]]$point
  ifelse(ppr > 0, paste0(ppr, "_ppr"), "zero_ppr")
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
