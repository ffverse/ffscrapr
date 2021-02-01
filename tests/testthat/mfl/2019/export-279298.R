structure(list(
  url = "https://www57.myfantasyleague.com/2019/export?TYPE=rules&L=37920&JSON=1",
  status_code = 200L, headers = structure(list(
    date = "Sat, 14 Nov 2020 17:39:18 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "273", `content-type` = "application/json; charset=utf-8"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 302L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Sat, 14 Nov 2020 17:39:18 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      location = "https://www57.myfantasyleague.com/2019/export?TYPE=rules&L=37920&JSON=1",
      `content-length` = "0", targethost = "www70"
    ), class = c(
      "insensitive",
      "list"
    ))
  ), list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Sat, 14 Nov 2020 17:39:18 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      vary = "Accept-Encoding", `content-encoding` = "gzip",
      `content-length` = "273", `content-type` = "application/json; charset=utf-8"
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
  content = charToRaw("{\"version\":\"1.0\",\"rules\":{\"positionRules\":[{\"positions\":\"TE\",\"rule\":{\"points\":{\"$t\":\"*0.5\"},\"range\":{\"$t\":\"0-99\"},\"event\":{\"$t\":\"CC\"}}},{\"positions\":\"QB|RB|WR|TE|PK\",\"rule\":[{\"points\":{\"$t\":\"*4\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"#P\"}},{\"points\":{\"$t\":\"*0.05\"},\"range\":{\"$t\":\"1-999\"},\"event\":{\"$t\":\"PY\"}},{\"points\":{\"$t\":\"*-1\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"IN\"}},{\"points\":{\"$t\":\"*2\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"P2\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"#R\"}},{\"points\":{\"$t\":\"*0.1\"},\"range\":{\"$t\":\"1-999\"},\"event\":{\"$t\":\"RY\"}},{\"points\":{\"$t\":\"*2\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"R2\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"#C\"}},{\"points\":{\"$t\":\"*0.1\"},\"range\":{\"$t\":\"1-999\"},\"event\":{\"$t\":\"CY\"}},{\"points\":{\"$t\":\"*1\"},\"range\":{\"$t\":\"1-99\"},\"event\":{\"$t\":\"CC\"}},{\"points\":{\"$t\":\"*2\"},\"range\":{\"$t\":\"1-10\"},\"event\":{\"$t\":\"C2\"}},{\"points\":{\"$t\":\"3\"},\"range\":{\"$t\":\"1-30\"},\"event\":{\"$t\":\"FG\"}},{\"points\":{\"$t\":\"*0.1\"},\"range\":{\"$t\":\"31-99\"},\"event\":{\"$t\":\"FG\"}},{\"points\":{\"$t\":\"*1\"},\"range\":{\"$t\":\"1-20\"},\"event\":{\"$t\":\"EP\"}},{\"points\":{\"$t\":\"*-1\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"FU\"}},{\"points\":{\"$t\":\"*-1\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"FL\"}}]}]},\"encoding\":\"utf-8\"}"),
  date = structure(1605375558, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0.277001, namelookup = 0.048621,
    connect = 0.114359, pretransfer = 0.271616, starttransfer = 0.605841,
    total = 0.605992
  )
), class = "response")
