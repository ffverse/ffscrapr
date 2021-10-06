test_that("choose season returns a character representation of a year", {
  skippy()
  expect_type(.fn_choose_season(), "character")
  expect_equal(.fn_choose_season("2020-03-01"), "2020")
  expect_equal(.fn_choose_season("2020-02-01"), "2019")
})

with_mock_api({
  test_that(".fn_set_ratelimit creates a 'GET' function", {
    skippy()
    expect_is(.fn_set_ratelimit(TRUE, "MFL", 1, 1)$get("http://httpbin.org"), "response")
    expect_is(.fn_set_ratelimit(FALSE, "MFL")$get("http://httpbin.org"), "response")
  })
})
