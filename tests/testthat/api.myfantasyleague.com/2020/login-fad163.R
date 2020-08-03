structure(list(
  url = "https://api.myfantasyleague.com/2020/login?USERNAME=dp1234&PASSWORD=test1234&XML=1",
  status_code = 200L, headers = structure(list(
    date = "Mon, 08 Jun 2020 04:44:38 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "88", `content-type` = "text/html; charset=utf-8",
    targethost = "www70"
  ), class = c("insensitive", "list")), all_headers = list(list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Mon, 08 Jun 2020 04:44:38 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      vary = "Accept-Encoding", `content-encoding` = "gzip",
      `content-length` = "88", `content-type` = "text/html; charset=utf-8",
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
    1594179016
  ), class = c("POSIXct", "POSIXt")), name = c(
    "MFL_USER_ID",
    "MFL_PW_SEQ"
  ), value = c("REDACTED", "REDACTED")), row.names = c(
    NA,
    -2L
  ), class = "data.frame"), content = charToRaw("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n\n<error>Invalid Password</error>\n"),
  date = structure(1591591478, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 0.036833,
    connect = 0.082515, pretransfer = 0.161196, starttransfer = 3.79894,
    total = 3.799046
  )
), class = "response")
