structure(list(
  url = "https://api.sleeper.app/v1/league/633501761776197632/users",
  status_code = 200L, headers = structure(list(
    date = "Sat, 28 Nov 2020 21:13:37 GMT",
    `content-type` = "application/json; charset=utf-8", `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "e61b874ad447a0446c91a4c4af875a75",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `cf-cache-status` = "MISS", `cf-request-id` = "06b24d59900000ca4b84173000000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    vary = "Accept-Encoding", server = "cloudflare", `cf-ray` = "5f971808ed3aca4b-YUL",
    `content-encoding` = "gzip"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Sat, 28 Nov 2020 21:13:37 GMT",
      `content-type` = "application/json; charset=utf-8",
      `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "e61b874ad447a0446c91a4c4af875a75",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `cf-cache-status` = "MISS", `cf-request-id` = "06b24d59900000ca4b84173000000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      vary = "Accept-Encoding", server = "cloudflare",
      `cf-ray` = "5f971808ed3aca4b-YUL", `content-encoding` = "gzip"
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
  ), class = "data.frame"), content = charToRaw("[{\"user_id\":\"202892038360801280\",\"settings\":null,\"metadata\":{\"mention_pn\":\"on\",\"allow_pn\":\"on\"},\"league_id\":\"633501761776197632\",\"is_owner\":true,\"is_bot\":false,\"display_name\":\"solarpool\",\"avatar\":\"a71f864896ba28cbfaa4dc5df5b564e0\"}]"),
  date = structure(1606598017, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 4e-05,
    connect = 4.5e-05, pretransfer = 0.000153, starttransfer = 0.326408,
    total = 0.326515
  )
), class = "response")
