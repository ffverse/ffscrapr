
test_that("Unknown platforms return no-method errors", {
  conn <- structure(list(platform = "dummy"),
    class = "dummy_platform"
  )

  message <- "No method"

  expect_error(ff_draft(conn), message)
  expect_error(ff_starters(conn), message)
  expect_error(ff_draftpicks(conn), message)
  expect_error(ff_league(conn), message)
  expect_error(ff_franchises(conn), message)
  expect_error(ff_playerscores(conn), message)
  expect_error(ff_scoring(conn), message)
  expect_error(ff_rosters(conn), message)
  expect_error(ff_schedule(conn), message)
  expect_error(ff_standings(conn), message)
  expect_error(ff_transactions(conn), message)
  expect_error(ff_userleagues(conn), message)
})
