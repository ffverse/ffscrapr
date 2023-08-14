# Template scoring
library(ffscrapr)
library(usethis)
library(tidyverse)

conn_sfb11 <- mfl_connect(2021, 47747)
scoring_sfb11 <- ff_scoring(conn_sfb11)
starterpositions_sfb11 <- ff_starter_positions(conn_sfb11)

conn_ppr <- mfl_connect(2021, 33158)
scoring_ppr <- ff_scoring(conn_ppr) %>%
  filter(!event %in% c("1R", "1C")) %>%
  distinct(pos, event, .keep_all = TRUE) %>%
  mutate(points = case_when(
    event == "CC" ~ 1,
    event == "IN" ~ -2,
    event == "#P" ~ 4,
    TRUE ~ points
  )) %>%
  arrange(event)

scoring_hppr <- scoring_ppr %>%
  mutate(points = case_when(event == "CC" ~ 0.5, TRUE ~ points)) %>%
  arrange(event)

scoring_zeroppr <- scoring_ppr %>%
  filter(event != "CC") %>%
  arrange(event)

starterpositions_1qb <- ff_starter_positions(conn_ppr) %>%
  filter(pos %in% c("QB", "RB", "WR", "TE")) %>%
  mutate(
    min = c(1, 2, 3, 1),
    max = c(1, 4, 5, 3),
    offense_starters = 9,
    defense_starters = 0,
    kdst_starters = 0,
    total_starters = 9
  )


starterpositions_sf <- starterpositions_1qb %>%
  mutate(
    min = c(1, 2, 3, 1),
    max = c(2, 5, 6, 4),
    offense_starters = 10,
    total_starters = 10
  )

starterpositions_idp <- ff_starter_positions(conn_ppr) %>%
  mutate(
    min = c(1, 2, 3, 1, 1, 2, 2, 2, 1),
    max = c(2, 5, 6, 4, 3, 4, 4, 4, 3),
    offense_starters = 10,
    defense_starters = 10,
    kdst_starters = 0,
    total_starters = 20
  )


# Create Sleeper Rule to Position Mapping
conn <- ff_connect(platform = "sleeper", league_id = "653543448376320000", season = 2020)

sleeper_rule_mapping <-
  glue::glue("league/{conn$league_id}") %>%
  sleeper_getendpoint() %>%
  purrr::pluck("content", "scoring_settings") %>%
  tibble::enframe(name = "event", value = "points") %>%
  dplyr::mutate(
    points = as.numeric(.data$points) %>% round(3),
    pos = dplyr::case_when(
      stringr::str_detect(.data$event, "idp") ~ list(c("DL", "LB", "DB")),
      stringr::str_detect(.data$event, "def|allow") ~ list("DEF"),
      .data$event %in% c(
        "qb_hit", "sack", "sack_yd", "safe", "int",
        "int_ret_yd", "fum_ret_yd", "fg_ret_yd",
        "tkl", "tkl_loss", "tkl_ast", "tkl_solo", "ff",
        "blk_kick", "blk_kick_ret_yd"
      ) ~ list("DEF"),
      .data$event %in% c(
        "st_td", "st_ff", "st_fum_rec", "st_tkl_solo",
        "pr_td", "pr_yd", "kr_td", "kr_yd",
        "fum", "fum_lost", "fum_rec_td"
      ) ~ list(c("QB", "RB", "WR", "TE", "DL", "LB", "DB", "K")),
      stringr::str_detect(.data$event, "qb") ~ list("QB"),
      stringr::str_detect(.data$event, "rb") ~ list("RB"),
      stringr::str_detect(.data$event, "wr") ~ list("WR"),
      stringr::str_detect(.data$event, "te") ~ list("TE"),
      TRUE ~ list(c("QB", "RB", "WR", "TE", "K"))
    )
  ) %>%
  tidyr::unnest_longer(col = "pos") %>%
  dplyr::select(-"points")


use_data(
  scoring_sfb11,
  starterpositions_sfb11,
  scoring_ppr,
  scoring_hppr,
  scoring_zeroppr,
  starterpositions_1qb,
  starterpositions_sf,
  starterpositions_idp,
  sleeper_rule_mapping,
  internal = TRUE,
  overwrite = TRUE
)
