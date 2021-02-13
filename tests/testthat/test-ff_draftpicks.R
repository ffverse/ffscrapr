with_mock_api({
  test_that("ff_draftpicks returns a tibble of draft picks", {
    skippy()

    ssb <- mfl_connect(2020, 54040)
    ssb_picks <- ff_draftpicks(ssb)

    sfb <- mfl_connect(2020, 65443)
    sfb_picks <- ff_draftpicks(sfb)

    expect_tibble(ssb_picks, min.rows = 1)
    expect_tibble(sfb_picks, nrows = 0)

    jml_conn <- ff_connect("sleeper", "522458773317046272", season = 2020)
    jml_picks <- ff_draftpicks(jml_conn)

    dlp <- sleeper_connect(2020, "521379020332068864")
    dlp_picks <- ff_draftpicks(dlp)

    expect_tibble(jml_picks, min.rows = 144)
    expect_tibble(dlp_picks, min.rows = 144)

    joe_conn <- fleaflicker_connect(2020, 206154)
    joe_picks <- ff_draftpicks(joe_conn, franchise_id = 1373475)

    expect_tibble(joe_picks, min.rows = 1)

    dlp <- ff_connect("espn", 1178049)

    expect_warning(ff_draftpicks(dlp), regexp = "ESPN does not support draft pick trades")
  })
})
