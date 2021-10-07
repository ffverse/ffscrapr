#### ff_draft (ESPN) ####

#' Get Draft Results
#'
#' @param conn a conn object created by `ff_connect()`
#' @param ... args for other methods
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   conn <- espn_connect(season = 2020, league_id = 899513)
#'   ff_draft(conn)
#' }) # end try
#' }
#'
#' @describeIn ff_draft ESPN: returns the current year's draft/auction, including details on keepers
#'
#' @export
ff_draft.espn_conn <- function(conn, ...) {
  draft_endpoint <- espn_getendpoint(conn, view = "mDraftDetail") %>%
    purrr::pluck("content", "draftDetail")


  if (!draft_endpoint$drafted) {
    warning(
      glue::glue("ESPN league_id {conn$league_id} has not drafted yet!"),
      call. = FALSE
    )
  }

  draft_tibble <- draft_endpoint %>%
    tibble::as_tibble() %>%
    tidyr::unnest_wider("picks") %>%
    dplyr::mutate_at(
      dplyr::vars(dplyr::contains("completeDate")),
      ~ .as_datetime(.x / 1000)
    ) %>%
    dplyr::rename(
      "player_id" = "playerId",
      "franchise_id" = "teamId"
    ) %>%
    dplyr::left_join(
      ff_franchises(conn) %>%
        dplyr::select("franchise_id", "franchise_name", "user_nickname"),
      by = c("franchise_id")
    )

  x <- draft_tibble %>%
    dplyr::left_join(
      espn_players(conn) %>%
        dplyr::select("player_id", "player_name", "pos", "team"),
      by = c("player_id")
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "round" = "roundId",
        "pick" = "roundPickNumber",
        "overall" = "overallPickNumber",
        "franchise_id",
        "franchise_name",
        "user_nickname",
        "player_id",
        "player_name",
        "pos",
        "team",
        "bid_amount" = "bidAmount",
        "nominating_team_id" = "nominatingTeamId",
        "is_keeper" = "keeper",
        "can_keeper" = "reservedForKeeper",
        "autodraft_type" = "autoDraftTypeId",
        "complete_date" = "completeDate",
        "in_progress" = "inProgress",
        "pick_id" = "id"
      )),
      dplyr::everything()
    ) %>%
    dplyr::arrange(.data$bid_amount, .data$overall)

  return(x)
}
