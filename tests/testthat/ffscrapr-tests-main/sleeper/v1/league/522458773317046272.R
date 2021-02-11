structure(list(
  url = "https://api.sleeper.app/v1/league/522458773317046272",
  status_code = 200L, headers = structure(list(
    date = "Sat, 28 Nov 2020 21:13:43 GMT",
    `content-type` = "application/json; charset=utf-8", vary = "Accept-Encoding",
    `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "47a0076afef16ba5f1e348201c98b628",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "MISS",
    `cf-request-id` = "06b24d6f7b0000ca4bc41e1000000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5f97182bfc93ca4b-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Sat, 28 Nov 2020 21:13:43 GMT",
      `content-type` = "application/json; charset=utf-8",
      vary = "Accept-Encoding", `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "47a0076afef16ba5f1e348201c98b628",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "MISS",
      `cf-request-id` = "06b24d6f7b0000ca4bc41e1000000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5f97182bfc93ca4b-YUL"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = "#HttpOnly_.sleeper.app",
    flag = TRUE, path = "/", secure = TRUE, expiration = structure(1609190016, class = c(
      "POSIXct",
      "POSIXt"
    )), name = "__cfduid", value = "REDACTED"
  ), row.names = c(
    NA,
    -1L
  ), class = "data.frame"), content = charToRaw("{\"total_rosters\":12,\"status\":\"in_season\",\"sport\":\"nfl\",\"shard\":62,\"settings\":{\"max_keepers\":1,\"draft_rounds\":4,\"trade_review_days\":2,\"reserve_allow_dnr\":1,\"capacity_override\":0,\"pick_trading\":1,\"taxi_years\":1,\"taxi_allow_vets\":0,\"last_report\":11,\"disable_adds\":0,\"waiver_type\":2,\"bench_lock\":1,\"reserve_allow_sus\":1,\"type\":2,\"reserve_allow_cov\":1,\"waiver_clear_days\":1,\"daily_waivers_last_ran\":27,\"waiver_day_of_week\":2,\"start_week\":1,\"playoff_teams\":6,\"num_teams\":12,\"reserve_slots\":6,\"playoff_round_type\":0,\"daily_waivers_hour\":1,\"waiver_budget\":200,\"reserve_allow_out\":1,\"offseason_adds\":1,\"last_scored_leg\":11,\"playoff_seed_type\":0,\"daily_waivers\":0,\"playoff_week_start\":14,\"daily_waivers_days\":2075,\"league_average_match\":0,\"leg\":12,\"trade_deadline\":13,\"reserve_allow_doubtful\":0,\"taxi_deadline\":0,\"reserve_allow_na\":0,\"taxi_slots\":3,\"playoff_type\":1},\"season_type\":\"regular\",\"season\":\"2020\",\"scoring_settings\":{\"pass_2pt\":2.0,\"pass_int\":-2.0,\"fgmiss\":0.0,\"rec_yd\":0.10000000149011612,\"xpmiss\":0.0,\"def_pr_td\":0.0,\"fgm_30_39\":0.0,\"blk_kick\":2.0,\"pts_allow_7_13\":0.0,\"ff\":1.0,\"fgm_20_29\":0.0,\"fgm_40_49\":0.0,\"pts_allow_1_6\":0.0,\"st_fum_rec\":1.0,\"def_st_ff\":1.0,\"st_ff\":1.0,\"pts_allow_28_34\":0.0,\"fgm_50p\":0.0,\"fum_rec\":2.0,\"def_td\":6.0,\"fgm_0_19\":0.0,\"int\":2.0,\"pts_allow_0\":0.0,\"pts_allow_21_27\":0.0,\"rec_2pt\":2.0,\"rec\":0.5,\"xpm\":0.0,\"st_td\":6.0,\"def_st_fum_rec\":1.0,\"def_st_td\":6.0,\"sack\":1.0,\"fum_rec_td\":6.0,\"idp_tkl_solo\":0.0,\"rush_2pt\":2.0,\"rec_td\":6.0,\"pts_allow_35p\":0.0,\"pts_allow_14_20\":0.0,\"rush_yd\":0.10000000149011612,\"pass_yd\":0.03999999910593033,\"pass_td\":4.0,\"rush_td\":6.0,\"def_kr_td\":0.0,\"fum_lost\":-2.0,\"fum\":0.0,\"safe\":2.0},\"roster_positions\":[\"QB\",\"RB\",\"RB\",\"WR\",\"WR\",\"TE\",\"FLEX\",\"FLEX\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\"],\"previous_league_id\":\"386236959468675072\",\"name\":\"The JanMichaelLarkin Dynasty League\",\"metadata\":null,\"loser_bracket_id\":null,\"league_id\":\"522458773317046272\",\"last_read_id\":null,\"last_pinned_message_id\":null,\"last_message_time\":1606592976839,\"last_message_text_map\":{},\"last_message_text\":\"Jcurtis44 put a player on the trade block.\",\"last_message_id\":\"638500858916569088\",\"last_message_attachment\":{\"type\":\"trade_block_player\",\"data\":{\"roster\":{\"taxi\":[\"6826\",\"7082\"],\"starters\":[\"4017\",\"4199\",\"4098\",\"1426\",\"4037\",\"5022\",\"2197\",\"2319\"],\"settings\":{\"wins\":7,\"waiver_position\":9,\"waiver_budget_used\":111,\"total_moves\":0,\"ties\":0,\"ppts_decimal\":40,\"ppts\":1338,\"losses\":4,\"fpts_decimal\":30,\"fpts_against_decimal\":14,\"fpts_against\":1093,\"fpts\":1052},\"roster_id\":1,\"reserve\":[\"2025\",\"289\",\"344\",\"3503\",\"4866\"],\"players\":[\"1110\",\"1339\",\"1426\",\"1825\",\"2025\",\"2197\",\"2319\",\"232\",\"2822\",\"289\",\"344\",\"3503\",\"4017\",\"4036\",\"4037\",\"4089\",\"4098\",\"4137\",\"4144\",\"4149\",\"4171\",\"4199\",\"421\",\"4866\",\"5022\",\"5068\",\"5965\",\"6001\",\"6068\",\"6149\",\"6826\",\"7082\"],\"metadata\":{\"record\":\"LWWWWLLWLWW\",\"p_nick_956\":\"2019 Chiefs Starting RB\",\"p_nick_574\":\"\",\"p_nick_5068\":\"\",\"p_nick_5007\":\"\",\"p_nick_4993\":\"\",\"p_nick_4866\":\"\",\"p_nick_4863\":\"\",\"p_nick_4454\":\"\",\"p_nick_4273\":\"Bell Cow\",\"p_nick_4197\":\"\",\"p_nick_4171\":\"\",\"p_nick_4149\":\"\",\"p_nick_4144\":\"\",\"p_nick_4089\":\"\",\"p_nick_4068\":\"High Point Monster\",\"p_nick_4037\":\"\",\"p_nick_3976\":\"Biscuit\",\"p_nick_3969\":\"Fat, Lazy and Disrespectful\",\"p_nick_3208\":\"\",\"p_nick_1825\":\"\",\"p_nick_1706\":\"\",\"p_nick_1426\":\"\",\"p_nick_1339\":\"\",\"p_nick_1110\":\"\",\"allow_pn_scoring\":\"off\",\"allow_pn_news\":\"on\"},\"keepers\":null,\"co_owners\":null,\"bucket\":0},\"player\":{\"team\":\"NYG\",\"sport\":\"nfl\",\"position\":\"WR\",\"player_id\":\"6149\",\"number\":86,\"metadata\":null,\"last_name\":\"Slayton\",\"injury_status\":null,\"hashtag\":null,\"first_name\":\"Darius\",\"fantasy_positions\":[\"WR\"],\"depth_chart_position\":\"LWR\",\"depth_chart_order\":1},\"owner\":{\"settings\":null,\"metadata\":{\"team_name\":\"Fake News\",\"mention_pn\":\"on\",\"mascot_message_emotion_leg_9\":\"dancing\",\"mascot_message_emotion_leg_3\":\"victory\",\"mascot_item_type_id_leg_9\":\"metal-slug\",\"mascot_item_type_id_leg_8\":\"smoothie\",\"mascot_item_type_id_leg_7\":\"smoothie\",\"mascot_item_type_id_leg_6\":\"smoothie\",\"mascot_item_type_id_leg_5\":\"smoothie\",\"mascot_item_type_id_leg_4\":\"smoothie\",\"mascot_item_type_id_leg_3\":\"smoothie\",\"mascot_item_type_id_leg_2\":\"metal-slug\",\"mascot_item_type_id_leg_17\":\"metal-slug\",\"mascot_item_type_id_leg_16\":\"metal-slug\",\"mascot_item_type_id_leg_15\":\"metal-slug\",\"mascot_item_type_id_leg_14\":\"metal-slug\",\"mascot_item_type_id_leg_13\":\"metal-slug\",\"mascot_item_type_id_leg_12\":\"metal-slug\",\"mascot_item_type_id_leg_11\":\"metal-slug\",\"mascot_item_type_id_leg_10\":\"metal-slug\",\"mascot_item_type_id_leg_1\":\"metal-slug\",\"avatar\":\"https://sleepercdn.com/uploads/227fe45a080c97ba3ee59ebd1dca80af.jpg\",\"allow_pn\":\"on\"},\"is_owner\":false,\"is_bot\":null,\"display_name\":\"Jcurtis44\",\"avatar\":\"694db09fd474fe0ab8d767b31dd093c2\"}}},\"last_author_is_bot\":true,\"last_author_id\":\"166666666666666666\",\"last_author_display_name\":\"sys\",\"last_author_avatar\":null,\"group_id\":null,\"draft_id\":\"522458773321240576\",\"company_id\":null,\"bracket_id\":null,\"avatar\":\"6405a606ed8554f6728a38bd48b9a64d\"}"),
  date = structure(1606598023, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 5.1e-05,
    connect = 5.7e-05, pretransfer = 0.000162, starttransfer = 0.321119,
    total = 0.321246
  )
), class = "response")
