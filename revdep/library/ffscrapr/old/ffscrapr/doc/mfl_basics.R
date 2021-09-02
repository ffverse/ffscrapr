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
  library(dplyr)
  library(tidyr)

## ----eval = eval--------------------------------------------------------------
ssb <- mfl_connect(season = 2020, 
                   league_id = 54040, # from the URL of your league
                   rate_limit_number = 3, 
                   rate_limit_seconds = 6)
ssb

## ----eval = eval--------------------------------------------------------------
ssb_summary <- ff_league(ssb)

str(ssb_summary)

## ----eval = eval--------------------------------------------------------------
ssb_rosters <- ff_rosters(ssb)

head(ssb_rosters)

## ----eval = eval--------------------------------------------------------------
player_values <- dp_values("values-players.csv")

# The values are stored by fantasypros ID since that's where the data comes from. 
# To join it to our rosters, we'll need playerID mappings.

player_ids <- dp_playerids() %>% 
  select(mfl_id,fantasypros_id)

player_values <- player_values %>% 
  left_join(player_ids, by = c("fp_id" = "fantasypros_id")) %>% 
  select(mfl_id,ecr_1qb,ecr_pos,value_1qb)

# Drilling down to just 1QB values and IDs, we'll be joining it onto rosters and don't need the extra stuff

ssb_values <- ssb_rosters %>% 
  left_join(player_values, by = c("player_id"="mfl_id")) %>% 
  arrange(franchise_id,desc(value_1qb))

head(ssb_values)

## ----eval = eval--------------------------------------------------------------
value_summary <- ssb_values %>% 
  group_by(franchise_id,franchise_name,pos) %>% 
  summarise(total_value = sum(value_1qb,na.rm = TRUE)) %>%
  ungroup() %>% 
  group_by(franchise_id,franchise_name) %>% 
  mutate(team_value = sum(total_value)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = pos, values_from = total_value) %>% 
  arrange(desc(team_value))

value_summary

## ----eval = eval--------------------------------------------------------------
value_summary_pct <- value_summary %>% 
  mutate_at(c("team_value","QB","RB","WR","TE"),~.x/sum(.x)) %>% 
  mutate_at(c("team_value","QB","RB","WR","TE"),round, 3)

value_summary_pct

## ----eval = eval--------------------------------------------------------------
age_summary <- ssb_values %>% 
  group_by(franchise_id,pos) %>% 
  mutate(position_value = sum(value_1qb,na.rm=TRUE)) %>% 
  ungroup() %>% 
  mutate(weighted_age = age*value_1qb/position_value) %>% 
  group_by(franchise_id,franchise_name,pos) %>% 
  summarise(count = n(),
            age = sum(weighted_age,na.rm = TRUE)) %>% 
  pivot_wider(names_from = pos,
              values_from = c(age,count))

age_summary

## ----include = FALSE----------------------------------------------------------
httptest::stop_mocking()

unlink(c("ffscrapr-tests-1.4.5","f.zip"), recursive = TRUE, force = TRUE)

