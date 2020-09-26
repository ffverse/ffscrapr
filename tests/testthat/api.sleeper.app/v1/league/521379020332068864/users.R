structure(list(
  url = "https://api.sleeper.app/v1/league/521379020332068864/users",
  status_code = 200L, headers = structure(list(
    date = "Thu, 13 Aug 2020 13:30:36 GMT",
    `content-type` = "application/json; charset=utf-8", vary = "Accept-Encoding",
    `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "33bba09d1a776a3536d4b0aba6b1e4db",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "BYPASS",
    `cf-request-id` = "04899cfedb0000ca4b7d941200000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5c22caaafd85ca4b-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Thu, 13 Aug 2020 13:30:36 GMT",
      `content-type` = "application/json; charset=utf-8",
      vary = "Accept-Encoding", `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "33bba09d1a776a3536d4b0aba6b1e4db",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "BYPASS",
      `cf-request-id` = "04899cfedb0000ca4b7d941200000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5c22caaafd85ca4b-YUL"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = "#HttpOnly_.sleeper.app",
    flag = TRUE, path = "/", secure = TRUE, expiration = structure(1599917339, class = c(
      "POSIXct",
      "POSIXt"
    )), name = "__cfduid", value = "REDACTED"
  ), row.names = c(
    NA,
    -1L
  ), class = "data.frame"), content = charToRaw("[{\"user_id\":\"202892038360801280\",\"settings\":null,\"metadata\":{\"user_message_pn\":\"off\",\"transaction_waiver\":\"on\",\"transaction_trade\":\"on\",\"transaction_free_agent\":\"on\",\"transaction_commissioner\":\"on\",\"team_name_update\":\"on\",\"team_name\":\"DLP::thoriyan\",\"player_nickname_update\":\"on\",\"mention_pn\":\"on\",\"mascot_message\":\"on\",\"mascot_item_type_id_leg_9\":\"steel-man\",\"mascot_item_type_id_leg_8\":\"steel-man\",\"mascot_item_type_id_leg_7\":\"steel-man\",\"mascot_item_type_id_leg_6\":\"steel-man\",\"mascot_item_type_id_leg_5\":\"steel-man\",\"mascot_item_type_id_leg_4\":\"steel-man\",\"mascot_item_type_id_leg_3\":\"steel-man\",\"mascot_item_type_id_leg_2\":\"steel-man\",\"mascot_item_type_id_leg_17\":\"steel-man\",\"mascot_item_type_id_leg_16\":\"steel-man\",\"mascot_item_type_id_leg_15\":\"steel-man\",\"mascot_item_type_id_leg_14\":\"steel-man\",\"mascot_item_type_id_leg_13\":\"steel-man\",\"mascot_item_type_id_leg_12\":\"steel-man\",\"mascot_item_type_id_leg_11\":\"steel-man\",\"mascot_item_type_id_leg_10\":\"steel-man\",\"mascot_item_type_id_leg_1\":\"steel-man\",\"allow_pn\":\"off\"},\"league_id\":\"521379020332068864\",\"is_owner\":true,\"is_bot\":false,\"display_name\":\"solarpool\",\"avatar\":\"a71f864896ba28cbfaa4dc5df5b564e0\"},{\"user_id\":\"459230175830208512\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"AKWilson\",\"avatar\":\"8fcf0e0e6a75e96a591d2a4a4a400f41\"},{\"user_id\":\"460930515327774720\",\"settings\":null,\"metadata\":{\"team_name\":\"Team Mage\",\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"Mage\",\"avatar\":\"8078fbb07b843e8fcbb4601e5cb06b2d\"},{\"user_id\":\"464108705281994752\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"silentclock\",\"avatar\":null},{\"user_id\":\"464123755250053120\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"mascot_item_type_id_leg_9\":\"goat\",\"mascot_item_type_id_leg_8\":\"goat\",\"mascot_item_type_id_leg_7\":\"goat\",\"mascot_item_type_id_leg_6\":\"goat\",\"mascot_item_type_id_leg_5\":\"goat\",\"mascot_item_type_id_leg_4\":\"goat\",\"mascot_item_type_id_leg_3\":\"goat\",\"mascot_item_type_id_leg_2\":\"goat\",\"mascot_item_type_id_leg_17\":\"goat\",\"mascot_item_type_id_leg_16\":\"goat\",\"mascot_item_type_id_leg_15\":\"goat\",\"mascot_item_type_id_leg_14\":\"goat\",\"mascot_item_type_id_leg_13\":\"goat\",\"mascot_item_type_id_leg_12\":\"goat\",\"mascot_item_type_id_leg_11\":\"goat\",\"mascot_item_type_id_leg_10\":\"goat\",\"mascot_item_type_id_leg_1\":\"goat\",\"archived\":\"off\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"Rah292\",\"avatar\":\"6f925123e8c7894bf1cddb0e21a9ae71\"},{\"user_id\":\"464498960719933440\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"hyphenated\",\"avatar\":\"7fb450a5b9acf255a2a563067dcd7bbe\"},{\"user_id\":\"464935605336272896\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"MonkeyEpoxy\",\"avatar\":\"b5f980efc36001cb4e056a9e146d0ca0\"},{\"user_id\":\"466527109116850176\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"Azraels_Little_Helper\",\"avatar\":\"e06c36b2119f2b564e9c839b5377bdc8\"},{\"user_id\":\"466857724680859648\",\"settings\":null,\"metadata\":{\"team_name\":\"Waco Kid\",\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"WacoRides2glory\",\"avatar\":null},{\"user_id\":\"467329259925401600\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":false,\"is_bot\":false,\"display_name\":\"Eidolonic\",\"avatar\":null},{\"user_id\":\"507457165422039040\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":null,\"is_bot\":false,\"display_name\":\"yeavoxxtalknah\",\"avatar\":null},{\"user_id\":\"589594433561858048\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"521379020332068864\",\"is_owner\":null,\"is_bot\":false,\"display_name\":\"Conquistador00\",\"avatar\":null}]"),
  date = structure(1597325436, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 4.1e-05,
    connect = 4.6e-05, pretransfer = 0.000152, starttransfer = 0.159689,
    total = 0.15977
  )
), class = "response")
