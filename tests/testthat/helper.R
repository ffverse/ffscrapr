suppressPackageStartupMessages({
  library(httptest)
  library(checkmate)
})

if (Sys.getenv("MOCK_BYPASS") == "true") {
    with_mock_api <- force
}
