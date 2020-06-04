library(ffscrapr)

conn_ssb <- ffscrapr::mfl_connect(2020,54040)
conn_48 <- ffscrapr::mfl_connect(2020,22627)
conn_fog <- ffscrapr::mfl_connect(2020,12608)
conn_dlf <- ffscrapr::mfl_connect(2020,37920)

conn <- conn_dlf

purrr::map_dfr(list(conn_ssb,conn_48,conn_fog,conn_dlf),mfl_league_summary)

