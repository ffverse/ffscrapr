with_mock_api({

  test_that("ff_transactions returns a tibble of transactions",{

    ssb <- mfl_connect(2019,54040)
    ssb_transactions <- ff_transactions(ssb)

    dlf <- mfl_connect(2020,37920)
    dlf_transactions <- ff_transactions(dlf)

    expect_s3_class(dlf_transactions,"tbl_df")
    expect_s3_class(ssb_transactions,"tbl_df")
    expect_gt(nrow(ssb_transactions),1)
    expect_gt(nrow(dlf_transactions),1)

  })

})
