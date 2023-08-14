test_that("dp_values are fetched", {
  local_mock_api()

  values <- dp_values()
  player_values <- dp_values("values-players.csv")
  player_ids <- dp_playerids()

  expect_tibble(values, min.rows = 1)
  expect_tibble(player_ids, min.rows = 1)
  expect_tibble(player_values, min.rows = 1)
})
