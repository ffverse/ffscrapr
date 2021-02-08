structure(list(
  url = "https://api.myfantasyleague.com/2020/login",
  status_code = 200L, headers = structure(list(
    date = "Tue, 11 Aug 2020 13:11:50 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "127", `content-type` = "text/html; charset=utf-8",
    `set-cookie` = "REDACTED", `set-cookie` = "REDACTED",
    targethost = "www70"
  ), class = c("insensitive", "list")), all_headers = list(list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Tue, 11 Aug 2020 13:11:50 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      vary = "Accept-Encoding", `content-encoding` = "gzip",
      `content-length` = "127", `content-type` = "text/html; charset=utf-8",
      `set-cookie` = "REDACTED", `set-cookie` = "REDACTED",
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
  ), class = "data.frame"), content = charToRaw("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n\n<status MFL_USER_ID=\"bh1s2MuUvrXmhFT4fBCBI21QQORzzHT/+w==\">OK</status>\n"),
  date = structure(1597151510, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 0.002105,
    connect = 0.04077, pretransfer = 0.123838, starttransfer = 0,
    total = 0.275531
  )
), class = "response")
