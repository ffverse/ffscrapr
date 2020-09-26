with_mock_api({
  test_that("ff_draft returns a tibble for each platform currently programmed", {
    sfb_conn <- ff_connect("mfl", 65443, season = 2020)
    sfb_draftresults <- ff_draft(sfb_conn)

    expect_tibble(sfb_draftresults, min.rows = 100)

    ssb_conn <- ff_connect("mfl", 54040, season = 2020)
    ssb_draftresults <- ff_draft(ssb_conn)

    expect_tibble(ssb_draftresults, min.rows = 40)

    sleeper_conn <- ff_connect("sleeper", 527362181635997696, season = 2020)
    expect_error(ff_draft(sleeper_conn))
  })
})
