library(fantasyscrapr)
library(tidyverse)
library(DBI)

aws_db <- dbConnect(odbc::odbc(),'dynastyprocess_db')

dp_values <- dbGetQuery(aws_db,"
SELECT PI.mfl_id,PI.name,PI.position, PI.team,PI.age,PI.draft_year, PE.ecr_1qb, PE.ecr_2qb, PE.scrape_date

FROM dp_playerids as PI
LEFT JOIN dp_playerecr as PE
ON PI.fantasypros_id = PE.fp_id
AND PE.scrape_date = (SELECT DISTINCT scrape_date FROM dp_playerecr ORDER BY scrape_date DESC LIMIT 1)

                        ") %>%
  mutate(value = 10500*exp(-0.0235*ecr_2qb))


conn <- mfl_connect(season = 2020, leagueID = 22627)

mfl_endpoint_league <- function(conn_object){

  # if(is.null(conn_object$leagueID) || !is.numeric(as.numeric(conn_object$leagueID)))

  arg_apikey <- ifelse(!is.null(conn_object$APIKEY),glue("&APIKEY={conn_object$APIKEY}"),"")

  request <- httr::GET(glue::glue("https://www03.myfantasyleague.com/{conn_object$season}",
                                  "/export?TYPE=league&L={conn_object$leagueID}{arg_apikey}",
                                  "&JSON=1"),conn_object$user_agent,conn_object$auth_cookie)

  response <- httr::content(request,'text')

  response <- jsonlite::parse_json(response)

  purrr::pluck(response,"league")
}

mfl_endpoint_rosters <- function(conn_object){

  # if(is.null(conn_object$leagueID) || !is.numeric(as.numeric(conn_object$leagueID)))

  arg_apikey <- ifelse(!is.null(conn_object$APIKEY),glue("&APIKEY={conn_object$APIKEY}"),"")

  request <- httr::GET(glue::glue("https://www03.myfantasyleague.com/{conn_object$season}",
                                  "/export?TYPE=rosters&L={conn_object$leagueID}{arg_apikey}",
                                  "&JSON=1"),conn_object$user_agent,conn_object$auth_cookie)

  response <- httr::content(request,'text')

  response <- jsonlite::parse_json(response)

  purrr::pluck(response,"rosters")
}


franchises <- mfl_endpoint_league(conn) %>%
  pluck('franchises','franchise') %>%
  tibble() %>%
  hoist(1,'franchise'='name','franchise_id'='id') %>%
  select(franchise,franchise_id)

rosters <- mfl_endpoint_rosters(conn) %>%
  pluck('franchise') %>%
  tibble() %>%
  unnest_wider(1) %>%
  rename(franchise_id = id) %>%
  unnest_longer(1) %>%
  hoist(1,'mfl_id'='id','salary'='salary','contract_years'='contractYear') %>%
  select(-player) %>%
  left_join(franchises,by = c('franchise_id')) %>%
  left_join(dp_values,by = c('mfl_id'))

offense <- rosters %>%
  filter(position %in% c('QB','RB','WR','TE')) %>%
  select(name,position,team,)
