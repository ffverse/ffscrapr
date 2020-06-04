conn_ssb <- ffscrapr::mfl_connect(2020,54040)
conn_48 <- ffscrapr::mfl_connect(2020,22627)
conn_fog <- ffscrapr::mfl_connect(2020,12608)
conn_dlf <- ffscrapr::mfl_connect(2020,37920)

conn <- conn_dlf

purrr::map_dfr(list(conn_ssb,conn_48,conn_fog,conn_dlf),mfl_league_summary)

library(dplyr)
library(tidyr)
library(purrr)



scoring_endpoint <- mfl_getendpoint(conn,"rules") %>%
  purrr::pluck("content","rules","positionRules") %>%
  tibble() %>%
  unnest_wider(1) %>%
  mutate(vec_depth = map_dbl(rule,vec_depth),
         rule = case_when(vec_depth == 3 ~ map_depth(rule,2,`[[`,1),
                          vec_depth == 4 ~ map_depth(rule,-2,`[[`,1)),
         rule = case_when(vec_depth == 4 ~ map(rule,bind_rows),
                          TRUE ~ rule)) %>%
  select(-vec_depth) %>%
  unnest_wider(rule) %>%
  unnest(c(points,event,range)) %>%
  separate_rows(positions,sep = "\\|") %>%
  left_join(rule_library_mfl, by = c('event'='abbrev'))
