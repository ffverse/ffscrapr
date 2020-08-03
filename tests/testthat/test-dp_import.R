test_that("dp_values are fetched", {

  values <- dp_values()
  player_ids <- dp_playerids()

  expect_s3_class(values, "tbl_df")
  expect_s3_class(player_ids, "tbl_df")

  expect_gt(nrow(values), 1)
  expect_gt(nrow(player_ids), 1)

})
