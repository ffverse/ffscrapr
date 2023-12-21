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
  xml_doc <- xml2::read_xml(response$response$content)
  xml2::xml_ns_strip(xml_doc)

  # Extract franchise data
  franchise_id <- as.integer(xml2::xml_text(xml2::xml_find_all(xml_doc, "//manager/manager_id")))
  franchise_name <- xml2::xml_text(xml2::xml_find_all(xml_doc, "//team/name"))
  user_name <- xml2::xml_text(xml2::xml_find_all(xml_doc, "//manager/nickname"))
  user_id <- xml2::xml_text(xml2::xml_find_all(xml_doc, "//manager/guid"))
  co_owners <- NA # This is available in Yahoo but I'm bad at R so I can't tell what format it's supposed to be.
  #   <managers>
  #       <manager>
  #        <manager_id>6</manager_id>
  #        <nickname>Elizabeth</nickname>
  #        <guid>H6KB55XUHTYM6A7NGUQSC57Q3Y</guid>
  #        <image_url>https://s.yimg.com/ag/images/default_user_profile_pic_64sq.jpg</image_url>
  #        <felo_score>621</felo_score>
  #        <felo_tier>silver</felo_tier>
  #       </manager>
  #       <manager>
  #        <manager_id>17</manager_id>
  #        <nickname>Chris A</nickname>
  #        <guid>IYYZECV4YYWC3AQYEQPY3VSN6M</guid>
  #        <is_comanager>1</is_comanager>
  #        <is_current_login>1</is_current_login>
  #        <image_url>https://s.yimg.com/ag/images/default_user_profile_pic_64sq.jpg</image_url>
  #        <felo_score>563</felo_score>
  #        <felo_tier>bronze</felo_tier>
  #       </manager>
  #      </managers>

  # Create a data frame
  df <- data.frame(
    franchise_id = franchise_id,
    franchise_name = franchise_name,
    user_name = user_name,
    user_id = user_id,
    co_owners = co_owners
  )
  return(df)
}
