test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

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

test_that("ff_league gets a league",{NULL})
