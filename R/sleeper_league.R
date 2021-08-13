#### Sleeper LEAGUE SUMMARY ####

#' Get a summary of common league settings
#'
#' @param conn the connection object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
#'   ff_league(jml_conn)
#' }) # end try
#' }
#' @describeIn ff_league Sleeper: returns a summary of league features.
#'
#' @export
ff_league.sleeper_conn <- function(conn) {
  league_endpoint <- glue::glue("league/{conn$league_id}") %>%
    sleeper_getendpoint() %>%
    purrr::pluck("content")

  starting_positions <- league_endpoint %>%
    purrr::pluck("roster_positions") %>%
    tibble::enframe() %>%
    dplyr::mutate(value = as.character(.data$value))

  scoring_settings <- league_endpoint %>%
    purrr::pluck("scoring_settings") %>%
    tibble::enframe(name = "event", value = "points") %>%
    dplyr::arrange(.data$event) %>%
    dplyr::mutate(points = as.numeric(.data$points))

  tibble::tibble(
    league_id = as.character(conn$league_id),
    league_name = league_endpoint$name,
    season = as.integer(conn$season),
    league_type = .sleeper_isdyno(league_endpoint),
    franchise_count = as.numeric(league_endpoint$total_rosters),
    qb_type = .sleeper_qbtype(starting_positions)$type,
    idp = .sleeper_isidp(starting_positions),
    scoring_flags = .sleeper_flag_scoring(scoring_settings),
    best_ball = .sleeper_isbestball(league_endpoint),
    salary_cap = FALSE,
    player_copies = 1,
    years_active = .sleeper_history(league_endpoint)$season,
    qb_count = .sleeper_qbtype(starting_positions)$count,
    roster_size = nrow(starting_positions),
    league_depth = as.numeric(.data$roster_size) * as.numeric(.data$franchise_count) / as.numeric(.data$player_copies),
    prev_league_ids = .sleeper_history(league_endpoint)$league_id
  )
}

.sleeper_isbestball <- function(league_endpoint) {
  x <- league_endpoint$settings[["best_ball"]]

  if (!is.null(x) && as.logical(x)) {
    return(TRUE)
  }

  return(FALSE)
}

.sleeper_isdyno <- function(league_endpoint) {
  switch(as.character(league_endpoint$settings$type),
    "2" = "dynasty",
    "1" = "keeper",
    "0" = "redraft"
  )
}

.sleeper_qbtype <- function(starting_positions) {
  QB <- sum(starting_positions$value %in% c("QB"))
  SF <- sum(starting_positions$value %in% c("SUPER_FLEX"))

  x <- sum(QB, SF, na.rm = TRUE)

  type <- dplyr::case_when(
    x >= 2 ~ "2QB/SF",
    x == 1 ~ "1QB",
    x == 0 ~ "NoQB"
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

.sleeper_isidp <- function(starting_positions) {
  sum(starting_positions$value %in% c("DL", "LB", "DB", "IDP_FLEX")) > 0
}

.sleeper_flag_scoring <- function(scoring_settings) {
  ppr_flag <- .sleeper_check_ppr(scoring_settings)
  teprem_flag <- .sleeper_check_teprem(scoring_settings)
  firstdown_flag <- .sleeper_check_firstdown(scoring_settings)

  flags <- list(ppr_flag, teprem_flag, firstdown_flag)

  flags <- paste(flags[!is.na(flags) & !is.null(flags)], collapse = ", ")

  return(flags)
}

.sleeper_check_ppr <- function(scoring_settings) {
  x <- scoring_settings %>%
    dplyr::filter(.data$event == "rec") %>%
    dplyr::pull(.data$points)

  ifelse(x > 0, paste0(x, "_ppr"), "zero_ppr")
}

.sleeper_check_teprem <- function(scoring_settings) {
  x <- scoring_settings %>%
    dplyr::filter(.data$event == "bonus_rec_te") %>%
    dplyr::pull(.data$points)

  ifelse(!is.null(x) && x > 0, paste0(x, "TEPrem"), NA_character_)
}

.sleeper_check_firstdown <- function(scoring_settings) {
  x <- scoring_settings %>%
    dplyr::filter(.data$event %in% c("rush_fd", "rec_fd", "pass_fd"))

  ifelse(nrow(x) > 0, "PP1D", NA_character_)
}

.sleeper_history <- function(league_endpoint) {
  history <- list(
    season = league_endpoint$season
  )

  prev <- league_endpoint$previous_league_id

  while (!is.null(prev) && prev != "0") {
    prev_endpoint <- glue::glue("league/{prev}") %>%
      sleeper_getendpoint() %>%
      purrr::pluck("content")

    history$season <- c(history$season, prev_endpoint$season)
    history$league_id <- c(history$league_id, prev)

    prev <- prev_endpoint$previous_league_id
  }

  history$season <- as.numeric(history$season)

  history$season <- paste(c(min(history$season), max(history$season)), collapse = "-")

  history$league_id <- as.character(history$league_id) %>% paste(collapse = ", ")

  return(history)
}
