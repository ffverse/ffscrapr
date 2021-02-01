structure(list(
  url = "https://www61.myfantasyleague.com/2020/export?TYPE=rules&L=54040&JSON=1",
  status_code = 200L, headers = structure(list(
    date = "Sat, 28 Nov 2020 21:11:18 GMT",
    server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
    vary = "Accept-Encoding", `content-encoding` = "gzip",
    `content-length` = "274", `content-type` = "application/json; charset=utf-8"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 302L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Sat, 28 Nov 2020 21:11:18 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      location = "https://www61.myfantasyleague.com/2020/export?TYPE=rules&L=54040&JSON=1",
      `content-length` = "0", targethost = "www77"
    ), class = c(
      "insensitive",
      "list"
    ))
  ), list(
    status = 200L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Sat, 28 Nov 2020 21:11:18 GMT",
      server = "Apache/2.4.18 (Unix) mod_apreq2-20090110/2.8.0 mod_perl/2.0.9 Perl/v5.10.1",
      vary = "Accept-Encoding", `content-encoding` = "gzip",
      `content-length` = "274", `content-type` = "application/json; charset=utf-8"
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
  content = charToRaw("{\"version\":\"1.0\",\"rules\":{\"positionRules\":[{\"positions\":\"QB|RB|WR|TE\",\"rule\":[{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"#P\"}},{\"points\":{\"$t\":\"*.04\"},\"range\":{\"$t\":\"-50-999\"},\"event\":{\"$t\":\"PY\"}},{\"points\":{\"$t\":\"*-4\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"IN\"}},{\"points\":{\"$t\":\"*2\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"P2\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"#R\"}},{\"points\":{\"$t\":\"*0.1\"},\"range\":{\"$t\":\"-50-999\"},\"event\":{\"$t\":\"RY\"}},{\"points\":{\"$t\":\"*2\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"R2\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"#C\"}},{\"points\":{\"$t\":\"*0.1\"},\"range\":{\"$t\":\"-50-999\"},\"event\":{\"$t\":\"CY\"}},{\"points\":{\"$t\":\"*0.5\"},\"range\":{\"$t\":\"0-99\"},\"event\":{\"$t\":\"CC\"}},{\"points\":{\"$t\":\"*2\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"C2\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"#UT\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"#KT\"}},{\"points\":{\"$t\":\"*-2\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"FL\"}},{\"points\":{\"$t\":\"*6\"},\"range\":{\"$t\":\"0-10\"},\"event\":{\"$t\":\"#FR\"}},{\"points\":{\"$t\":\"*0.5\"},\"range\":{\"$t\":\"1-50\"},\"event\":{\"$t\":\"1R\"}},{\"points\":{\"$t\":\"*0.5\"},\"range\":{\"$t\":\"1-50\"},\"event\":{\"$t\":\"1C\"}}]},{\"positions\":\"TE\",\"rule\":[{\"points\":{\"$t\":\"*0.25\"},\"range\":{\"$t\":\"0-99\"},\"event\":{\"$t\":\"CC\"}},{\"points\":{\"$t\":\"*0.25\"},\"range\":{\"$t\":\"1-50\"},\"event\":{\"$t\":\"1R\"}},{\"points\":{\"$t\":\"*0.25\"},\"range\":{\"$t\":\"1-50\"},\"event\":{\"$t\":\"1C\"}}]}]},\"encoding\":\"utf-8\"}"),
  date = structure(1606597878, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0.14508, namelookup = 9e-05,
    connect = 9.9e-05, pretransfer = 0.000279, starttransfer = 0.30621,
    total = 0.316008
  )
), class = "response")
