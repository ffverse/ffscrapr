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
    expect_error(ff_rosters(sleeper_conn))

  })
})

with_mock_api({
  test_that("ff_draft returns a tibble for each platform currently programmed",{
   sfb_conn <- ff_connect("mfl",65443,season = 2020)
   sfb_draftresults <- ff_draft(sfb_conn)

   expect_s3_class(sfb_draftresults,class = "tbl_df")
   expect_gt(nrow(sfb_draftresults),1)

   ssb_conn <- ff_connect("mfl",54040,season = 2020)
   ssb_draftresults <- ff_draft(ssb_conn)

   expect_s3_class(ssb_draftresults,class = "tbl_df")
   expect_gt(nrow(ssb_draftresults),1)

   sleeper_conn <- ff_connect("sleeper",527362181635997696,season = 2020)
   expect_error(ff_draft(sleeper_conn))

  })
})

with_mock_api({
  test_that("ff_transactions returns a tibble for each platform currently programmed",{
    dlf_conn <- ff_connect("mfl",37920,season = 2020)
    dlf_transactions <- ff_transactions(dlf_conn)

    expect_s3_class(dlf_transactions,class = "tbl_df")
    expect_gt(nrow(dlf_transactions),1)

    ssb_conn <- ff_connect("mfl",54040,season = 2020)
    ssb_transactions <- ff_transactions(ssb_conn)

    expect_s3_class(ssb_transactions,class = "tbl_df")
    expect_gt(nrow(ssb_transactions),1)

    sleeper_conn <- ff_connect("sleeper",527362181635997696,season = 2020)
    expect_error(ff_transactions(sleeper_conn))

  })
})

