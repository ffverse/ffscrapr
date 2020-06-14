#### MFL LEAGUE SUMMARY ####

#' Get a summary of common league settings
#'
#' This function returns a tibble of common league settings - things like "1QB" or "2QB", best ball, team count etc
#'
#' @param conn the connection object created by \code{mfl_connect()}
#'
#' @examples
#' ff_connect(platform = "mfl",league_id = 54040,season = 2020) %>% ff_league() %>% str()
#'
#' @rdname ff_league
#' @export

ff_league.mfl_conn <- function(conn){

  league_endpoint <- mfl_getendpoint(conn,endpoint = "league")
  league_endpoint <- purrr::pluck(league_endpoint,"content","league")

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
}

## League Summary Helper Functions ##
.mfl_flag_scoring <- function(conn){

  df_rules <- mfl_scoring_settings(conn)

  ppr_flag <- .mfl_check_ppr(df_rules)

  te_prem <- .mfl_check_teprem(df_rules)

  first_down <- .mfl_check_firstdown(df_rules)

  flags <- list(ppr_flag,te_prem,first_down)

  flags <- paste(flags[!is.na(flags)],collapse = ", ")

  return(flags)
}

#' @noRd
.mfl_check_ppr <- function(df_rules){

  ppr <- dplyr::filter(df_rules,grepl("Receptions", .data$short_desc))

  if(nrow(ppr)==0) return("zero_ppr")

  ppr <- dplyr::filter(ppr,.data$positions=="WR")$points

  return(paste0(ppr,"_ppr"))
}
#' @noRd
.mfl_check_teprem <- function(df_rules){

  te_prem <- dplyr::group_by(df_rules,.data$positions)
  te_prem <- dplyr::summarise(te_prem,point_sum = sum(.data$points))

  ifelse(
    te_prem$point_sum[te_prem$positions=="TE"] > te_prem$point_sum[te_prem$positions=="WR"],
    "TEPrem",
    NA_character_)
}

#' @noRd
.mfl_check_firstdown <- function(df_rules){
  first_downs <- dplyr::filter(df_rules,grepl("First Down", .data$short_desc))
  ifelse(nrow(first_downs)>0,"PP1D",NA_character_)
}

#' @noRd
.mfl_is_idp <- function(league_endpoint){
  ifelse(is.null(league_endpoint$starters$idp_starters) || league_endpoint$starters$idp_starters=="",FALSE,TRUE)
}
#' @noRd
.mfl_is_qbtype <- function(league_endpoint){

  starters <- purrr::pluck(league_endpoint,"starters","position")

  starters <- dplyr::bind_rows(starters)

  qb_count <- dplyr::filter(starters,.data$name == "QB")[["limit"]]

  qb_type <- dplyr::case_when(qb_count == "1" ~ "1QB",
                              qb_count == "1-2" ~ "2QB/SF",
                              qb_count == "2" ~ "2QB/SF")

  list(count = qb_count,
       type = qb_type)
}
#' @noRd
.mfl_roster_size <- function(league_endpoint) {
  as.numeric(league_endpoint$rosterSize)+as.numeric(league_endpoint$taxiSquad)+as.numeric(league_endpoint$injuredReserve)
}

#' @noRd
.mfl_years_active <- function(league_endpoint){
  years_active <- league_endpoint$history$league
  years_active <- dplyr::bind_rows(years_active)
  years_active <- dplyr::arrange(years_active,.data$year)
  years_active <- dplyr::slice(years_active,1,nrow(years_active))
  paste(years_active$year,collapse = "-")
}

#' @noRd
.mfl_is_bestball <- function(league_endpoint){
  league_endpoint$bestLineup=="Yes"
}

#' @noRd
.mfl_is_salcap <- function(league_endpoint){
  league_endpoint$usesSalaries == "1"
}
