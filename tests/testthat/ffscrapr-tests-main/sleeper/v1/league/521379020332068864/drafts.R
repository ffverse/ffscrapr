structure(list(
  url = "https://api.sleeper.app/v1/league/521379020332068864/drafts/",
  status_code = 200L, headers = structure(list(
    date = "Tue, 13 Oct 2020 01:45:16 GMT",
    `content-type` = "application/json; charset=utf-8", vary = "Accept-Encoding",
    `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "f8c1a682319e83431319b4b11ad297de",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "MISS",
    `cf-request-id` = "05c13b298e0000ca6f41b58200000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5e156155b9b7ca6f-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Tue, 13 Oct 2020 01:45:16 GMT",
      `content-type` = "application/json; charset=utf-8",
      vary = "Accept-Encoding", `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "f8c1a682319e83431319b4b11ad297de",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "MISS",
      `cf-request-id` = "05c13b298e0000ca6f41b58200000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5e156155b9b7ca6f-YUL"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = "#HttpOnly_.sleeper.app",
    flag = TRUE, path = "/", secure = TRUE, expiration = structure(1605145349, class = c(
      "POSIXct",
      "POSIXt"
    )), name = "__cfduid", value = "REDACTED"
  ), row.names = c(
    NA,
    -1L
  ), class = "data.frame"), content = charToRaw("[{\"type\":\"linear\",\"status\":\"complete\",\"start_time\":1594826628202,\"sport\":\"nfl\",\"settings\":{\"teams\":12,\"slots_wr\":3,\"slots_te\":1,\"slots_rb\":2,\"slots_qb\":1,\"slots_flex\":2,\"slots_bn\":26,\"rounds\":4,\"reversal_round\":0,\"player_type\":1,\"pick_timer\":86400,\"cpu_autopick\":1,\"alpha_sort\":0},\"season_type\":\"regular\",\"season\":\"2020\",\"metadata\":{\"slot_name_5\":\"azrael lh\",\"slot_name_2\":\"eido\",\"slot_name_11\":\"waco\",\"scoring_type\":\"dynasty\",\"name\":\"DLP Dynasty League\",\"description\":\"\"},\"league_id\":\"521379020332068864\",\"last_picked\":1596070856685,\"last_message_time\":1596070857319,\"last_message_id\":\"594367890925301760\",\"draft_order\":{\"589594433561858048\":4,\"507457165422039040\":1,\"467329259925401600\":10,\"466857724680859648\":5,\"466527109116850176\":11,\"464935605336272896\":3,\"464498960719933440\":7,\"464123755250053120\":12,\"464108705281994752\":9,\"460930515327774720\":6,\"459230175830208512\":2,\"202892038360801280\":8},\"draft_id\":\"521379020332068865\",\"creators\":[\"202892038360801280\"],\"created\":1578668954501}]"),
  date = structure(1602553516, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 5.2e-05,
    connect = 5.8e-05, pretransfer = 0.000166, starttransfer = 0.321892,
    total = 0.321972
  )
), class = "response")
