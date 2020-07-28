with_mock_api({
  test_that("ff_league returns a tibble for each platform currently programmed",{
    dlf_conn <- ff_connect("mfl",37920,season = 2019)
    dlf_standings <- ff_standings(dlf_conn)

    expect_s3_class(dlf_standings,class = "tbl_df")
    expect_gt(nrow(dlf_standings),1)
    expect_true(Reduce(`&`,!is.na(dlf_standings)),label = "Test ff_league(dlf) for NA values")

    sleeper_conn <- ff_connect("sleeper",527362181635997696,season = 2020)
    expect_error(ff_standings(sleeper_conn))

  })
})
