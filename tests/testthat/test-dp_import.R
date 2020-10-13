test_that("dp_values are fetched", {
  values <- dp_values()
  player_ids <- dp_playerids()

  expect_tibble(values, min.rows = 1)
  expect_tibble(player_ids, min.rows = 1)
})
