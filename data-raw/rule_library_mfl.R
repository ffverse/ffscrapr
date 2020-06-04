library(usethis)
library(dplyr)
library(purrr)
library(tidyr)

rule_library_mfl <- ffscrapr::mfl_getendpoint(ffscrapr::mfl_connect(2020),"allRules") %>%
  pluck("content","allRules","rule") %>%
  tibble() %>%
  unnest_wider(1)  %>%
  modify_depth(2,`[[`,1) %>%
  mutate_all(as.character) %>%
  select(
    abbrev = abbreviation,
    short_desc = shortDescription,
    long_desc = detailedDescription,
    is_player = isPlayer,
    is_team = isTeam,
    is_coach = isCoach
  )

use_data(rule_library_mfl,
         internal = TRUE,
         overwrite = TRUE)
