structure(list(
  url = "https://www.fleaflicker.com/api/FetchTrades?sport=NFL&filter=TRADES_COMPLETED&league_id=206154&result_offset=80",
  status_code = 200L, headers = structure(list(
    date = "Tue, 24 Nov 2020 01:19:58 GMT",
    `content-type` = "application/json;charset=utf-8", vary = "accept-encoding",
    `content-encoding` = "gzip"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 200L, version = "HTTP/2",
    headers = structure(list(
      date = "Tue, 24 Nov 2020 01:19:58 GMT",
      `content-type` = "application/json;charset=utf-8",
      vary = "accept-encoding", `content-encoding` = "gzip"
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
  content = charToRaw("{\"trades\":[{\"id\":3998972,\"teams\":[{\"team\":{\"id\":1373988,\"name\":\"Springfield Isotopes\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1373988_0_150x150.jpg\",\"initials\":\"SI\"},\"picksObtained\":[{\"slot\":{\"round\":2},\"season\":2018},{\"slot\":{\"round\":5},\"season\":2018}]},{\"team\":{\"id\":1374271,\"name\":\"Clutch City Ballers\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1374271_0_150x150.jpg\",\"initials\":\"CC\"},\"picksObtained\":[{\"slot\":{\"round\":2},\"season\":2018},{\"slot\":{\"round\":9},\"season\":2018}]}],\"description\":\"2 Picks for 2 Picks\",\"status\":\"TRADE_STATUS_EXECUTED\",\"proposedOn\":\"1525574466000\",\"approvedOn\":\"1525574764000\",\"numVetoesRequired\":7,\"chatChannel\":\"/chats/NFL/leagues/206154/trades-3998972\"},{\"id\":3998541,\"teams\":[{\"team\":{\"id\":1373480,\"name\":\"Goldenrod City Nightmares\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1373480_0_150x150.jpg\",\"initials\":\"GC\"},\"picksObtained\":[{\"slot\":{\"round\":1},\"season\":2018}]},{\"team\":{\"id\":1373501,\"name\":\"Midgard Gallows\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1373501_0_150x150.jpg\",\"initials\":\"MG\"},\"picksObtained\":[{\"slot\":{\"round\":2},\"season\":2018},{\"slot\":{\"round\":5},\"season\":2018},{\"slot\":{\"round\":1},\"season\":2019}]}],\"description\":\"1 Pick for 3 Picks\",\"status\":\"TRADE_STATUS_EXECUTED\",\"proposedOn\":\"1525555677000\",\"approvedOn\":\"1525556366000\",\"numVetoesRequired\":7,\"chatChannel\":\"/chats/NFL/leagues/206154/trades-3998541\"},{\"id\":3997043,\"teams\":[{\"team\":{\"id\":1373501,\"name\":\"Midgard Gallows\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1373501_0_150x150.jpg\",\"initials\":\"MG\"},\"picksObtained\":[{\"slot\":{\"round\":1},\"season\":2018}]},{\"team\":{\"id\":1373883,\"name\":\"Manitoba Marmots\",\"initials\":\"MM\"},\"picksObtained\":[{\"slot\":{\"round\":3},\"season\":2018},{\"slot\":{\"round\":5},\"season\":2018},{\"slot\":{\"round\":7},\"season\":2018}]}],\"description\":\"1 Pick for 3 Picks\",\"status\":\"TRADE_STATUS_EXECUTED\",\"proposedOn\":\"1525472311000\",\"approvedOn\":\"1525473785000\",\"numVetoesRequired\":7,\"chatChannel\":\"/chats/NFL/leagues/206154/trades-3997043\"},{\"id\":3996860,\"teams\":[{\"team\":{\"id\":1373988,\"name\":\"Springfield Isotopes\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1373988_0_150x150.jpg\",\"initials\":\"SI\"},\"picksObtained\":[{\"slot\":{\"round\":15},\"season\":2018}]},{\"team\":{\"id\":1374255,\"name\":\"Mushroom City Karts\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1374255_0_150x150.jpg\",\"initials\":\"MC\"},\"picksObtained\":[{\"slot\":{\"round\":7},\"season\":2018}]}],\"description\":\"1 Pick for 1 Pick\",\"status\":\"TRADE_STATUS_EXECUTED\",\"proposedOn\":\"1525465867000\",\"approvedOn\":\"1525466077000\",\"numVetoesRequired\":7,\"chatChannel\":\"/chats/NFL/leagues/206154/trades-3996860\"},{\"id\":3996840,\"teams\":[{\"team\":{\"id\":1373988,\"name\":\"Springfield Isotopes\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1373988_0_150x150.jpg\",\"initials\":\"SI\"},\"picksObtained\":[{\"slot\":{\"round\":1},\"season\":2018},{\"slot\":{\"round\":7},\"season\":2018}]},{\"team\":{\"id\":1374255,\"name\":\"Mushroom City Karts\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1374255_0_150x150.jpg\",\"initials\":\"MC\"},\"picksObtained\":[{\"slot\":{\"round\":1},\"season\":2018},{\"slot\":{\"round\":15},\"season\":2018}]}],\"description\":\"2 Picks for 2 Picks\",\"status\":\"TRADE_STATUS_EXECUTED\",\"proposedOn\":\"1525465132000\",\"approvedOn\":\"1525465245000\",\"numVetoesRequired\":7,\"chatChannel\":\"/chats/NFL/leagues/206154/trades-3996840\"},{\"id\":3996138,\"teams\":[{\"team\":{\"id\":1373480,\"name\":\"Goldenrod City Nightmares\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1373480_0_150x150.jpg\",\"initials\":\"GC\"},\"picksObtained\":[{\"slot\":{\"round\":1},\"season\":2018},{\"slot\":{\"round\":3},\"season\":2018}]},{\"team\":{\"id\":1373973,\"name\":\"Red River Land Thunder\",\"logoUrl\":\"https://s3.amazonaws.com/fleaflicker/t1373973_0_150x150.jpg\",\"initials\":\"RR\"},\"picksObtained\":[{\"slot\":{\"round\":1},\"season\":2018}]}],\"description\":\"2 Picks for 1 Pick\",\"status\":\"TRADE_STATUS_EXECUTED\",\"proposedOn\":\"1525433608000\",\"approvedOn\":\"1525436362000\",\"numVetoesRequired\":7,\"chatChannel\":\"/chats/NFL/leagues/206154/trades-3996138\"}],\"filter\":\"TRADES_COMPLETED\",\"resultTotal\":86}"),
  date = structure(1606180798, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 4.3e-05,
    connect = 4.5e-05, pretransfer = 0.000154, starttransfer = 0.050249,
    total = 0.050348
  )
), class = "response")
