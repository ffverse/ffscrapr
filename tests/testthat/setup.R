suppressPackageStartupMessages({
  library(testthat)
  library(httptest)
  library(checkmate)
})

# Download test files if running mocked tests
download_mock <- !identical(Sys.getenv("MOCK_BYPASS"), "true")

if (download_mock) {
  cache_dir <- tools::R_user_dir("ffscrapr")
  if (!file.exists(cache_dir)) {
    dir.create(cache_dir, showWarnings = FALSE, recursive = TRUE)
  }

  cache_path <- file.path(cache_dir, "ffscrapr-tests-main")

  # Cache for 24 hours
  if (!file.exists(cache_path) || difftime(Sys.time(), file.mtime(cache_path), units = "days") > 1) {
    path <- tempfile()
    download.file("https://github.com/ffverse/ffscrapr-tests/archive/main.zip", path)
    unzip(path, exdir = cache_dir)
    unlink(path)
  }

  httptest::.mockPaths(cache_path)
} else {
  with_mock_api <- force
}
