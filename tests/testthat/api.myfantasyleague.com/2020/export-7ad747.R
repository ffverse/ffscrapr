structure(list(
  url = "https://api.myfantasyleague.com/2020/export?TYPE=myleagues&FRANCHISE_NAMES=1&YEAR=2020&JSON=1",
  status_code = 200L, headers = structure(list(
    date = "Tue, 11 Aug 2020 13:11:50 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "162", `content-type` = "application/json; charset=utf-8",
    targethost = "www70"
  ), class = c("insensitive", "list")), all_headers = list(list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Tue, 11 Aug 2020 13:11:50 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      vary = "Accept-Encoding", `content-encoding` = "gzip",
      `content-length` = "162", `content-type` = "application/json; charset=utf-8",
      targethost = "www70"
    ), class = c("insensitive", "list"))
  )), cookies = structure(list(domain = c(
    ".myfantasyleague.com",
    ".myfantasyleague.com"
  ), flag = c(TRUE, TRUE), path = c(
    "/",
    "/"
  ), secure = c(FALSE, FALSE), expiration = structure(c(
    Inf,
    1599743510
  ), class = c("POSIXct", "POSIXt")), name = c(
    "MFL_USER_ID",
    "MFL_PW_SEQ"
  ), value = c("REDACTED", "REDACTED")), row.names = c(
    NA,
    -2L
  ), class = "data.frame"), content = charToRaw("{\"version\":\"1.0\",\"leagues\":{\"league\":{\"franchise_id\":\"0001\",\"url\":\"https://www70.myfantasyleague.com/2020/home/21499\",\"name\":\"testestest\",\"franchise_name\":\"Franchise 1\",\"league_id\":\"21499\"}},\"encoding\":\"utf-8\"}"),
  date = structure(1597151510, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 6.3e-05,
    connect = 6.5e-05, pretransfer = 0.000204, starttransfer = 0.252958,
    total = 0.253068
  )
), class = "response")
