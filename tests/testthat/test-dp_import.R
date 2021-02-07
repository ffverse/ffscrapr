with_mock_api({
  test_that("dp_values are fetched", {
    values <- dp_values()
    player_values <- dp_values("values-players.csv")
    player_ids <- dp_playerids()

    expect_tibble(values, min.rows = 1)
    expect_tibble(player_ids, min.rows = 1)
    expect_tibble(player_values, min.rows = 1)
  })
})

test_that("dp_cleannames removes periods, apostrophes, and suffixes", {
  player_names <- c("A.J. Green", "Odell Beckham Jr.", "Le'Veon Bell Sr.")

  cleaned_names <- dp_cleannames(player_names)

  lowercase_clean <- dp_cleannames(player_names, lowercase = TRUE)

  expect_equal(cleaned_names, c("AJ Green", "Odell Beckham", "LeVeon Bell"))
  expect_equal(lowercase_clean, c("aj green", "odell beckham", "leveon bell"))
})
