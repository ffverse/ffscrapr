test_that("ff_connect returns an S3 platform_conn obj for each platform currently programmed", {
  local_mock_api()

  ssb <- ff_connect("mfl", 54040, user_agent = "ffscrapr_test")
  jml <- ff_connect("sleeper", "527362181635997696")
  solar <- ff_connect(
    platform = "sleeper",
    user_name = "solarpool"
  )
  joe <- ff_connect("flea", 312861)

  dlp <- ff_connect("espn", 1178049)

  expect_s3_class(ssb, "mfl_conn")
  expect_s3_class(jml, "sleeper_conn")
  expect_s3_class(solar, "sleeper_conn")
  expect_s3_class(joe, "flea_conn")
  expect_s3_class(dlp, "espn_conn")
})

test_that("Does mfl-logincookie return a request-like object?", {
  local_mock_api()
  request <- .mfl_logincookie(
    user_name = "dynastyprocesstest",
    password = "test1234",
    season = "2020"
  )
  expect_s3_class(request, "request")
})

test_that("Does mfl_connect returns an mfl-connection object?", {
  local_mock_api()
  conn <- mfl_connect(
    season = 2020,
    league_id = 54040,
    user_name = "dynastyprocesstest",
    password = "test1234",
    rate_limit = FALSE
  )

  expect_s3_class(conn, "mfl_conn")
  expect_error(mfl_connect(2020, 54040, rate_limit = "bork"))
  expect_message(mfl_connect(2020, 54040, user_name = "dynastyprocesstest"))
  expect_message(mfl_connect(2020, 54040, password = "test1234"))
  expect_output(print(conn), "*MFL conn*")
})

test_that("sleeper_connect edge cases are handled", {
  expect_error(sleeper_connect(user_agent = c("pie", "cake")), regexp = "character vector of length one")
  expect_error(sleeper_connect(user_agent = "ffscraprtest", rate_limit = 1), regexp = "rate_limit should be logical")
})

test_that("ESPN connect cookie authentication works", {
  dlp <- espn_connect(season = 2020, league_id = 1178049, swid = "{1E6BB139}", espn_s2 = "AECt%2FIDwd5kt")

  expect_character(dlp$cookies$options$cookie,
    pattern = "\\{",
    info = "Cookie string contains curly brace"
  )
})
