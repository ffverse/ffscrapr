#### ESPN LEAGUE SUMMARY ####

#' Get a summary of common league settings
#'
#' @param conn the connection object created by \code{ff_connect()}
#'
#' @examples
#' \donttest{
#' conn <- espn_connect(2020, league_id = "899513")
#' ff_league(conn)
#' }
#'
#' @describeIn ff_league ESPN: returns a summary of league features.
#'
#' @export
ff_league.espn_conn <- function(conn) {
  # league_endpoint <- fleaflicker_getendpoint_getendpoint("FetchLeagueStandings", league_id = conn$league_id, sport = "NFL", season = conn$season) %>%
  #   purrr::pluck("content")
  #
  # league_endpoint <- glue::glue("league/{conn$league_id}") %>%
  #   sleeper_getendpoint() %>%
  #   purrr::pluck("content")
  #
  # starting_positions <- league_endpoint %>%
  #   purrr::pluck("roster_positions") %>%
  #   tibble::enframe() %>%
  #   dplyr::mutate(value = as.character(.data$value))
  #
  # scoring_settings <- league_endpoint %>%
  #   purrr::pluck("scoring_settings") %>%
  #   tibble::enframe(name = "event", value = "points") %>%
  #   dplyr::arrange(.data$event) %>%
  #   dplyr::mutate(points = as.numeric(.data$points))

  league_endpoint <-
    espn_getendpoint(
      conn = conn,
      view = "mSettings"
    )
  league_endpoint
  league_endpoint$content$settings$name

  # n_team <- length(league_endpoint$content$members)
  # n_team

  # teams <-
  #   league_endpoint$content$teams %>%
  #   jsonlite::parse_json() %>%
  #   jsonlite::flatten() %>%
  #   tibble::as_tibble() %>%
  #   dplyr::select(
  #     team_id = .data$id,
  #     .data$location,
  #     .data$nickname,
  #     .data$abbrev
  #   ) %>%
  #   dplyr::mutate(
  #     dplyr::across(c(.data$location, .data$nickname, .data$abbrev), stringr::str_trim),
  #     team = sprintf('%s %s', .data$location, .data$nickname)
  #   ) %>%
  #   dplyr::relocate(.data$team_id, .data$team)
  tibble::tibble(
    league_id = conn$league_id,
    league_name = league_endpoint$content$settings$name,
    # league_type = '',
    franchise_count = league_endpoint$content$settings$size,
    qb_type = .espn_is_qbtype(league_endpoint)$type
    idp = .espn_is_idp(league_endpoint),
    scoring_flags = '',
    best_ball = '',
    salary_cap = '',
    player_opies = '',
    years_active = '',
    qb_count = .espn_is_qbtype(league_endpoint)$count,
    roster_size = '',
    league_depth = '',
    keeper_count = ''
  )

  tibble::tibble(
    league_id = conn$league_id,
    league_name = league_endpoint$name,
    franchise_count = as.numeric(league_endpoint$franchises$count),
    qb_type = .mfl_is_qbtype(league_endpoint)$type,
    idp = .mfl_is_idp(league_endpoint),
    scoring_flags = .mfl_flag_scoring(conn),
    best_ball = .mfl_is_bestball(league_endpoint),
    salary_cap = .mfl_is_salcap(league_endpoint),
    player_copies = as.numeric(league_endpoint$rostersPerPlayer),
    years_active = .mfl_years_active(league_endpoint),
    qb_count = .mfl_is_qbtype(league_endpoint)$count,
    roster_size = .mfl_roster_size(league_endpoint),
    league_depth = as.numeric(.data$roster_size) * as.numeric(.data$franchise_count) / as.numeric(.data$player_copies)
  )

  tibble::tibble(
    league_id = as.character(conn$league_id),
    league_name = league_endpoint$league$name,
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
    '3' = "passingYards",
    '4' = "passingTouchdowns",

    '19' = "passing2PtConversions",
    '20' = "passingInterceptions",

    '24' = "rushingYards",
    '25' = "rushingTouchdowns",
    '26' = "rushing2PtConversions",

    '42' = "receivingYards",
    '43' = "receivingTouchdowns",
    '44' = "receiving2PtConversions",
    '53' = "receivingReceptions",

    '72' = "lostFumbles",

    '74' = "madeFieldGoalsFrom50Plus",
    '77' = "madeFieldGoalsFrom40To49",
    '80' = "madeFieldGoalsFromUnder40",
    '85' = "missedFieldGoals",
    '86' = "madeExtraPoints",
    '88' = "missedExtraPoints",

    '89' = "defensive0PointsAllowed",
    '90' = "defensive1To6PointsAllowed",
    '91' = "defensive7To13PointsAllowed",
    '92' = "defensive14To17PointsAllowed",

    '93' = "defensiveBlockedKickForTouchdowns",
    '95' = "defensiveInterceptions",
    '96' = "defensiveFumbles",
    '97' = "defensiveBlockedKicks",
    '98' = "defensiveSafeties",
    '99' = "defensiveSacks",

    '101' = "kickoffReturnTouchdown",
    '102' = "puntReturnTouchdown",
    '103' = "fumbleReturnTouchdown",
    '104' = "interceptionReturnTouchdown",

    '123' = "defensive28To34PointsAllowed",
    '124' = "defensive35To45PointsAllowed",

    '129' = "defensive100To199YardsAllowed",
    '130' = "defensive200To299YardsAllowed",
    '132' = "defensive350To399YardsAllowed",
    '133' = "defensive400To449YardsAllowed",
    '134' = "defensive450To499YardsAllowed",
    '135' = "defensive500To549YardsAllowed",
    '136' = "defensiveOver550YardsAllowed",

    # Punter Stats
    '140' = "puntsInsideThe10", # PT10
    '141' = "puntsInsideThe20", # PT20
    '148' = "puntAverage44.0+", # PTA44
    '149' = "puntAverage42.0-43.9", #PTA42
    '150' = "puntAverage40.0-41.9", #PTA40

    # Head Coach stats
    '161' = "25+pointsWinMargin", #WM25
    '162' = "20-24pointWinMargin", #WM20
    '163' = "15-19pointWinMargin", #WM15
    '164' = "10-14pointWinMargin", #WM10
    '165' = "5-9pointWinMargin", # WM5
    '166' = "1-4pointWinMargin", # WM1

    '155' = "TeamWin", # TW

    '171' = "20-24pointLossMargin", # LM20
    '172' = "25+pointLossMargin", # LM25
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
  stat_ids <- league_endpoint$content$settings$scoringSettings$scoringItems %>% purrr::map_int(~.x$statId)

  position_map <- .espn_position_map()
  def_pos <- position_map[c("DT", "DE")]
  def_count <- league_endpoint$content$settings$rosterSettings$lineupSlotCounts[def_pos]
  has_def <- sum(unlist(def_count)) > 0
  has_def
}

#' @noRd
.espn_scoring_flags <- function(conn) {
  scoring_settings <- ff_scoring(conn)

  ppr_flag <- .espn_check_ppr(scoring_settings)
  teprem_flag <- .espn_check_teprem(scoring_settings)
  firstdown_flag <- .espn_check_firstdown(scoring_settings)

  flags <- list(ppr_flag, teprem_flag, firstdown_flag)

  paste(flags[!is.na(flags) & !is.null(flags)], collapse = ", ")
}

