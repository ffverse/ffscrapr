with_mock_api({
  test_that("nflfastr dataframes are fetched", {
    skippy()
    skip_on_cran()
    weekly <- nflfastr_weekly("offense")
    rosters <- nflfastr_rosters(2019:2020)

    expect_tibble(weekly, min.rows = 100000)
    expect_tibble(rosters, min.rows = 10000)
  })
})
