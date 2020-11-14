## ff_scoring (MFL) ##

#' Get a dataframe of scoring settings, referencing the "all rules" library endpoint.
#' The all-rules endpoint is saved to a cache, so subsequent function calls should be faster!
#'
#' @param conn a conn object created by \code{ff_connect()}
#'
#' @examples
#' ssb_conn <- ff_connect(platform = "mfl", league_id = 54040, season = 2020)
#' ff_scoring(ssb_conn)
#' @seealso \url{http://www03.myfantasyleague.com/2020/scoring_rules#rules}
#'
#' @describeIn ff_scoring MFL: returns scoring settings in a flat table, one row per position per rule.
#' @export

ff_scoring.mfl_conn <- function(conn) {
  df <- mfl_getendpoint(conn, "rules") %>%
    purrr::pluck("content", "rules", "positionRules")

  if (is.null(df$positions)) {
    df <- df %>%
      tibble::tibble() %>%
      tidyr::unnest_wider(1)
  }

  if (!is.null(df$positions)) {
    df <- df %>% tibble::as_tibble()
  }

  df <- df %>%
    dplyr::mutate(
      vec_depth = purrr::map_dbl(.data$rule, purrr::vec_depth),
      rule = dplyr::case_when(
        .data$vec_depth == 3 ~ purrr::map_depth(.data$rule, 2, `[[`, 1),
        .data$vec_depth == 4 ~ purrr::map_depth(.data$rule, -2, `[[`, 1)
      ),
      rule = dplyr::case_when(
        .data$vec_depth == 4 ~ purrr::map(.data$rule, dplyr::bind_rows),
        TRUE ~ .data$rule
      )
    ) %>%
    dplyr::select(-.data$vec_depth) %>%
    tidyr::unnest_wider("rule") %>%
    tidyr::unnest(c("points", "event", "range")) %>%
    tidyr::separate_rows("positions", sep = "\\|") %>%
    dplyr::left_join(mfl_allrules(), by = c("event" = "abbrev")) %>%
    dplyr::mutate_at(c("is_player", "is_team", "is_coach"), ~ as.logical(as.numeric(.x))) %>%
    dplyr::mutate(
      points = purrr::map_if(.data$points, grepl("\\/", .data$points), .fn_parsedivide),
      points = purrr::map_if(.data$points, grepl("\\*", .data$points), .fn_parsemultiply),
      points = as.double(.data$points)
    ) %>%
    dplyr::select("pos" = .data$positions, .data$points, .data$range, .data$event, .data$short_desc, .data$long_desc)
}

#' Parse the scoring rule chars into numeric.
#'
#' This may not be "precisely" what MFL does, but I'd rather give workable and consistent datatypes.
#'
#' ie MFL sometimes uses the "divide" notation for a threshold/bins type thing.
#' @noRd
#' @keywords internal
.fn_parsemultiply <- function(points) {
  as.numeric(gsub("\\*", "", points))
}

#' @noRd
#' @keywords internal
.fn_parsedivide <- function(points) {
  x <- strsplit(points, "/") %>%
    unlist() %>%
    as.numeric()

  return(x[[1]] / x[[2]])
}

#' MFL rules library - memoised via zzz.R
#' @noRd
#' @keywords internal
mfl_allrules <- function() {
  df <- mfl_connect(.fn_choose_season()) %>%
    mfl_getendpoint("allRules") %>%
    purrr::pluck("content", "allRules", "rule") %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(1) %>%
    purrr::map_depth(-2, unname, 1, .ragged = TRUE) %>%
    purrr::map_depth(2, `[[`, 1) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate_all(as.character) %>%
    dplyr::select(
      abbrev = abbreviation,
      short_desc = shortDescription,
      long_desc = detailedDescription,
      is_player = isPlayer,
      is_team = isTeam,
      is_coach = isCoach
    )
}
