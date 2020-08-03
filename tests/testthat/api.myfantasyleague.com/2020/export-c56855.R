structure(list(
  url = "https://www73.myfantasyleague.com/2020/export?TYPE=futureDraftPicks&L=65443&JSON=1",
  status_code = 200L, headers = structure(list(
    date = "Sun, 02 Aug 2020 15:57:54 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "77", `content-type` = "application/json; charset=utf-8"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 302L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Sun, 02 Aug 2020 15:57:53 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      location = "https://www73.myfantasyleague.com/2020/export?TYPE=futureDraftPicks&L=65443&JSON=1",
      `content-length` = "0", targethost = "www70"
    ), class = c(
      "insensitive",
      "list"
    ))
  ), list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Sun, 02 Aug 2020 15:57:54 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      vary = "Accept-Encoding", `content-encoding` = "gzip",
      `content-length` = "77", `content-type` = "application/json; charset=utf-8"
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
  content = charToRaw("{\"version\":\"1.0\",\"futureDraftPicks\":{},\"encoding\":\"utf-8\"}"),
  date = structure(1596383874, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0.137844, namelookup = 0.000554,
    connect = 0.342746, pretransfer = 0.419334, starttransfer = 0.70869,
    total = 0.709031
  )
), class = "response")
