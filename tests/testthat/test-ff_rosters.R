with_mock_api({
  test_that("ff_rosters returns a tibble", {

    ssb <- mfl_connect(2020,54040)
    ssb_rosters <- ff_rosters(ssb)

    expect_s3_class(ssb_rosters,"tbl_df")
    expect_gt(nrow(ssb_rosters),1)

  })
})