# test_that("multiplication works", {
#   expect_equal(2 * 2, 4)
# })

test_that("ff_connect returns an S3 obj for each platform currently programmed",{
  expect_s3_class(ff_connect("mfl",54040),"mfl_conn")
  expect_s3_class(ff_connect("sleeper",527362181635997696),"sleeper_conn")
  expect_error(ff_connect("flea"))
})

test_that("ff_connect returns an S3 obj for each platform currently programmed",{
  expect_s3_class(ff_connect("mfl",54040),"mfl_conn")
  expect_s3_class(ff_connect("sleeper",527362181635997696),"sleeper_conn")
  expect_error(ff_connect("flea"))
})

with_mock_api({
test_that("ff_league returns a tibble for each platform currently programmed",{
  dlf_conn <- ff_connect("mfl",37920,season = 2020)
  dlf_league <- ff_league(dlf_conn)

  expect_s3_class(dlf_league,class = "tbl_df")
  expect_equal(nrow(dlf_league),1)
  expect_true(Reduce(`&`,!is.na(dlf_league)),label = "Test ff_league(dlf) for NA values")

  sleeper_conn <- ff_connect("sleeper",527362181635997696,season = 2020)
  expect_error(ff_league(sleeper_conn))

})
})

with_mock_api({
  test_that("ff_league returns a tibble for each platform currently programmed",{
    dlf_conn <- ff_connect("mfl",37920,season = 2020)
    dlf_rosters <- ff_rosters(dlf_conn)

    expect_s3_class(dlf_rosters,class = "tbl_df")
    expect_gt(nrow(dlf_rosters),1)

    sleeper_conn <- ff_connect("sleeper",527362181635997696,season = 2020)
    expect_error(ff_league(sleeper_conn))

  })
})
