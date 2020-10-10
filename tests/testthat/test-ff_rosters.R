with_mock_api({
  test_that("ff_rosters returns a tibble", {
    ssb <- mfl_connect(2020, 54040)
    ssb_rosters <- ff_rosters(ssb)

    expect_tibble(ssb_rosters, min.rows = 300)

    jml_conn <- ff_connect(platform = "sleeper", league_id = 522458773317046272, season = 2020)
    jml_rosters <- ff_rosters(jml_conn)

    expect_tibble(jml_rosters, min.rows = 200)
  })
})
