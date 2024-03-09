#' Sleeper players library
#'
#' A cached table of Sleeper NFL players. Will store in memory for each session!
#' (via memoise in zzz.R)
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   x <- sleeper_players()
#'   dplyr::sample_n(x, 5)
#' }) # end try
#' }
#'
#' @return a dataframe containing all ~7000+ players in the Sleeper database
#' @export

sleeper_players <- function() {
  df_players <- sleeper_getendpoint("players/nfl") %>%
    purrr::pluck("content") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::mutate_at("fantasy_positions", ~ purrr::map(.x, as.character) %>% as.character()) %>%
    dplyr::mutate_at(c("birth_date", "injury_start_date"), .as_date) %>%
    dplyr::mutate(
      age = round(as.numeric(Sys.Date() - .data$birth_date) / 365.25, 1),
      gsis_id = stringr::str_squish(gsis_id),
      weight = as.integer(weight)
    ) %>%
    dplyr::mutate_at(
      c("injury_status", "injury_body_part", "injury_notes"),
      as.character
    ) %>%
    dplyr::mutate_at(
      dplyr::vars(dplyr::contains("_id")),
      as.character
    ) %>%
    dplyr::select(
      -dplyr::contains("search"),
      -dplyr::contains("first_name"),
      -dplyr::contains("last_name"),
      -dplyr::contains("metadata")
    ) %>%
    dplyr::select(
      "player_id",
      "player_name" = "full_name",
      "pos" = "position",
      "age",
      "team",
      "status",
      "years_exp",
      dplyr::starts_with("draft_"),
      dplyr::ends_with("_id"),
      dplyr::everything()
    )

  df_players <- dplyr::bind_rows(.sleeper_players_template(), df_players)

  return(df_players)
}

.sleeper_players_template <- function(){
  tibble::tibble(
    player_id = character(0),
    player_name = character(0),
    pos = character(0),
    age = numeric(0),
    team = character(0),
    status = character(0),
    active = logical(0),
    years_exp = integer(0),
    swish_id = character(0),
    espn_id = character(0),
    fantasy_data_id = character(0),
    pandascore_id = character(0),
    rotowire_id = character(0),
    sportradar_id = character(0),
    yahoo_id = character(0),
    oddsjam_id = character(0),
    dl_trading_id = character(0),
    rotoworld_id = character(0),
    stats_id = character(0),
    gsis_id = character(0),
    height = character(0),
    weight = integer(0),
    fantasy_positions = character(0),
    number = integer(0),
    depth_chart_order = integer(0),
    depth_chart_position = character(0),
    practice_description = character(0),
    birth_date = as.Date(character(0)),
    birth_city = character(0),
    birth_state = character(0),
    birth_country = character(0),
    high_school = character(0),
    college = character(0),
    practice_participation = character(0),
    injury_status = character(0),
    injury_start_date = as.Date(character(0)),
    injury_body_part = character(0),
    injury_notes = character(0),
    news_updated = numeric(0),
    hashtag = character(0),
    sport = character(0)
  )
}
