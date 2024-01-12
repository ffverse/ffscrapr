library(checkmate)

## Testing scenarios
#
# 1. If GitHub is offline, skip all tests.
#
# 2. If MOCK_BYPASS environment variable is set to TRUE, run tests without mocking.
#
# 3. If GitHub is online and MOCK_BYPASS environment variable not set to TRUE,
# attempt to download mock files from GitHub.
#
# 3a. If there are any failures with downloading mock files, skip all tests.
# 3b. If everything works, run the tests against mock files.

# Goal of testing with mock is to test data cleaning/transformation dependencies
# as they change on CRAN (and hold API responses constant).
local_mock_api <- function(envir = parent.frame()) {
  if (.bypass_mocks()) return()
  if (.rebuild_mocks()) return()
  if (!github_online()) testthat::skip("GitHub offline!")
  if (!file.exists(.cache_path())) testthat::skip("Could not find cache files!")

  httptest::.mockPaths(.cache_path())
  httptest::use_mock_api()
  withr::defer(httptest::stop_mocking(), envir = envir)
}

if (.rebuild_mocks()) {
  cli::cli_inform("Rebuilding mocked tests")
  # unlink(.cache_path(), recursive = TRUE)
  httptest::.mockPaths(.cache_path())
  httptest::start_capturing(simplify = FALSE)
  withr::defer({
    httptest::stop_capturing()
    .upload_cache()
  },
  envir = testthat::teardown_env()
  )
}

if (!.bypass_mocks() && !.rebuild_mocks()) {
  httptest::.mockPaths(.cache_path())
  .download_cache()
}
