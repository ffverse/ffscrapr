test_that("nflfastr dataframes are fetched", {
  skip_on_cran()
  skip_if_not(github_online())

  weekly <- nflfastr_weekly(seasons = 2019:2020, type = "offense")
  rosters <- nflfastr_rosters(seasons = 2019:2020)

  expect_tibble(weekly, min.rows = 1000)
  expect_tibble(rosters, min.rows = 5000)
})
