test_that("ff_userleagues works for MFL", {
  local_mock_api()

  conn <- mfl_connect(2020,
    user_name = "dynastyprocesstest",
    password = "test1234"
  )

  leagues <- ff_userleagues(conn)

  expect_tibble(leagues, min.rows = 1, any.missing = FALSE)

  edge <- mfl_connect(2020, 54040)
  expect_error(ff_userleagues(edge), "No authentication cookie")
})

test_that("ff_userleagues works for Sleeper", {
  local_mock_api()

  conn <- sleeper_connect(2020,
    user_name = "solarpool"
  )

  full_call <- ff_userleagues(conn)
  quick_call <- sleeper_userleagues("solarpool", 2020)

  expect_tibble(full_call, min.rows = 1)
  expect_tibble(quick_call, min.rows = 1)
})

test_that("ff_userleagues works for Fleaflicker", {
  local_mock_api()

  conn <- fleaflicker_connect(
    season = 2020,
    user_email = "syd235@gmail.com"
  )

  full_call <- ff_userleagues(conn)
  quick_call <- fleaflicker_userleagues("syd235@gmail.com", 2020)

  expect_tibble(full_call, min.rows = 1)
  expect_tibble(quick_call, min.rows = 1)
})

test_that("ff_userleagues returns warning for ESPN", {
  local_mock_api()

  espn_conn <- espn_connect(season = 2020)

  expect_warning(ff_userleagues(espn_conn), regexp = "ESPN does not support")
})
