#' Get a dataframe of franchise data
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   yahoo_conn <- ff_connect(platform = "yahoo", league_id = "77275", token = NULL)
#'   ff_userleagues(yahoo_conn)
#' }) # end try
#' }
#' @describeIn ff_franchises Yahoo: Returns franchise data.
#' @export
ff_franchises.yahoo_conn <- function(conn) {
  response <- yahoo_getendpoint(conn, glue::glue("leagues;league_keys={get_league_key(conn)}/teams"))
  return(process_yahoo_franchises_response(response$xml_doc))
}

process_yahoo_franchises_response <- function(xml_doc) {
  # extract franchise data
  franchise_id <- xml2::xml_integer(xml2::xml_find_all(xml_doc, "//team/team_id"))
  franchise_name <- xml2::xml_text(xml2::xml_find_all(xml_doc, "//team/name"))

  # extract manager data
  managers_nodes <- xml2::xml_find_all(xml_doc, "//managers")
  first_user_name <- xml2::xml_text(xml2::xml_find_first(managers_nodes, "./manager/nickname"))
  first_user_id <- xml2::xml_text(xml2::xml_find_first(managers_nodes, "./manager/guid"))
  # this still isn't quite right but it's close.  Need to test with 3 co-owners
  co_owner_ids <- purrr::map(managers_nodes, function(x) {
    all_user_ids <- xml2::xml_text(xml2::xml_find_all(x, "./manager/guid"))
    if (length(all_user_ids) > 1) {
      return(as.list(all_user_ids[-1]))
    } else {
      return(NULL)
    }
  })

  # Create a data frame
  df <- tibble::tibble(
    franchise_id = franchise_id,
    franchise_name = franchise_name,
    user_name = first_user_name,
    user_id = first_user_id,
    co_owners = co_owner_ids
  )
  return(df)
}
