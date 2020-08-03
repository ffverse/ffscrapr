with_mock_api({

  test_that("ff_connect returns an S3 obj for each platform currently programmed", {
    expect_s3_class(ff_connect("mfl", 54040), "mfl_conn")
    expect_s3_class(ff_connect("sleeper", 527362181635997696), "sleeper_conn")
    expect_error(ff_connect("flea"))
  })

  test_that("Does mfl-logincookie return a request-like object?", {

    request <- .mfl_logincookie(
      user_name = "dynastyprocesstest",
      password = "test1234",
      season = "2020")
    expect_s3_class(request, "request")
  })

  test_that("Does mfl_connect returns an mfl-connection object?", {

    conn <- mfl_connect(season = 2020,
      league_id = 54040,
      user_name = "dynastyprocesstest",
      password = "test1234",
      rate_limit = FALSE)

    expect_s3_class(conn, "mfl_conn")
    expect_error(mfl_connect(2020, 54040, rate_limit = "bork"))
    expect_message(mfl_connect(2020, 54040, user_name = "dynastyprocesstest"))
    expect_message(mfl_connect(2020, 54040, password = "test1234"))
    expect_output(print(conn), "*MFL conn*")
  })

})
