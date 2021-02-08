structure(list(
  url = "https://api.sleeper.app/v1/league/521379020332068864/traded_picks/",
  status_code = 200L, headers = structure(list(
    date = "Tue, 13 Oct 2020 01:45:18 GMT",
    `content-type` = "application/json; charset=utf-8", vary = "Accept-Encoding",
    `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "624d6e7f9da1027791295bf46dc7e10c",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "MISS",
    `cf-request-id` = "05c13b2f840000ca6f41ba8200000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5e15615f3b86ca6f-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Tue, 13 Oct 2020 01:45:18 GMT",
      `content-type` = "application/json; charset=utf-8",
      vary = "Accept-Encoding", `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "624d6e7f9da1027791295bf46dc7e10c",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "MISS",
      `cf-request-id` = "05c13b2f840000ca6f41ba8200000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5e15615f3b86ca6f-YUL"
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
  ), class = "data.frame"), content = charToRaw("[{\"season\":\"2020\",\"round\":1,\"roster_id\":1,\"previous_owner_id\":4,\"owner_id\":8},{\"season\":\"2020\",\"round\":2,\"roster_id\":1,\"previous_owner_id\":1,\"owner_id\":4},{\"season\":\"2020\",\"round\":3,\"roster_id\":1,\"previous_owner_id\":1,\"owner_id\":4},{\"season\":\"2020\",\"round\":4,\"roster_id\":1,\"previous_owner_id\":1,\"owner_id\":8},{\"season\":\"2020\",\"round\":1,\"roster_id\":2,\"previous_owner_id\":2,\"owner_id\":11},{\"season\":\"2020\",\"round\":2,\"roster_id\":2,\"previous_owner_id\":2,\"owner_id\":9},{\"season\":\"2020\",\"round\":3,\"roster_id\":2,\"previous_owner_id\":5,\"owner_id\":12},{\"season\":\"2020\",\"round\":4,\"roster_id\":2,\"previous_owner_id\":2,\"owner_id\":11},{\"season\":\"2021\",\"round\":1,\"roster_id\":2,\"previous_owner_id\":2,\"owner_id\":5},{\"season\":\"2021\",\"round\":3,\"roster_id\":2,\"previous_owner_id\":11,\"owner_id\":2},{\"season\":\"2022\",\"round\":1,\"roster_id\":2,\"previous_owner_id\":2,\"owner_id\":5},{\"season\":\"2020\",\"round\":1,\"roster_id\":3,\"previous_owner_id\":3,\"owner_id\":7},{\"season\":\"2020\",\"round\":4,\"roster_id\":4,\"previous_owner_id\":4,\"owner_id\":1},{\"season\":\"2021\",\"round\":2,\"roster_id\":4,\"previous_owner_id\":4,\"owner_id\":1},{\"season\":\"2021\",\"round\":3,\"roster_id\":4,\"previous_owner_id\":4,\"owner_id\":1},{\"season\":\"2021\",\"round\":4,\"roster_id\":4,\"previous_owner_id\":4,\"owner_id\":1},{\"season\":\"2020\",\"round\":1,\"roster_id\":5,\"previous_owner_id\":5,\"owner_id\":7},{\"season\":\"2020\",\"round\":2,\"roster_id\":5,\"previous_owner_id\":5,\"owner_id\":12},{\"season\":\"2020\",\"round\":3,\"roster_id\":5,\"previous_owner_id\":12,\"owner_id\":4},{\"season\":\"2020\",\"round\":4,\"roster_id\":5,\"previous_owner_id\":5,\"owner_id\":2},{\"season\":\"2021\",\"round\":3,\"roster_id\":5,\"previous_owner_id\":5,\"owner_id\":7},{\"season\":\"2020\",\"round\":1,\"roster_id\":6,\"previous_owner_id\":7,\"owner_id\":5},{\"season\":\"2020\",\"round\":1,\"roster_id\":7,\"previous_owner_id\":5,\"owner_id\":2},{\"season\":\"2020\",\"round\":2,\"roster_id\":7,\"previous_owner_id\":7,\"owner_id\":5},{\"season\":\"2020\",\"round\":2,\"roster_id\":8,\"previous_owner_id\":8,\"owner_id\":7},{\"season\":\"2020\",\"round\":3,\"roster_id\":8,\"previous_owner_id\":4,\"owner_id\":12},{\"season\":\"2020\",\"round\":4,\"roster_id\":8,\"previous_owner_id\":4,\"owner_id\":12},{\"season\":\"2021\",\"round\":1,\"roster_id\":8,\"previous_owner_id\":8,\"owner_id\":4},{\"season\":\"2021\",\"round\":2,\"roster_id\":8,\"previous_owner_id\":8,\"owner_id\":4},{\"season\":\"2021\",\"round\":3,\"roster_id\":8,\"previous_owner_id\":8,\"owner_id\":11},{\"season\":\"2021\",\"round\":4,\"roster_id\":8,\"previous_owner_id\":8,\"owner_id\":1},{\"season\":\"2020\",\"round\":3,\"roster_id\":11,\"previous_owner_id\":11,\"owner_id\":2},{\"season\":\"2020\",\"round\":2,\"roster_id\":12,\"previous_owner_id\":12,\"owner_id\":5},{\"season\":\"2020\",\"round\":3,\"roster_id\":12,\"previous_owner_id\":12,\"owner_id\":5},{\"season\":\"2021\",\"round\":2,\"roster_id\":12,\"previous_owner_id\":12,\"owner_id\":5}]"),
  date = structure(1602553518, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 4.2e-05,
    connect = 4.7e-05, pretransfer = 0.000154, starttransfer = 0.331239,
    total = 0.331323
  )
), class = "response")
