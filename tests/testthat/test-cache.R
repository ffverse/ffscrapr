test_that("Cache clearing works", {
  local_mock_api()

  conn <- mfl_connect(2020, 54040)
  x <- mfl_players(conn)
  expect(memoise::has_cache(mfl_players)(conn), "Function wasn't memoised!")

  .ff_clear_cache()

  expect(!memoise::has_cache(mfl_players)(conn), "Cache has been cleared!")
})
