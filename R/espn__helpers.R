#### ESPN helper functions ####

#' ESPN Lineup Slot map
#'
#' This is for the starting lineup specifically - primary positions is accessible via `.espn_pos_map`
#'
#' @keywords internal
#' @seealso <https://github.com/cwendt94/espn-api/blob/master/espn_api/football/constant.py>
.espn_lineupslot_map <- function() {
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
    "16" = "DST",
    "17" = "K",
    "18" = "P",
    "19" = "HC",
    "20" = "BE",
    "21" = "IR",
    "22" = "XYZ",
    "23" = "RB/WR/TE",
    "24" = "ER",
    "25" = "Rookie",
    "QB" = 0,
    "TQB" = 1,
    "RB" = 2,
    "RB/WR" = 3,
    "WR" = 4,
    "WR/TE" = 5,
    "TE" = 6,
    "OP" = 7,
    "DT" = 8,
    "DE" = 9,
    "LB" = 10,
    "DL" = 11,
    "CB" = 12,
    "S" = 13,
    "DB" = 14,
    "DP" = 15,
    "DST" = 16,
    "K" = 17,
    "P" = 18,
    "HC" = 19,
    "BE" = 20,
    "IR" = 21,
    "XYZ" = 22,
    "RB/WR/TE" = 23,
    "ER" = 24,
    "Rookie" = 25
  )
}

#' ESPN Primary Position map
#'
#' Decoded by hand - if you have an IDP ESPN league please open a GitHub issue
#' and pass along the league info so we can expand this.
#'
#' @keywords internal

.espn_pos_map <- function() {
  c(
    "1" = "QB",
    "2" = "RB",
    "3" = "WR",
    "4" = "TE",
    "5" = "K",
    "7" = "P",
    "9" = "DT",
    "10" = "DE",
    "11" = "LB",
    "12" = "CB",
    "13" = "S",
    "14" = "HC",
    "16" = "DST",
    "QB" = 1,
    "RB" = 2,
    "WR" = 3,
    "TE" = 4,
    "K" = 5,
    "P" = 7,
    "DT" = 9,
    "DE" = 10,
    "LB" = 11,
    "CB" = 12,
    "S" = 13,
    "HC" = 14,
    "DST" = 16
  )
}

#' ESPN Team ID map
#'
#' Opinionatedly conforming to DynastyProcess standards, which match to MyFantasyLeague.
#' Abbreviations are consistently three letters.
#'
#' @keywords internal
#' @seealso <https://github.com/cwendt94/espn-api/blob/master/espn_api/football/constant.py>
.espn_team_map <- function() {
  c(
    "0" = "FA",
    "1" = "ATL",
    "2" = "BUF",
    "3" = "CHI",
    "4" = "CIN",
    "5" = "CLE",
    "6" = "DAL",
    "7" = "DEN",
    "8" = "DET",
    "9" = "GBP",
    "10" = "TEN",
    "11" = "IND",
    "12" = "KCC",
    "13" = "OAK",
    "14" = "LAR",
    "15" = "MIA",
    "16" = "MIN",
    "17" = "NEP",
    "18" = "NOS",
    "19" = "NYG",
    "20" = "NYJ",
    "21" = "PHI",
    "22" = "ARI",
    "23" = "PIT",
    "24" = "LAC",
    "25" = "SFO",
    "26" = "SEA",
    "27" = "TBB",
    "28" = "WAS",
    "29" = "CAR",
    "30" = "JAC",
    "33" = "BAL",
    "34" = "HOU",
    "FA" = "0",
    "ATL" = "1",
    "BUF" = "2",
    "CHI" = "3",
    "CIN" = "4",
    "CLE" = "5",
    "DAL" = "6",
    "DEN" = "7",
    "DET" = "8",
    "GBP" = "9",
    "TEN" = "10",
    "IND" = "11",
    "KCC" = "12",
    "OAK" = "13",
    "LAR" = "14",
    "MIA" = "15",
    "MIN" = "16",
    "NEP" = "17",
    "NOS" = "18",
    "NYG" = "19",
    "NYJ" = "20",
    "PHI" = "21",
    "ARI" = "22",
    "PIT" = "23",
    "LAC" = "24",
    "SFO" = "25",
    "SEA" = "26",
    "TBB" = "27",
    "WAS" = "28",
    "CAR" = "29",
    "JAC" = "30",
    "BAL" = "33",
    "HOU" = "34"
  )
}


