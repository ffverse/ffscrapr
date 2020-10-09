with_mock_api({
  test_that("ff_franchises returns a tibble of franchises", {
    ssb <- mfl_connect(2019, 54040)
    ssb_franchises <- ff_franchises(ssb)

    dlf <- mfl_connect(2020, 37920)
    dlf_franchises <- ff_franchises(dlf)

    # jml <- sleeper_connect(2020,522458773317046272)
    # jml_franchises <- ff_franchises(jml)

    expect_tibble(ssb_franchises, nrows = 14)
    expect_tibble(dlf_franchises, nrows = 16)
    # expect_tibble(jml_franchises, nrow = 12)
  })
})
