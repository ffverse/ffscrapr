structure(list(
  url = "https://www54.myfantasyleague.com/2019/export?TYPE=schedule&L=12608&JSON=1",
  status_code = 200L, headers = structure(list(
    date = "Mon, 03 Aug 2020 03:45:44 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "133", `content-type` = "application/json; charset=utf-8"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 302L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Mon, 03 Aug 2020 03:45:44 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      location = "https://www54.myfantasyleague.com/2019/export?TYPE=schedule&L=12608&JSON=1",
      `content-length` = "0", targethost = "www70"
    ), class = c(
      "insensitive",
      "list"
    ))
  ), list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Mon, 03 Aug 2020 03:45:44 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      vary = "Accept-Encoding", `content-encoding` = "gzip",
      `content-length` = "133", `content-type` = "application/json; charset=utf-8"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = logical(0),
    flag = logical(0), path = logical(0), secure = logical(0),
    expiration = structure(numeric(0), class = c(
      "POSIXct",
      "POSIXt"
    )), name = logical(0), value = logical(0)
  ), row.names = integer(0), class = "data.frame"),
  content = charToRaw("{\"version\":\"1.0\",\"schedule\":{\"weeklySchedule\":[{\"week\":\"1\"},{\"week\":\"2\"},{\"week\":\"3\"},{\"week\":\"4\"},{\"week\":\"5\"},{\"week\":\"6\"},{\"week\":\"7\"},{\"week\":\"8\"},{\"week\":\"9\"},{\"week\":\"10\"},{\"week\":\"11\"},{\"week\":\"12\"},{\"week\":\"13\"},{\"week\":\"14\"},{\"week\":\"15\"},{\"week\":\"16\"}]},\"encoding\":\"utf-8\"}"),
  date = structure(1596426344, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0.138619, namelookup = 0.00017,
    connect = 0.040104, pretransfer = 0.111512, starttransfer = 0.422242,
    total = 0.422407
  )
), class = "response")
