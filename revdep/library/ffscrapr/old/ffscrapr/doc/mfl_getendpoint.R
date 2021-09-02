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

## ----setup, eval = eval-------------------------------------------------------
library(ffscrapr)

## ----eval = eval--------------------------------------------------------------
conn <- mfl_connect(season = 2020)

conn

## ----eval = eval--------------------------------------------------------------
sfb_search <- mfl_getendpoint(conn,endpoint = "leagueSearch", SEARCH = "sfbx conference")

str(sfb_search, max.level = 1)


## ----eval = eval--------------------------------------------------------------
search_results <- sfb_search %>% 
  purrr::pluck("content","leagues","league") %>% 
  tibble::tibble() %>% 
  tidyr::unnest_wider(1)

head(search_results)

## ----eval = eval--------------------------------------------------------------
fog <- mfl_connect(season = 2019, league_id = 12608)

fog_tradebait <- mfl_getendpoint(fog, "tradeBait", INCLUDE_DRAFT_PICKS = 1) %>% 
  purrr::pluck("content","tradeBaits","tradeBait") %>% 
  tibble::tibble() %>% 
  tidyr::unnest_wider(1) %>% 
  tidyr::separate_rows("willGiveUp",sep = ",") %>% 
  dplyr::mutate(timestamp = lubridate::as_datetime(as.numeric(timestamp))) %>% 
  dplyr::left_join(
    ff_franchises(fog) %>% dplyr::select("franchise_id","franchise_name"),
    by = c("franchise_id")
  ) %>% 
  dplyr::left_join(
    mfl_players(fog) %>% dplyr::select("player_id","player_name","pos","age","team"),
    by = c("willGiveUp" = "player_id")
  )

head(fog_tradebait)

## ----include = FALSE----------------------------------------------------------
httptest::stop_mocking()

unlink(c("ffscrapr-tests-1.4.5","f.zip"), recursive = TRUE, force = TRUE)

