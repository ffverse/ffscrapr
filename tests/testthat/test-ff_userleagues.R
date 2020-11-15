with_mock_api({
  test_that("ff_userleagues works for MFL", {
    conn <- mfl_connect(2020,
      user_name = "dynastyprocesstest",
      password = "test1234"
    )

    leagues <- ff_userleagues(conn)

    expect_tibble(leagues, min.rows = 1, any.missing = FALSE)

    edge <- mfl_connect(2020, 54040)
    expect_error(ff_userleagues(edge), "No authentication cookie")
  })
})


with_mock_api({
  test_that("ff_userleagues works for Sleeper", {
    conn <- sleeper_connect(2020,
      user_name = "solarpool"
    )

    full_call <- ff_userleagues(conn)
    quick_call <- sleeper_userleagues("solarpool",2020)

    expect_tibble(full_call, min.rows = 1)
    expect_tibble(quick_call, min.rows = 1)

  })
})
