with_mock_api({
  test_that("ff_draftpicks returns a tibble of draft picks", {
    ssb <- mfl_connect(2020, 54040)
    ssb_picks <- ff_draftpicks(ssb)

    sfb <- mfl_connect(2020, 65443)
    sfb_picks <- ff_draftpicks(sfb)

    expect_s3_class(ssb_picks, "tbl_df")
    expect_gt(nrow(ssb_picks), 1)

    expect_s3_class(sfb_picks, "tbl_df")
    expect_equal(nrow(sfb_picks), 0)
  })
})
