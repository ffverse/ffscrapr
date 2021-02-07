structure(list(
  url = "https://api.sleeper.app/v1/user/solarpool",
  status_code = 200L, headers = structure(list(
    date = "Sat, 28 Nov 2020 21:13:36 GMT",
    `content-type` = "application/json; charset=utf-8", `set-cookie` = "REDACTED",
    vary = "Accept-Encoding", `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "ef85e3aeeca7642f71acc220e7f030e9",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "MISS",
    `cf-request-id` = "06b24d56950000ca4bb406e000000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5f9718042b0fca4b-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Sat, 28 Nov 2020 21:13:36 GMT",
      `content-type` = "application/json; charset=utf-8",
      `set-cookie` = "REDACTED", vary = "Accept-Encoding",
      `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "ef85e3aeeca7642f71acc220e7f030e9",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "MISS",
      `cf-request-id` = "06b24d56950000ca4bb406e000000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5f9718042b0fca4b-YUL"
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
  ), class = "data.frame"), content = charToRaw("{\"verification\":null,\"username\":\"solarpool\",\"user_id\":\"202892038360801280\",\"token\":null,\"solicitable\":null,\"real_name\":null,\"phone\":null,\"pending\":null,\"notifications\":null,\"is_bot\":false,\"email\":null,\"display_name\":\"solarpool\",\"deleted\":null,\"data_updated\":null,\"currencies\":null,\"created\":null,\"cookies\":null,\"avatar\":\"a71f864896ba28cbfaa4dc5df5b564e0\"}"),
  date = structure(1606598016, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 0.043787,
    connect = 0.044972, pretransfer = 0.05321, starttransfer = 0.38583,
    total = 0.386008
  )
), class = "response")
