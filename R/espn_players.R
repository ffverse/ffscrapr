#' ESPN players library
#'
#' A cached table of ESPN NFL players. Will store in memory for each session!
#' (via memoise in zzz.R)
#'
#' @param conn a connection object created by \code{espn_connect} or \code{ff_connect()}
#' @param season a season to fetch
#'
#' @examples
#' \donttest{
#' conn <- espn_connect(season = 2020, league_id = 1178049)
#'
#' player_list <- espn_players(conn, season = 2020)
#' }
#'
#' @return a dataframe containing all ~2000+ active players in the ESPN database
#' @export

espn_players <- function(conn = NULL, season = NULL) {
  checkmate::assert_number(season, null.ok = TRUE)

  if (!is.null(conn) && is.null(season)) season <- conn$season

  if (is.null(season)) season <- .fn_choose_season()

  xff <- list(filterActive = list(value = TRUE)) %>%
    jsonlite::toJSON(auto_unbox = TRUE)

  xff <- httr::add_headers(`x-fantasy-filter` = xff)

  url_query <- glue::glue("https://fantasy.espn.com/apis/v3/games/ffl/seasons/{season}/players?scoringPeriodId=0&view=players_wl")

  fn_get <- get("get.espn", envir = .ffscrapr_env, inherits = TRUE)

  user_agent <- get("user_agent", envir = .ffscrapr_env, inherits = TRUE)

  response <- fn_get(url_query, user_agent, conn$cookies, xff)

  ## CHECK QUERY
  # nocov start

  if (httr::http_error(response) && httr::status_code(response) == 429) {
    warning(glue::glue("You've hit a rate limit wall! Please adjust the
                    built-in rate_limit arguments in espn_connect()!"), call. = FALSE)
  }

  if (httr::http_error(response)) {
    warning(glue::glue("ESPN API request failed with error: <{httr::status_code(response)}> \n
                    while calling <{url_query}>"), call. = FALSE)
  }

  if (httr::http_type(response) != "application/json") {
    warning(glue::glue("ESPN API did not return json while calling {url_query}"),
      call. = FALSE
    )
  }

  if (httr::http_type(response) == "application/json") {
    parsed <- jsonlite::parse_json(httr::content(x = response, as = "text"))
  }

  if (!is.null(parsed$error)) {
    warning(glue::glue("ESPN says: {parsed$error[[1]]}"), call. = FALSE)
  }
  # nocov end

  df_players <- parsed %>%
    tibble::tibble() %>%
    stats::setNames("x") %>%
    tidyr::hoist(
      "x",
      "player_id" = "id",
      "player_name" = "fullName",
      "pos" = "defaultPositionId",
      "eligible_pos" = "eligibleSlots",
      "team" = "proTeamId"
    ) %>%
    dplyr::mutate(
      pos = purrr::map_chr(as.character(.data$pos), ~ .espn_pos_map()[.x]),
      eligible_pos = purrr::map(.data$eligible_pos, ~ .espn_lineupslot_map()[as.character(.x)] %>% unname()),
      team = purrr::map_chr(as.character(.data$team), ~ .espn_team_map()[.x]),
      x = NULL
    )

  return(df_players)
}
