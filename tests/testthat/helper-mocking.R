library(checkmate)

# Download test files if running mocked tests
needs_mocking <- function() {
  !identical(Sys.getenv("MOCK_BYPASS"), "true")
}

if (needs_mocking()) {
  cache_dir <- tools::R_user_dir("ffscrapr")
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
  if (!needs_mocking()) {
    return()
  }

  httptest::use_mock_api()
  withr::defer(httptest::stop_mocking(), envir = envir)
}
