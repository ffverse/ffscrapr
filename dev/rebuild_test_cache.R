# Rebuild test cache

library(httptest)
ffscrapr:::.fn_set_useragent("dynastyprocess")
rebuild_test_cache <- function(){
  withr::with_envvar(
    c(MOCK_REBUILD = "true"),{
    testthat::test_local()
  })
}
rebuild_test_cache()
