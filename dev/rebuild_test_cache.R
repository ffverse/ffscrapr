# Rebuild test cache

library(httptest)

rebuild_test_cache <- function(cache_dir){

  withr::with_envvar(c(MOCK_BYPASS = "true", CACHE_DIR = cache_dir),{

    withr::with_dir(
      cache_dir,
      unlink(c("espn","flea","mfl","sleeper"), recursive = TRUE, force = TRUE)
    )

    httptest::start_capturing(path = cache_dir)

    on.exit(stop_capturing())

    options(ffscrapr.cache = "none")

    testthat::test_local()

  })
}

cache_dir <- "/home/tan/ffverse/ffscrapr-tests"
rebuild_test_cache(cache_dir)

