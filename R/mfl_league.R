#### MFL LEAGUE SUMMARY ####

#' Get a summary of common league settings
#'
#' @param conn the connection object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   ssb_conn <- ff_connect(platform = "mfl", league_id = 22627, season = 2021)
#'   ff_league(ssb_conn)
#' }) # end try
#' }
#'
#' @describeIn ff_league MFL: returns a summary of league features.
#' @export

ff_league.mfl_conn <- function(conn) {
  league_endpoint <- mfl_getendpoint(conn, endpoint = "league") %>%
    purrr::pluck("content", "league")

  tibble::tibble(
    league_id = conn$league_id,
    league_name = league_endpoint$name,
    season = as.integer(conn$season),
    league_type = .mfl_league_type(league_endpoint),
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
    league_depth = as.numeric(.data$roster_size) * as.numeric(.data$franchise_count) / as.numeric(.data$player_copies),
    draft_type = .mfl_draft_type(league_endpoint),
    draft_player_pool = league_endpoint[["draftPlayerPool"]] %||% NA_character_
  )
}

.mfl_draft_type <- function(league_endpoint) {
  x <- NULL

  if (!is.null(league_endpoint[["draft_kind"]])) x <- paste(x, paste(league_endpoint[["draft_kind"]], "draft"))

  if (!is.null(league_endpoint[["auction_kind"]])) x <- paste(x, paste(league_endpoint[["auction_kind"]], "auction"))

  if (is.null(x)) x <- NA_character_

  x
}

.mfl_league_type <- function(league_endpoint) {
  x <- league_endpoint[["load_rosters"]]
  if (x == "contest") return(x)

  x <- league_endpoint[["keeperType"]]
  if (x == "none") x <- "redraft"

  x
}

## League Summary Helper Functions ##
.mfl_flag_scoring <- function(conn) {
  df_rules <- ff_scoring(conn)

  ppr_flag <- .mfl_check_ppr(df_rules)

  te_prem <- .mfl_check_teprem(df_rules)

  first_down <- .mfl_check_firstdown(df_rules)

  flags <- list(ppr_flag, te_prem, first_down)

  flags <- paste(flags[!is.na(flags)], collapse = ", ")

  return(flags)
}

#' @noRd
.mfl_check_ppr <- function(df_rules) {
  ppr <- dplyr::filter(df_rules, grepl("Receptions", .data$short_desc))

  if (nrow(ppr) == 0) {
    return("zero_ppr")
  }

  ppr <- dplyr::filter(ppr, .data$pos == "WR")$points

  return(paste0(ppr, "_ppr"))
}
#' @noRd
.mfl_check_teprem <- function(df_rules) {
  te_prem <- dplyr::group_by(df_rules, .data$pos) %>%
    dplyr::summarise(point_sum = sum(.data$points))

  ifelse(
    te_prem$point_sum[te_prem$pos == "TE"] > te_prem$point_sum[te_prem$pos == "WR"],
    "TEPrem",
    NA_character_
  )
}

#' @noRd
.mfl_check_firstdown <- function(df_rules) {
  first_downs <- df_rules %>%
    dplyr::filter(grepl("First Down", .data$short_desc))

  ifelse(nrow(first_downs) > 0, "PP1D", NA_character_)
}

#' @noRd
.mfl_is_idp <- function(league_endpoint) {
  ifelse(is.null(league_endpoint$starters$idp_starters) || league_endpoint$starters$idp_starters == "", FALSE, TRUE)
}
#' @noRd
.mfl_is_qbtype <- function(league_endpoint) {
  starters <- purrr::pluck(league_endpoint, "starters", "position") %>%
    dplyr::bind_rows()

  qb_count <- dplyr::filter(starters, .data$name == "QB")[["limit"]]

  qb_type <- dplyr::case_when(
    qb_count == "1" ~ "1QB",
    qb_count == "1-2" ~ "2QB/SF",
    qb_count == "2" ~ "2QB/SF"
  )

  list(
    count = qb_count,
    type = qb_type
  )
}
#' @noRd
.mfl_roster_size <- function(league_endpoint) {
  as.numeric(league_endpoint$rosterSize) +
    # as.numeric(league_endpoint$injuredReserve) +
    as.numeric(league_endpoint$taxiSquad)
}

#' @noRd
.mfl_years_active <- function(league_endpoint) {
  years_active <- league_endpoint$history$league %>%
    dplyr::bind_rows() %>%
    dplyr::arrange(.data$year)

  years_active %>%
    dplyr::slice(1, nrow(years_active)) %>%
    dplyr::pull("year") %>%
    paste(collapse = "-")
}

#' @noRd
.mfl_is_bestball <- function(league_endpoint) {
  league_endpoint$bestLineup == "Yes"
}

#' @noRd
.mfl_is_salcap <- function(league_endpoint) {
  league_endpoint$usesSalaries == "1"
}
