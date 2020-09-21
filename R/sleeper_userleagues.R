#### SLEEPER MY LEAGUES ####

#' Get User Leagues
#'
#' This function retrieves a tibble of all user leagues
#' (which were created via username/password args)
#'
#' @param conn a connection object created by \code{ff_connect()}
#' @param user_name the username to look up - defaults to user created in conn if available
#' @param ... arguments that may be passed to other methods (for method consistency)
#'
#' @rdname ff_userleagues
#'
#' @export

ff_userleagues.sleeper_conn <- function(conn,user_name = NULL,...){

  if(is.null(user_name)){user_id <- conn$user_id}

  if(!is.null(user_name)){user_id <- .sleeper_userid(user_name)}

  df_leagues <- sleeper_getendpoint("user",user_id,"leagues/nfl",conn$season) %>%
    purrr::pluck("content") %>%
    purrr::map_dfr(`[`,c("name","league_id")) %>%
    dplyr::rename(league_name = .data$name) %>%
    dplyr::mutate(franchise_name = purrr::map_chr(.data$league_id,.sleeper_userteams,user_id),
                  franchise_id = user_id)

  return(df_leagues)
}

#' Get User Teams
#' @noRd

.sleeper_userteams <- function(league_id,user_id){

  df_teams <- sleeper_getendpoint("league",league_id,"users") %>%
    purrr::pluck("content") %>%
    tibble::tibble() %>%
    tidyr::hoist(1,"franchise_id"="user_id","display_name","metadata") %>%
    tidyr::hoist("metadata","franchise_name" = "team_name") %>%
    dplyr::mutate("franchise_name"=dplyr::coalesce(.data$franchise_name,.data$display_name)) %>%
    dplyr::filter(.data$franchise_id == user_id) %>%
    dplyr::pull("franchise_name")

  return(df_teams)
}
