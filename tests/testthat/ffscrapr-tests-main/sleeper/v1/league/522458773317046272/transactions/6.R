structure(list(
  url = "https://api.sleeper.app/v1/league/522458773317046272/transactions/6/",
  status_code = 200L, headers = structure(list(
    date = "Sun, 15 Nov 2020 18:45:08 GMT",
    `content-type` = "application/json; charset=utf-8", vary = "Accept-Encoding",
    `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "10039ff5a72c12ef17b6d9f5881b3685",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "MISS",
    `cf-request-id` = "066ed2bc3c0000ca5769a90000000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5f2b20a6cf63ca57-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Sun, 15 Nov 2020 18:45:08 GMT",
      `content-type` = "application/json; charset=utf-8",
      vary = "Accept-Encoding", `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "10039ff5a72c12ef17b6d9f5881b3685",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "MISS",
      `cf-request-id` = "066ed2bc3c0000ca5769a90000000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5f2b20a6cf63ca57-YUL"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = "#HttpOnly_.sleeper.app",
    flag = TRUE, path = "/", secure = TRUE, expiration = structure(1608057845, class = c(
      "POSIXct",
      "POSIXt"
    )), name = "__cfduid", value = "REDACTED"
  ), row.names = c(
    NA,
    -1L
  ), class = "data.frame"), content = charToRaw("[{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"624395482503929856\",\"status_updated\":1603263895395,\"status\":\"failed\",\"settings\":{\"waiver_bid\":0,\"seq\":7},\"roster_ids\":[6],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":6,\"drops\":{\"6039\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1603229993037,\"consenter_ids\":[6],\"adds\":{\"4435\":6}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"624395461272342528\",\"status_updated\":1603263895395,\"status\":\"failed\",\"settings\":{\"waiver_bid\":0,\"seq\":6},\"roster_ids\":[6],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":6,\"drops\":{\"5209\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1603229987975,\"consenter_ids\":[6],\"adds\":{\"4435\":6}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"624395195441569792\",\"status_updated\":1603263895395,\"status\":\"complete\",\"settings\":{\"waiver_bid\":27,\"seq\":1},\"roster_ids\":[6],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":6,\"drops\":{\"5209\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1603229924596,\"consenter_ids\":[6],\"adds\":{\"4651\":6}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"624348043440881664\",\"status_updated\":1603218682684,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[12],\"metadata\":null,\"leg\":6,\"drops\":{\"6136\":12},\"draft_picks\":[],\"creator\":\"401485903224193024\",\"created\":1603218682684,\"consenter_ids\":[12],\"adds\":null},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"624283145499402240\",\"status_updated\":1603263895395,\"status\":\"complete\",\"settings\":{\"waiver_bid\":0,\"seq\":5},\"roster_ids\":[3],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":6,\"drops\":{\"5374\":3},\"draft_picks\":[],\"creator\":\"202892038360801280\",\"created\":1603203209808,\"consenter_ids\":[3],\"adds\":{\"1029\":3}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"624200748917424128\",\"status_updated\":1603263895395,\"status\":\"complete\",\"settings\":{\"waiver_bid\":0,\"seq\":4},\"roster_ids\":[8],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":6,\"drops\":{\"4218\":8},\"draft_picks\":[],\"creator\":\"386976568364306432\",\"created\":1603183564932,\"consenter_ids\":[8],\"adds\":{\"2146\":8}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"624200702171918336\",\"status_updated\":1603263895395,\"status\":\"failed\",\"settings\":{\"waiver_bid\":0,\"seq\":3},\"roster_ids\":[8],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":6,\"drops\":{\"5886\":8},\"draft_picks\":[],\"creator\":\"386976568364306432\",\"created\":1603183553787,\"consenter_ids\":[8],\"adds\":{\"4435\":8}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"624167641589833728\",\"status_updated\":1603263895395,\"status\":\"complete\",\"settings\":{\"waiver_bid\":62,\"seq\":0},\"roster_ids\":[1],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":6,\"drops\":{\"4150\":1},\"draft_picks\":[],\"creator\":\"70729037081100288\",\"created\":1603175671530,\"consenter_ids\":[1],\"adds\":{\"4435\":1}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"624167263045492736\",\"status_updated\":1603263895395,\"status\":\"failed\",\"settings\":{\"waiver_bid\":5,\"seq\":2},\"roster_ids\":[1],\"metadata\":{\"notes\":\"Unfortunately, your roster will have too many players after this transaction.\"},\"leg\":6,\"drops\":{\"4150\":1},\"draft_picks\":[],\"creator\":\"70729037081100288\",\"created\":1603175581278,\"consenter_ids\":[1],\"adds\":{\"2146\":1}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"623591294870249472\",\"status_updated\":1603038259764,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[4],\"metadata\":null,\"leg\":6,\"drops\":null,\"draft_picks\":[],\"creator\":\"202882046337490944\",\"created\":1603038259764,\"consenter_ids\":[4],\"adds\":{\"4323\":4}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"622654082703798272\",\"status_updated\":1602814810971,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[1],\"metadata\":null,\"leg\":6,\"drops\":{\"5123\":1},\"draft_picks\":[],\"creator\":\"70729037081100288\",\"created\":1602814810971,\"consenter_ids\":[1],\"adds\":null},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"622572999496781824\",\"status_updated\":1602795479228,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[6],\"metadata\":null,\"leg\":6,\"drops\":null,\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1602795479228,\"consenter_ids\":[6],\"adds\":{\"6039\":6}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"622463326928068608\",\"status_updated\":1602769331250,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[3],\"metadata\":null,\"leg\":6,\"drops\":null,\"draft_picks\":[],\"creator\":\"202892038360801280\",\"created\":1602769331250,\"consenter_ids\":[3],\"adds\":{\"3209\":3}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"622462614659768320\",\"status_updated\":1602769161432,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[3],\"metadata\":null,\"leg\":6,\"drops\":{\"695\":3,\"5107\":3},\"draft_picks\":[],\"creator\":\"202892038360801280\",\"created\":1602769161432,\"consenter_ids\":[3],\"adds\":null},{\"waiver_budget\":[],\"type\":\"trade\",\"transaction_id\":\"622448666422108160\",\"status_updated\":1602792170442,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[8,6],\"metadata\":null,\"leg\":6,\"drops\":{\"6059\":6,\"5980\":8,\"1817\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1602765835913,\"consenter_ids\":[8,6],\"adds\":{\"6059\":8,\"5980\":6,\"1817\":8}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"622335397954932736\",\"status_updated\":1602738830606,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[5],\"metadata\":null,\"leg\":6,\"drops\":{\"6146\":5},\"draft_picks\":[],\"creator\":\"386383436639973376\",\"created\":1602738830606,\"consenter_ids\":[5],\"adds\":null},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"622249528933818368\",\"status_updated\":1602718357836,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[6],\"metadata\":null,\"leg\":6,\"drops\":{\"1029\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1602718357836,\"consenter_ids\":[6],\"adds\":null},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"622128307697180672\",\"status_updated\":1602828901280,\"status\":\"complete\",\"settings\":{\"waiver_bid\":0,\"seq\":0},\"roster_ids\":[12],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":6,\"drops\":{\"1500\":12},\"draft_picks\":[],\"creator\":\"401485903224193024\",\"created\":1602689456441,\"consenter_ids\":[12],\"adds\":{\"6139\":12}}]"),
  date = structure(1605465908, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 3.8e-05,
    connect = 4.1e-05, pretransfer = 0.000139, starttransfer = 0.336998,
    total = 0.337102
  )
), class = "response")
