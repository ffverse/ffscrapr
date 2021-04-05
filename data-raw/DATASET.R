# Import Stat Mapping CSV
stat_mapping <- read.csv("data-raw/stat_mapping.csv")

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
      stringr::str_detect(.data$event, "idp") ~ list(c("DL","LB","DB")),
      stringr::str_detect(.data$event, "def|allow") ~ list("DEF"),
      .data$event %in% c("qb_hit", "sack", "sack_yd", "safe", "int",
                         "int_ret_yd", "fum_ret_yd", "fg_ret_yd",
                         "tkl", "tkl_loss", "tkl_ast", "tkl_solo", "ff",
                         "blk_kick", "blk_kick_ret_yd") ~ list("DEF"),
      .data$event %in% c("st_td", "st_ff", "st_fum_rec", "st_tkl_solo",
                         "pr_td","pr_yd","kr_td","kr_yd",
                         "fum","fum_lost","fum_rec_td") ~ list(c("QB","RB","WR","TE","DL","LB","DB","K")),
      stringr::str_detect(.data$event, "qb") ~ list("QB"),
      stringr::str_detect(.data$event, "rb") ~ list("RB"),
      stringr::str_detect(.data$event, "wr") ~ list("WR"),
      stringr::str_detect(.data$event, "te") ~ list("TE"),
      TRUE ~ list(c("QB","RB","WR","TE","K")))) %>%
  tidyr::unnest_longer(col = "pos") %>%
  dplyr::select(-"points")

usethis::use_data(sleeper_rule_mapping, stat_mapping, overwrite = TRUE, internal = TRUE)
