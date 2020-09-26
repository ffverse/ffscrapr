with_mock_api({
  test_that("ff_transactions returns a tibble of transactions", {
    ssb <- mfl_connect(2019, 54040)
    ssb_transactions <- ff_transactions(ssb)

    dlf <- mfl_connect(2020, 37920)
    dlf_transactions <- ff_transactions(dlf)

    expect_tibble(ssb_transactions, min.rows = 100)
    expect_tibble(dlf_transactions, min.rows = 100)
  })
})
