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

needs_mocking <- function() {
  !identical(Sys.getenv("MOCK_BYPASS"), "true")
}

github_online <- function(){
  # !identical(curl::nslookup("github.com"),"")
  FALSE
}

if (needs_mocking() & github_online()) {
  cache_dir <- rappdirs::user_cache_dir("ffscrapr")
  if (!file.exists(cache_dir)) {
    dir.create(cache_dir, showWarnings = FALSE, recursive = TRUE)
  }

  cache_path <- file.path(cache_dir, "ffscrapr-tests-1.4.7")

  # Cache for 24 hours
  if (!file.exists(cache_path) || difftime(Sys.time(), file.mtime(cache_path), units = "days") > 1) {

    path <- tempfile()
    download.file("https://github.com/ffverse/ffscrapr-tests/archive/1.4.7.zip", path)
    unzip(path, exdir = cache_dir)
    unlink(path)
  }

  httptest::.mockPaths(cache_path)
}

local_mock_api <- function(envir = parent.frame()) {
  if (!needs_mocking()) return()

  if (!github_online()) testthat::skip("GitHub offline!")

  cache_path <- file.path(rappdirs::user_cache_dir("ffscrapr"), "ffscrapr-tests-1.4.7")
  if(!file.exists(cache_path)) testthat::skip("Could not find cache files!")

  httptest::use_mock_api()
  withr::defer(httptest::stop_mocking(), envir = envir)
}
