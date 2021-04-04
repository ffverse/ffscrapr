suppressPackageStartupMessages({
  library(testthat)
  library(httptest)
  library(checkmate)
  library(mockery)
})

# Download test files and clean up afterwards, if running mocked tests

if (identical(Sys.getenv("MOCK_BYPASS"), "true")) with_mock_api <- force

download_mock <- !identical(Sys.getenv("MOCK_BYPASS"), "true") & !is.null(curl::nslookup("github.com", error = FALSE))

skip <- FALSE

if (download_mock) {
  tryCatch(
    expr = {
      download.file("https://github.com/dynastyprocess/ffscrapr-tests/archive/main.zip", "f.zip")
      unzip("f.zip", exdir = ".")

      httptest::.mockPaths(new = "ffscrapr-tests-main")

      withr::defer(
        unlink(c("ffscrapr-tests-main", "f.zip"), recursive = TRUE, force = TRUE),
        testthat::teardown_env()
      )
    },
    warning = function(e) skip <<- TRUE,
    error = function(e) skip <<- TRUE
  )
}

skippy <- function() NULL
if (skip) skippy <- function() testthat::skip(message = "Unable to download test data")
