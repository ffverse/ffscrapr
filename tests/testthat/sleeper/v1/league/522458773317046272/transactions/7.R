structure(list(
  url = "https://api.sleeper.app/v1/league/522458773317046272/transactions/7/",
  status_code = 200L, headers = structure(list(
    date = "Sun, 15 Nov 2020 18:45:09 GMT",
    `content-type` = "application/json; charset=utf-8", vary = "Accept-Encoding",
    `cache-control` = "max-age=0, private, must-revalidate",
    `x-request-id` = "c38fc274609ee1361bed5468aab275ea",
    `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
    `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
    `content-encoding` = "gzip", `cf-cache-status` = "MISS",
    `cf-request-id` = "066ed2bdd70000ca571a879000000001",
    `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
    server = "cloudflare", `cf-ray` = "5f2b20a95d0cca57-YUL"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Sun, 15 Nov 2020 18:45:09 GMT",
      `content-type` = "application/json; charset=utf-8",
      vary = "Accept-Encoding", `cache-control` = "max-age=0, private, must-revalidate",
      `x-request-id` = "c38fc274609ee1361bed5468aab275ea",
      `access-control-allow-origin` = "*", `access-control-expose-headers` = "etag",
      `access-control-allow-credentials` = "true", `strict-transport-security` = "max-age=15724800; includeSubDomains",
      `content-encoding` = "gzip", `cf-cache-status` = "MISS",
      `cf-request-id` = "066ed2bdd70000ca571a879000000001",
      `expect-ct` = "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\"",
      server = "cloudflare", `cf-ray` = "5f2b20a95d0cca57-YUL"
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
  ), class = "data.frame"), content = charToRaw("[{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"627038480970645504\",\"status_updated\":1603868714615,\"status\":\"failed\",\"settings\":{\"waiver_bid\":2,\"seq\":3},\"roster_ids\":[7],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":7,\"drops\":{\"6144\":7},\"draft_picks\":[],\"creator\":\"386950378371207168\",\"created\":1603860132976,\"consenter_ids\":[7],\"adds\":{\"3445\":7}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"627038202099744768\",\"status_updated\":1603868714615,\"status\":\"failed\",\"settings\":{\"waiver_bid\":1,\"seq\":5},\"roster_ids\":[7],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":7,\"drops\":{\"6144\":7},\"draft_picks\":[],\"creator\":\"386950378371207168\",\"created\":1603860066488,\"consenter_ids\":[7],\"adds\":{\"4150\":7}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626998930793664512\",\"status_updated\":1603868714615,\"status\":\"complete\",\"settings\":{\"waiver_bid\":0,\"seq\":9},\"roster_ids\":[4],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":7,\"drops\":{\"4323\":4},\"draft_picks\":[],\"creator\":\"202882046337490944\",\"created\":1603850703479,\"consenter_ids\":[4],\"adds\":{\"943\":4}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626998861432442880\",\"status_updated\":1603868714615,\"status\":\"complete\",\"settings\":{\"waiver_bid\":20,\"seq\":0},\"roster_ids\":[4],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":7,\"drops\":null,\"draft_picks\":[],\"creator\":\"202882046337490944\",\"created\":1603850686942,\"consenter_ids\":[4],\"adds\":{\"3445\":4}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626933911850651648\",\"status_updated\":1603868714615,\"status\":\"complete\",\"settings\":{\"waiver_bid\":0,\"seq\":10},\"roster_ids\":[3],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":7,\"drops\":null,\"draft_picks\":[],\"creator\":\"202892038360801280\",\"created\":1603835201755,\"consenter_ids\":[3],\"adds\":{\"491\":3}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626933828082036736\",\"status_updated\":1603868714615,\"status\":\"failed\",\"settings\":{\"waiver_bid\":4,\"seq\":2},\"roster_ids\":[3],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":7,\"drops\":null,\"draft_picks\":[],\"creator\":\"202892038360801280\",\"created\":1603835181783,\"consenter_ids\":[3],\"adds\":{\"3445\":3}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626933784100569088\",\"status_updated\":1603868714615,\"status\":\"complete\",\"settings\":{\"waiver_bid\":4,\"seq\":1},\"roster_ids\":[3],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":7,\"drops\":null,\"draft_picks\":[],\"creator\":\"202892038360801280\",\"created\":1603835171297,\"consenter_ids\":[3],\"adds\":{\"4150\":3}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"626933717864103936\",\"status_updated\":1603835155505,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[3],\"metadata\":null,\"leg\":7,\"drops\":{\"788\":3},\"draft_picks\":[],\"creator\":\"202892038360801280\",\"created\":1603835155505,\"consenter_ids\":[3],\"adds\":null},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626925445664804864\",\"status_updated\":1603868714615,\"status\":\"complete\",\"settings\":{\"waiver_bid\":0,\"seq\":8},\"roster_ids\":[6],\"metadata\":{\"notes\":\"Your waiver claim was processed successfully!\"},\"leg\":7,\"drops\":{\"6039\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1603833183259,\"consenter_ids\":[6],\"adds\":{\"4146\":6}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626925139820367872\",\"status_updated\":1603868714615,\"status\":\"failed\",\"settings\":{\"waiver_bid\":0,\"seq\":7},\"roster_ids\":[6],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":7,\"drops\":{\"4651\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1603833110340,\"consenter_ids\":[6],\"adds\":{\"3445\":6}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626925051232452608\",\"status_updated\":1603868714615,\"status\":\"failed\",\"settings\":{\"waiver_bid\":0,\"seq\":6},\"roster_ids\":[6],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":7,\"drops\":{\"6039\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1603833089219,\"consenter_ids\":[6],\"adds\":{\"3445\":6}},{\"waiver_budget\":[],\"type\":\"waiver\",\"transaction_id\":\"626924813939728384\",\"status_updated\":1603868714615,\"status\":\"failed\",\"settings\":{\"waiver_bid\":2,\"seq\":4},\"roster_ids\":[6],\"metadata\":{\"notes\":\"This player was claimed by another owner.\"},\"leg\":7,\"drops\":{\"6039\":6},\"draft_picks\":[],\"creator\":\"409797051455393792\",\"created\":1603833032644,\"consenter_ids\":[6],\"adds\":{\"4150\":6}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"625896409987637248\",\"status_updated\":1603587842035,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[12],\"metadata\":null,\"leg\":7,\"drops\":{\"4146\":12},\"draft_picks\":[],\"creator\":\"401485903224193024\",\"created\":1603587842035,\"consenter_ids\":[12],\"adds\":null},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"625496318680317952\",\"status_updated\":1603492452834,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[11],\"metadata\":null,\"leg\":7,\"drops\":{\"4381\":11},\"draft_picks\":[],\"creator\":\"386377724614320128\",\"created\":1603492452834,\"consenter_ids\":[11],\"adds\":{\"6989\":11}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"625408460623777792\",\"status_updated\":1603471505841,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[7],\"metadata\":null,\"leg\":7,\"drops\":{\"6519\":7},\"draft_picks\":[],\"creator\":\"386950378371207168\",\"created\":1603471505841,\"consenter_ids\":[7],\"adds\":{\"6144\":7}},{\"waiver_budget\":[],\"type\":\"trade\",\"transaction_id\":\"625016941031075840\",\"status_updated\":1603413443726,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[6,5],\"metadata\":null,\"leg\":7,\"drops\":{\"6290\":6,\"2251\":5},\"draft_picks\":[],\"creator\":\"386383436639973376\",\"created\":1603378160297,\"consenter_ids\":[6,5],\"adds\":{\"6290\":5,\"2251\":6}},{\"waiver_budget\":[],\"type\":\"free_agent\",\"transaction_id\":\"624607488523706368\",\"status_updated\":1603280539211,\"status\":\"complete\",\"settings\":null,\"roster_ids\":[4],\"metadata\":null,\"leg\":7,\"drops\":{\"7227\":4},\"draft_picks\":[],\"creator\":\"202882046337490944\",\"created\":1603280539211,\"consenter_ids\":[4],\"adds\":null}]"),
  date = structure(1605465909, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 4.9e-05,
    connect = 5.2e-05, pretransfer = 0.00018, starttransfer = 0.333542,
    total = 0.333642
  )
), class = "response")
