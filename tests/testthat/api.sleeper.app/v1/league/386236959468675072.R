structure(list(
  url = "https://api.sleeper.app/v1/league/386236959468675072",
  status_code = 200L, headers = structure(list(
    date = "Sat, 28 Nov 2020 21:13:44 GMT",
    `content-type` = "application/json; charset=utf-8", vary = "Accept-Encoding",
    `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "7cb540283f2a228e59c672723fb449bc",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "MISS",
    `cf-request-id` = "06b24d72870000ca4b93001000000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5f971830d87bca4b-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Sat, 28 Nov 2020 21:13:44 GMT",
      `content-type` = "application/json; charset=utf-8",
      vary = "Accept-Encoding", `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "7cb540283f2a228e59c672723fb449bc",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "MISS",
      `cf-request-id` = "06b24d72870000ca4b93001000000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5f971830d87bca4b-YUL"
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
  ), class = "data.frame"), content = charToRaw("{\"total_rosters\":12,\"status\":\"complete\",\"sport\":\"nfl\",\"shard\":581,\"settings\":{\"max_keepers\":1,\"draft_rounds\":4,\"trade_review_days\":2,\"reserve_allow_dnr\":0,\"capacity_override\":0,\"pick_trading\":1,\"taxi_years\":1,\"taxi_allow_vets\":0,\"last_report\":13,\"disable_adds\":0,\"waiver_type\":2,\"bench_lock\":1,\"reserve_allow_sus\":1,\"type\":2,\"waiver_clear_days\":1,\"daily_waivers_last_ran\":1,\"waiver_day_of_week\":2,\"start_week\":1,\"playoff_teams\":6,\"num_teams\":12,\"reserve_slots\":3,\"playoff_round_type\":0,\"daily_waivers_hour\":0,\"waiver_budget\":200,\"reserve_allow_out\":1,\"offseason_adds\":0,\"last_scored_leg\":16,\"daily_waivers\":0,\"playoff_week_start\":14,\"daily_waivers_days\":1093,\"league_average_match\":0,\"leg\":16,\"trade_deadline\":13,\"reserve_allow_doubtful\":0,\"taxi_deadline\":0,\"reserve_allow_na\":0,\"taxi_slots\":3,\"playoff_type\":1},\"season_type\":\"regular\",\"season\":\"2019\",\"scoring_settings\":{\"pass_2pt\":2.0,\"pass_int\":-2.0,\"fgmiss\":0.0,\"rec_yd\":0.10000000149011612,\"xpmiss\":0.0,\"def_pr_td\":0.0,\"fgm_30_39\":0.0,\"blk_kick\":2.0,\"pts_allow_7_13\":0.0,\"ff\":1.0,\"fgm_20_29\":0.0,\"fgm_40_49\":0.0,\"pts_allow_1_6\":0.0,\"st_fum_rec\":1.0,\"def_st_ff\":1.0,\"st_ff\":1.0,\"pts_allow_28_34\":0.0,\"fgm_50p\":0.0,\"fum_rec\":2.0,\"def_td\":6.0,\"fgm_0_19\":0.0,\"int\":2.0,\"pts_allow_0\":0.0,\"pts_allow_21_27\":0.0,\"rec_2pt\":2.0,\"rec\":0.5,\"xpm\":0.0,\"st_td\":6.0,\"def_st_fum_rec\":1.0,\"def_st_td\":6.0,\"sack\":1.0,\"idp_tkl_solo\":0.0,\"rush_2pt\":2.0,\"rec_td\":6.0,\"pts_allow_35p\":0.0,\"pts_allow_14_20\":0.0,\"rush_yd\":0.10000000149011612,\"pass_yd\":0.03999999910593033,\"pass_td\":4.0,\"rush_td\":6.0,\"def_kr_td\":0.0,\"fum_lost\":-2.0,\"fum\":0.0,\"safe\":2.0},\"roster_positions\":[\"QB\",\"RB\",\"RB\",\"WR\",\"WR\",\"TE\",\"FLEX\",\"FLEX\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\",\"BN\"],\"previous_league_id\":\"0\",\"name\":\"The JanMichaelLarkin Dynasty League\",\"metadata\":{\"trophy_loser_banner_text\":\"THE MELLY\",\"trophy_loser_background\":\"poop\",\"trophy_loser\":\"loser1\"},\"loser_bracket_id\":513526691414429696,\"league_id\":\"386236959468675072\",\"last_read_id\":null,\"last_pinned_message_id\":null,\"last_message_time\":1578111120190,\"last_message_text_map\":{},\"last_message_text\":\"When Ryan comes back\",\"last_message_id\":\"519039293647638528\",\"last_message_attachment\":null,\"last_author_is_bot\":false,\"last_author_id\":\"386976568364306432\",\"last_author_display_name\":\"TwoFrames\",\"last_author_avatar\":\"712105a5bab80482980a3f55d87fc612\",\"group_id\":null,\"draft_id\":\"386351625650020352\",\"company_id\":null,\"bracket_id\":513526691410235392,\"avatar\":\"6405a606ed8554f6728a38bd48b9a64d\"}"),
  date = structure(1606598024, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 4.7e-05,
    connect = 5.4e-05, pretransfer = 0.000159, starttransfer = 0.327992,
    total = 0.328079
  )
), class = "response")
