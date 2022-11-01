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
    dplyr::mutate_at("birth_date", .as_date) %>%
    dplyr::mutate(
      age = round(as.numeric(Sys.Date() - .data$birth_date) / 365.25, 1),
      gsis_id = stringr::str_squish(gsis_id)
    ) %>%
    dplyr::select(-dplyr::contains("search"), -dplyr::contains("first_name"), -dplyr::contains("last_name"), -dplyr::contains("metadata")) %>%
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

  return(df_players)
}
