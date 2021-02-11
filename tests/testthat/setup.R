suppressPackageStartupMessages({
  library(testthat)
  library(httptest)
  library(checkmate)
})

# Download test files and clean up afterwards, if running mocked tests

if (Sys.getenv("MOCK_BYPASS") == "true") {
  with_mock_api <- force
}

runtests <- !identical(Sys.getenv("MOCK_BYPASS"), "true") & !is.null(curl::nslookup("github.com", error = FALSE))

if (runtests) {
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
    warning = function(e) runtests <<- FALSE,
    error = function(e) runtests <<- FALSE
  )
}

skippy <- function() NULL
if (!runtests) skippy <- function() testthat::skip(message = "Unable to download test data")
