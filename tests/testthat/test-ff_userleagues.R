with_mock_api({
  test_that("ff_userleagues works for MFL", {

    conn <- mfl_connect(2020,
                        user_name = "dynastyprocesstest",
                        password = "test1234")

    leagues <- ff_userleagues(conn)

    expect_s3_class(leagues,"tbl_df")
    expect_gte(nrow(leagues),1)

  })
})


with_mock_api({
  test_that("ff_userleagues works for Sleeper", {

    conn <- sleeper_connect(2020,
                            user_name = "solarpool")

    leagues <- ff_userleagues(conn)

    expect_s3_class(leagues,"tbl_df")
    expect_gte(nrow(leagues),1)

  })
})
