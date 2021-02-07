structure(list(
  url = "https://api.sleeper.app/v1/players/nfl/trending/add?lookback_hours=48&limit=10",
  status_code = 200L, headers = structure(list(
    date = "Sat, 28 Nov 2020 21:14:53 GMT",
    `content-type` = "application/json; charset=utf-8", vary = "Accept-Encoding",
    `cache-control` = "public, s-maxage=600", `x-request-id` = "b1d8d2d6bde2e557504263d0249ef3b4",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "HIT",
    age = "396", `cf-request-id` = "06b24e825c0000ca4bb53a1000000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5f9719e3cad7ca4b-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Sat, 28 Nov 2020 21:14:53 GMT",
      `content-type` = "application/json; charset=utf-8",
      vary = "Accept-Encoding", `cache-control` = "public, s-maxage=600",
      `x-request-id` = "b1d8d2d6bde2e557504263d0249ef3b4",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "HIT",
      age = "396", `cf-request-id` = "06b24e825c0000ca4bb53a1000000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5f9719e3cad7ca4b-YUL"
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
  ), class = "data.frame"), content = charToRaw("[{\"player_id\":\"4187\",\"count\":270285},{\"player_id\":\"6156\",\"count\":142272},{\"player_id\":\"1169\",\"count\":129162},{\"player_id\":\"5100\",\"count\":84788},{\"player_id\":\"4381\",\"count\":64578},{\"player_id\":\"333\",\"count\":62680},{\"player_id\":\"NYG\",\"count\":57945},{\"player_id\":\"4147\",\"count\":52537},{\"player_id\":\"3976\",\"count\":50102},{\"player_id\":\"943\",\"count\":45866}]"),
  date = structure(1606598093, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 3.9e-05,
    connect = 4.3e-05, pretransfer = 0.00014, starttransfer = 0.017559,
    total = 0.01761
  )
), class = "response")
