with_mock_api({
  test_that("ff_league returns a tibble for each platform currently programmed", {
    dlf_conn <- ff_connect("mfl", 37920, season = 2020)
    dlf_league <- ff_league(dlf_conn)

    expect_tibble(dlf_league, any.missing = FALSE, min.rows = 1)

    sleeper_conn <- ff_connect("sleeper", 527362181635997696, season = 2020)
    expect_error(ff_league(sleeper_conn))
  })
})
