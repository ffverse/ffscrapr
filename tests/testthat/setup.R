suppressPackageStartupMessages({
  library(testthat)
  library(httptest)
  library(checkmate)
})

# Download test files and clean up afterwards, if running mocked tests

if (identical(Sys.getenv("MOCK_BYPASS"), "true")) with_mock_api <- force

download_mock <- !identical(Sys.getenv("MOCK_BYPASS"), "true") & !is.null(curl::nslookup("github.com", error = FALSE))

skip <- FALSE

if (download_mock) {
  tryCatch(
    expr = {
      download.file("https://github.com/ffverse/ffscrapr-tests/archive/1.4.7.zip", "f.zip")
      unzip("f.zip", exdir = ".")

      httptest::.mockPaths(new = "ffscrapr-tests-1.4.7")

      withr::defer(
        unlink(c("ffscrapr-tests-1.4.7", "f.zip"), recursive = TRUE, force = TRUE),
        testthat::teardown_env()
      )
    },
    warning = function(e) skip <<- TRUE,
    error = function(e) skip <<- TRUE
  )
}

skippy <- function() NULL
if (skip) skippy <- function() testthat::skip(message = "Unable to download test data")
