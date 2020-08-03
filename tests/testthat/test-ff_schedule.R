with_mock_api({
  test_that("ff_schedule returns a tibble",{

    dlf <- mfl_connect(2019,37920)
    dlf_schedule <- ff_schedule(dlf)

    expect_s3_class(dlf_schedule,"tbl_df")
    expect_gt(nrow(dlf_schedule),1)

    ssb <- mfl_connect(2020,54040)
    ssb_schedule <- ff_schedule(ssb)

    fog <- mfl_connect(2019,12608)
    fog_schedule <- ff_schedule(fog)

    # expect_s3_class(fog_schedule,"tbl_df")
    expect_null(fog_schedule)

  })
})
