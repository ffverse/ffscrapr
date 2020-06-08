with_mock_api({
  test_that("Does logincookie return a request-like object?",{

    request <- .mfl_logincookie(
      fn_get = .fn_get(TRUE,1,1),
      user_name = "dynastyprocesstest",
      password="test1234",
      user_agent = httr::user_agent("ffscrapr-test"),
      season = "2020")
    expect_s3_class(request,"request")
  })

  test_that("Does mfl_connect returns an mfl-connection object?",{

    conn <- mfl_connect(season = 2020,
                        league_id = 54040,
                        user_name = "dynastyprocesstest",
                        password = "test1234",
                        rate_limit = FALSE)
    expect_s3_class(conn,"mfl_conn")
    expect_type(conn$get,"closure")
    expect_error(mfl_connect(2020,54040,rate_limit = "bork"))
    expect_message(mfl_connect(2020,54040,user_name = "dynastyprocesstest"))
    expect_message(mfl_connect(2020,54040,password = "test1234"))
    expect_output(print(conn),"*MFL conn*")
    # expect_
    # expect_error(mfl_connect(2020,54040,))
  })

})