#' ESPN Stat ID map
#'
#' @keywords internal
#' @seealso <https://github.com/cwendt94/espn-api/blob/master/espn_api/football/constant.py>
.espn_stat_map <- function() {
  c(
    "3" = "passingYards",
    "4" = "passingTouchdowns",
    "8" = "passing25Yards",
    "19" = "passing2PtConversions",
    "20" = "passingInterceptions",
    "24" = "rushingYards",
    "25" = "rushingTouchdowns",
    "26" = "rushing2PtConversions",
    "28" = "rushing10Yards",
    "35" = "rushing40YardTD",
    "37" = "rushing100YardGame",
    "38" = "rushing200YardGame",
    "42" = "receivingYards",
    "43" = "receivingTouchdowns",
    "44" = "receiving2PtConversions",
    "45" = "receiving40YardTD",
    "48" = "receiving10Yards",
    "53" = "receivingReceptions",
    "56" = "receiving100YardGame",
    "57" = "receiving200YardGame",
    "63" = "fumbleRecoveryTouchdown",
    "72" = "lostFumbles",
    "74" = "madeFieldGoalsFrom50Plus",
    "77" = "madeFieldGoalsFrom40To49",
    "79" = "missedFieldGoalsFrom40To49",
    "80" = "madeFieldGoalsFromUnder40",
    "82" = "missedFieldGoalsFromUnder40",
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
    "114" = "kickoffReturnYards",
    "115" = "puntReturnYards",
    "122" = "defensive22To27PointsAllowed",
    "123" = "defensive28To34PointsAllowed",
    "124" = "defensive35To45PointsAllowed",
    "125" = "defensive46+PointsAllowed",
    "128" = "defensive000To099YardsAllowed",
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
    "149" = "puntAverage42.0-43.9", # PTA42
    "150" = "puntAverage40.0-41.9", # PTA40

    # Head Coach stats
    "161" = "25+pointsWinMargin", # WM25
    "162" = "20-24pointWinMargin", # WM20
    "163" = "15-19pointWinMargin", # WM15
    "164" = "10-14pointWinMargin", # WM10
    "165" = "5-9pointWinMargin", # WM5
    "166" = "1-4pointWinMargin", # WM1

    "155" = "TeamWin", # TW

    "171" = "20-24pointLossMargin", # LM20
    "172" = "25+pointLossMargin", # LM25

    "198" = "madeFieldGoalsFrom50To59",
    "200" = "missedFieldGoalsFrom50To59",
    "201" = "madeFieldGoalsFrom60Plus",
    "203" = "missedFieldGoalsFrom60Plus",
    "206" = "2PtConversionReturnedForTouchdown",
    "209" = "1PtSafety"
  )
}

#' ESPN Activity/Transaction Mapping
#'
#' @keywords internal
#'
#' @seealso <https://github.com/cwendt94/espn-api/blob/master/espn_api/football/constant.py#L82-92>

.espn_activity_map <- function() {
  c(
    "178" = "FREE_AGENT|added",
    "179" = "FREE_AGENT|dropped",
    "180" = "BBID_WAIVER|added",
    "181" = "BBID_WAIVER|dropped",
    "239" = "DROP|dropped",
    "244" = "TRADE|traded_away",
    "FREE_AGENT|added" = "178",
    "BBID_WAIVER|added" = "180",
    "TRADE|traded_away" = "244"
  )
}
