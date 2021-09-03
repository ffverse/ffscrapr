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

## ----setup, message=FALSE, eval = eval----------------------------------------
  library(ffscrapr)
  library(dplyr)
  library(tidyr)

## ----eval = eval--------------------------------------------------------------
sucioboys <- espn_connect(season = 2020, league_id = 899513)

sucioboys

## ----eval = eval--------------------------------------------------------------
sucioboys_summary <- ff_league(sucioboys)

str(sucioboys_summary)

## ----eval = eval--------------------------------------------------------------
sucioboys_rosters <- ff_rosters(sucioboys)

head(sucioboys_rosters) # quick snapshot of rosters

## ----eval = eval--------------------------------------------------------------
player_values <- dp_values("values-players.csv")

# The values are stored by fantasypros ID since that's where the data comes from. 
# To join it to our rosters, we'll need playerID mappings.

player_ids <- dp_playerids() %>% 
  select(espn_id,fantasypros_id) %>% 
  filter(!is.na(espn_id),!is.na(fantasypros_id))

# We'll be joining it onto rosters, so we can trim down the values dataframe
# to just IDs, age, and values

player_values <- player_values %>% 
  left_join(player_ids, by = c("fp_id" = "fantasypros_id")) %>% 
  select(espn_id,age,ecr_2qb,ecr_pos,value_2qb)

# we can join the roster's player_ids on the values' espn_id, with a bit of a type conversion first
sucioboys_values <- sucioboys_rosters %>% 
  mutate(player_id = as.character(player_id)) %>% 
  left_join(player_values, by = c("player_id"="espn_id")) %>% 
  arrange(franchise_id,desc(value_2qb))

head(sucioboys_values)

## ----eval = eval--------------------------------------------------------------
value_summary <- sucioboys_values %>% 
  group_by(franchise_id,franchise_name,pos) %>% 
  summarise(total_value = sum(value_2qb,na.rm = TRUE)) %>%
  ungroup() %>% 
  group_by(franchise_id,franchise_name) %>% 
  mutate(team_value = sum(total_value)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = pos, values_from = total_value) %>% 
  arrange(desc(team_value)) %>% 
  select(franchise_id,franchise_name,team_value,QB,RB,WR,TE)

value_summary

## ----eval = eval--------------------------------------------------------------
value_summary_pct <- value_summary %>% 
  mutate_at(c("team_value","QB","RB","WR","TE"),~.x/sum(.x)) %>% 
  mutate_at(c("team_value","QB","RB","WR","TE"),round, 3)

value_summary_pct

## ----eval = eval--------------------------------------------------------------
age_summary <- sucioboys_values %>% 
  filter(pos %in% c("QB","RB","WR","TE")) %>% 
  group_by(franchise_id,pos) %>% 
  mutate(position_value = sum(value_2qb,na.rm=TRUE)) %>% 
  ungroup() %>% 
  mutate(weighted_age = age*value_2qb/position_value,
         weighted_age = round(weighted_age, 1)) %>% 
  group_by(franchise_id,franchise_name,pos) %>% 
  summarise(count = n(),
            age = sum(weighted_age,na.rm = TRUE)) %>% 
  pivot_wider(names_from = pos,
              values_from = c(age,count))

age_summary

## ----include = FALSE----------------------------------------------------------
httptest::stop_mocking()

unlink(c("ffscrapr-tests-1.4.5","f.zip"), recursive = TRUE, force = TRUE)

