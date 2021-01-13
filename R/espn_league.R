#### ESPN LEAGUE SUMMARY ####

#' Get a summary of common league settings
#'
#' @param conn the connection object created by \code{ff_connect()}
#'
#' @examples
#' \donttest{
#' conn <- espn_connect(
#'   season = 2020,
#'   league_id = 899513,
#'   espn_s2 = Sys.getenv("FF_ESPN_S2"),
#'   swid = Sys.getenv("FF_SWID")
#' )
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
    # league_type = "",
    franchise_count = franchise_count,
    qb_type = .espn_is_qbtype(league_endpoint)$type,
    idp = .espn_is_idp(league_endpoint),
    scoring_flags = .espn_scoring_flags(league_endpoint),
    best_ball = FALSE,
    salary_cap = FALSE, # this may actually be possible to get
    player_copies = player_copies,
    # years_active = "",
    qb_count = .espn_is_qbtype(league_endpoint)$count,
    roster_size = roster_size,
    league_depth = roster_size * franchise_count / player_copies # ,
    # keeper_count = ""
  )
}

#' @noRd
#' @seealso \url{https://github.com/cwendt94/espn-api/blob/master/espn_api/football/constant.py}
.espn_position_map <- function() {
  c(
    "0" = "QB",
    "1" = "TQB",
    "2" = "RB",
    "3" = "RB/WR",
    "4" = "WR",
    "5" = "WR/TE",
    "6" = "TE",
    "7" = "OP",
    "8" = "DT",
    "9" = "DE",
    "10" = "LB",
    "11" = "DL",
    "12" = "CB",
    "13" = "S",
    "14" = "DB",
    "15" = "DP",
    "16" = "D/ST",
    "17" = "K",
    "18" = "P",
    "19" = "HC",
    "20" = "BE",
    "21" = "IR",
    "22" = "",
    "23" = "RB/WR/TE",
    "24" = "ER",
    "25" = "Rookie",
    "QB" = 0,
    "RB" = 2,
    "WR" = 4,
    "TE" = 6,
    "OP" = 7, # added
    "D/ST" = 16,
    "K" = 17,
    "FLEX" = 23,
    "DT" = 8,
    "DE" = 9,
    "LB" = 10,
    "DL" = 11,
    "CB" = 12,
    "S" = 13,
    "DB" = 14,
    "DP" = 15,
    "HC" = 19
  )
}

#' @noRd
#' @seealso \url{https://github.com/cwendt94/espn-api/blob/master/espn_api/football/constant.py}
.espn_stat_map <- function() {
  c(
    "3" = "passingYards",
    "4" = "passingTouchdowns",

    "19" = "passing2PtConversions",
    "20" = "passingInterceptions",

    "24" = "rushingYards",
    "25" = "rushingTouchdowns",
    "26" = "rushing2PtConversions",

    "42" = "receivingYards",
    "43" = "receivingTouchdowns",
    "44" = "receiving2PtConversions",
    "53" = "receivingReceptions",

    "72" = "lostFumbles",

    "74" = "madeFieldGoalsFrom50Plus",
    "77" = "madeFieldGoalsFrom40To49",
    "80" = "madeFieldGoalsFromUnder40",
    "85" = "missedFieldGoals",
    "86" = "madeExtraPoints",
    "88" = "missedExtraPoints",

    "89" = "defensive0PointsAllowed",
    "90" = "defensive1To6PointsAllowed",
    "91" = "defensive7To13PointsAllowed",
    "92" = "defensive14To17PointsAllowed",

    "93" = "defensiveBlockedKickForTouchdowns",
    "95" = "defensiveInterceptions",
    "96" = "defensiveFumbles",
    "97" = "defensiveBlockedKicks",
    "98" = "defensiveSafeties",
    "99" = "defensiveSacks",

    "101" = "kickoffReturnTouchdown",
    "102" = "puntReturnTouchdown",
    "103" = "fumbleReturnTouchdown",
    "104" = "interceptionReturnTouchdown",

    "123" = "defensive28To34PointsAllowed",
    "124" = "defensive35To45PointsAllowed",

    "129" = "defensive100To199YardsAllowed",
    "130" = "defensive200To299YardsAllowed",
    "132" = "defensive350To399YardsAllowed",
    "133" = "defensive400To449YardsAllowed",
    "134" = "defensive450To499YardsAllowed",
    "135" = "defensive500To549YardsAllowed",
    "136" = "defensiveOver550YardsAllowed",

    # Punter Stats
    "140" = "puntsInsideThe10", # PT10
    "141" = "puntsInsideThe20", # PT20
    "148" = "puntAverage44.0+", # PTA44
    "149" = "puntAverage42.0-43.9", #PTA42
    "150" = "puntAverage40.0-41.9", #PTA40

    # Head Coach stats
    "161" = "25+pointsWinMargin", #WM25
    "162" = "20-24pointWinMargin", #WM20
    "163" = "15-19pointWinMargin", #WM15
    "164" = "10-14pointWinMargin", #WM10
    "165" = "5-9pointWinMargin", # WM5
    "166" = "1-4pointWinMargin", # WM1

    "155" = "TeamWin", # TW

    "171" = "20-24pointLossMargin", # LM20
    "172" = "25+pointLossMargin" # LM25
  )
}

#' @noRd
.espn_is_qbtype <- function(league_endpoint) {
  position_map <- .espn_position_map()
  qb_pos <- position_map["QB"]
  op_pos <- position_map["OP"]
  qb_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[[qb_pos]]
  op_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[[op_pos]]

  qb_type <- dplyr::case_when(
    qb_count == 1 & op_count < 1 ~ "1QB",
    qb_count == 1 & op_count == 1 ~ "2QB/SF",
    TRUE ~ "2+QB/SF"
  )

  list(
    count = qb_count,
    type = qb_type
  )
}

#' @noRd
.espn_is_idp <- function(league_endpoint) {
  position_map <- .espn_position_map()
  def_pos <- position_map[c("DT", "DE", "LB", "DL", "CB", "S", "DB", "DP")]
  def_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[def_pos]
  has_def <- sum(unlist(def_count)) > 0
  has_def
}

#' @noRd
.espn_check_ppr <- function(league_endpoint) {
  stat_map <- .espn_stat_map()
  stat_ids <- league_endpoint$content$settings$scoringSettings$scoringItems %>% purrr::map_chr(~.x$statId)
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
  roster_size <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts %>% purrr::map_int(~.x) %>% sum()
  roster_size
}
