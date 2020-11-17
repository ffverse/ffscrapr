with_mock_api({

  test_that("Cache clearing works", {

    x <- mfl_players()
    expect(memoise::has_cache(mfl_players)(),"Function wasn't memoised!")

    .ffscrapr_clear_cache()

    expect(!memoise::has_cache(mfl_players)(), "Cache has been cleared!")

  })

})
