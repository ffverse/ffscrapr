structure(list(
  url = "https://www57.myfantasyleague.com/2020/export?TYPE=rules&L=37920&JSON=1",
  status_code = 200L, headers = structure(list(
    date = "Sun, 14 Jun 2020 01:17:35 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "261", `content-type` = "application/json; charset=utf-8"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 302L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Sun, 14 Jun 2020 01:17:35 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      location = "https://www57.myfantasyleague.com/2020/export?TYPE=rules&L=37920&JSON=1",
      `content-length` = "0", targethost = "www70"
    ), class = c(
      "insensitive",
      "list"
    ))
  ), list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Sun, 14 Jun 2020 01:17:35 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      vary = "Accept-Encoding", `content-encoding` = "gzip",
      `content-length` = "261", `content-type` = "application/json; charset=utf-8"
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
  content = charToRaw("{\"version\":\"1.0\",\"rules\":{\"positionRules\":[{\"positions\":\"TE\",\"rule\":{\"points\":{\"$t\":\"*1.5\"},\"range\":{\"$t\":\"0-99\"},\"event\":{\"$t\":\"CC\"}}},{\"positions\":\"WR\",\"rule\":{\"points\":{\"$t\":\"*0.5\"},\"range\":{\"$t\":\"0-99\"},\"event\":{\"$t\":\"CC\"}}},{\"positions\":\"QB|RB|WR|TE|PK\",\"rule\":[{\"points\":{\"$t\":\"*4\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"#P\"}},{\"points\":{\"$t\":\"*0.04\"},\"range\":{\"$t\":\"1-999\"},\"event\":{\"$t\":\"PY\"}},{\"points\":{\"$t\":\"*-2\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"IN\"}},{\"points\":{\"$t\":\"*1\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"P2\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"#R\"}},{\"points\":{\"$t\":\"*0.1\"},\"range\":{\"$t\":\"1-999\"},\"event\":{\"$t\":\"RY\"}},{\"points\":{\"$t\":\"*2\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"R2\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"#C\"}},{\"points\":{\"$t\":\"*0.1\"},\"range\":{\"$t\":\"1-999\"},\"event\":{\"$t\":\"CY\"}},{\"points\":{\"$t\":\"*2\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"C2\"}},{\"points\":{\"$t\":\"*-1\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"FU\"}},{\"points\":{\"$t\":\"*-1\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"FL\"}},{\"points\":{\"$t\":\"1/1\"},\"range\":{\"$t\":\"1-50\"},\"event\":{\"$t\":\"1R\"}},{\"points\":{\"$t\":\"1/1\"},\"range\":{\"$t\":\"1-50\"},\"event\":{\"$t\":\"1C\"}}]}]},\"encoding\":\"utf-8\"}"),
  date = structure(1592097455, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0.14591, namelookup = 0.000235,
    connect = 0.000242, pretransfer = 0.000603, starttransfer = 0.307067,
    total = 0.30719
  )
), class = "response")
