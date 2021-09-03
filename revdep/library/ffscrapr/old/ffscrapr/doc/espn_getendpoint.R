## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(dplyr.summarise.inform = FALSE,
        rmarkdown.html_vignette.check_title = FALSE)

eval <- TRUE

tryCatch(expr = {
  
  download.file("https://github.com/ffverse/ffscrapr-tests/archive/1.4.5.zip","f.zip")
  unzip('f.zip', exdir = ".")
  
  httptest::.mockPaths(new = "ffscrapr-tests-1.4.5")},
  warning = function(e) eval <<- FALSE,
  error = function(e) eval <<- FALSE)

httptest::use_mock_api()

## ----setup, message = FALSE, eval = eval--------------------------------------
library(ffscrapr)
library(httr)
library(jsonlite)
library(glue)

## ----message = FALSE, eval = eval---------------------------------------------
conn <- espn_connect(season = 2020, league_id = 899513)

draft_details <- espn_getendpoint(conn, view = "mDraftDetail")

draft_details

## ----message = FALSE, eval = eval---------------------------------------------
draft_details_raw <- espn_getendpoint_raw(
  conn,
  "https://fantasy.espn.com/apis/v3/games/ffl/seasons/2020/segments/0/leagues/899513?view=mDraftDetail")

draft_details_raw

## ----xfantasyfilter, message = FALSE, eval = eval-----------------------------

xff <- list(players = list(
  limit = 5,
  sortPercOwned = 
    list(sortAsc = FALSE,
         sortPriority = 1),
  filterStatsForTopScoringPeriodIDs = 
    list(value = 2,
         additionalValue = c(paste0("00", conn$season)))
  )) %>%
  jsonlite::toJSON(auto_unbox = TRUE)

xff

## ----message = FALSE, eval = eval---------------------------------------------
player_scores <- espn_getendpoint(conn, view = "kona_player_info", x_fantasy_filter = xff)

player_scores_2 <- espn_getendpoint_raw(
  conn,
  "https://fantasy.espn.com/apis/v3/games/ffl/seasons/2020/segments/0/leagues/899513?view=kona_player_info",
  httr::add_headers(`X-Fantasy-Filter` = xff))


## ----include = FALSE----------------------------------------------------------
httptest::stop_mocking()

unlink(c("ffscrapr-tests-1.4.5","f.zip"), recursive = TRUE, force = TRUE)

