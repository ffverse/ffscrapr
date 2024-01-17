#' Get a dataframe of franchise data
#'
#' @param conn a conn object created by `ff_connect()`
#'
#' @examples
#' \donttest{
#' try({ # try only shown here because sometimes CRAN checks are weird
#'   yahoo_conn <- ff_connect(platform = "yahoo", league_id = "77275", token = NULL)
#'   ff_franchises(yahoo_conn)
#' }) # end try
#' }
#' @describeIn ff_franchises Yahoo: Returns franchise data.
#' @export
ff_franchises.yahoo_conn <- function(conn) {
  glue::glue("leagues;league_keys={conn$league_key}/teams") %>%
    yahoo_getendpoint(conn) %>%
    getElement("xml_doc") %>%
    .yahoo_process_franchises_response()
}

.yahoo_process_franchises_response <- function(xml_doc) {
  # extract franchise data
  franchise_id <- xml_doc %>%
    xml2::xml_find_all("//team/team_id") %>%
    xml2::xml_integer()
  franchise_name <- xml_doc %>%
    xml2::xml_find_all("//team/name") %>%
    xml2::xml_text()

  # extract manager data
  managers_nodes <- xml_doc %>%
    xml2::xml_find_all("//managers")
  first_user_name <- managers_nodes %>%
    xml2::xml_find_first("./manager/nickname") %>%
    xml2::xml_text()
  first_user_id <- managers_nodes %>%
    xml2::xml_find_first("./manager/guid") %>%
    xml2::xml_text()
  co_owner_ids <- managers_nodes %>%
    purrr::map(.yahoo_get_co_owners)

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

.yahoo_get_co_owners <- function(managers_node) {
  all_user_ids <- managers_node %>%
    xml2::xml_find_all("./manager/guid") %>%
    xml2::xml_text()
  if (length(all_user_ids) > 1) {
    return(as.list(all_user_ids[-1]))
  }
  return(NULL)
}
