## ff_rosters (MFL) ##

#' Get a dataframe of scoring settings, referencing the "all rules" library endpoint.
#' The all-rules endpoint is saved to a cache, so subsequent function calls should be faster!
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @examples
#' ssb_conn <- ff_connect(platform = "mfl",league_id = 54040,season = 2020)
#' ff_rosters(ssb_conn)
#'
#'
#' @seealso \url{http://www03.myfantasyleague.com/2020/scoring_rules#rules}
#'
#' @rdname ff_rosters
#' @export

ff_rosters.mfl_conn <- function(conn){

  rosters_endpoint <- mfl_getendpoint(conn,"rosters") %>%
    purrr::pluck("content","rosters","franchise") %>%
    tibble::tibble() %>%
    tidyr::hoist(1,'player'='player','franchise_id'='id') %>%
    dplyr::filter(!is.na(.data$player)) %>%
    dplyr::mutate("player"= purrr::map(.data$player,dplyr::bind_rows)) %>%
    tidyr::unnest("player") %>%
    dplyr::rename("player_id"=.data$id,
                  "roster_status" = .data$status) %>%
    dplyr::select("franchise_id","player_id",dplyr::everything())

  players_endpoint <- mfl_players() %>%
    dplyr::select("player_id","player_name","pos","team","age","draft_year","draft_round")

  rosters_endpoint %>%
    dplyr::left_join(players_endpoint, by = "player_id")

 }

#' MFL players library
#'
#' A cached table of MFL players. Will store in memory for each session!
#' (via memoise)
#'
#' @examples
#' player_list <- mfl_players()
#' dplyr::sample_n(player_list,5)
#'
#' @return a dataframe containing all ~2000+ players in the MFL database
#' @export

mfl_players <- memoise::memoise(function() {
  mfl_connect(.fn_choose_season()) %>%
    mfl_getendpoint("players",DETAILS = 1) %>%
    purrr::pluck("content", "players", "player") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::mutate_at("birthdate", ~as.numeric(.x) %>% lubridate::as_datetime() %>% lubridate::as_date()) %>%
    dplyr::mutate("age" = round(as.numeric(Sys.Date() - .data$birthdate)/365.25,1)) %>%
    dplyr::select(
      "player_id" = .data$id,
      "player_name" = .data$name,
      "pos" = .data$position,
      .data$age,
      .data$team,
      .data$status,
      dplyr::starts_with("draft_"),
      dplyr::ends_with("_id"),
      dplyr::everything())
  })

