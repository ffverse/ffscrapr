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
library(dplyr)
library(purrr)
library(glue)

## ----eval = eval--------------------------------------------------------------

type <- "add"

query <- glue::glue('players/nfl/trending/{type}')

query

response_trending <- sleeper_getendpoint(query,lookback_hours = 48, limit = 10)

str(response_trending, max.level = 1)

## ----eval = eval--------------------------------------------------------------

df_trending <- response_trending %>% 
  purrr::pluck("content") %>% 
  dplyr::bind_rows()

head(df_trending)

## ----eval = eval--------------------------------------------------------------

players <- sleeper_players() %>% 
  select(player_id, player_name, pos, team, age)

trending <- df_trending %>% 
  left_join(players, by = "player_id")

trending

## ----include = FALSE, eval = eval---------------------------------------------
httptest::stop_mocking()

unlink(c("ffscrapr-tests-1.4.5","f.zip"), recursive = TRUE, force = TRUE)

