structure(list(
  url = "https://api.myfantasyleague.com/2020/login?USERNAME=dynastyprocesstest&PASSWORD=test1234&XML=1",
  status_code = 200L, headers = structure(list(
    date = "Mon, 08 Jun 2020 03:30:16 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "127", `content-type` = "text/html; charset=utf-8",
    `set-cookie` = "REDACTED", `set-cookie` = "REDACTED",
    targethost = "www70"
  ), class = c("insensitive", "list")), all_headers = list(list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Mon, 08 Jun 2020 03:30:16 GMT",
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
    1594179016
  ), class = c("POSIXct", "POSIXt")), name = c(
    "MFL_USER_ID",
    "MFL_PW_SEQ"
  ), value = c("REDACTED", "REDACTED")), row.names = c(
    NA,
    -2L
  ), class = "data.frame"), content = charToRaw("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n\n<status MFL_USER_ID=\"bh1s2MuUvrXmhFT4fBCBI21QQORzzHT/+w==\">OK</status>\n"),
  date = structure(1591587016, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 0.001522,
    connect = 0.04801, pretransfer = 0.124049, starttransfer = 0.284865,
    total = 0.285116
  )
), class = "response")
