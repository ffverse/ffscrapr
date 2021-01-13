suppressPackageStartupMessages({
  library(httptest)
  library(checkmate)
})

if (Sys.getenv("MOCK_BYPASS") == "true") {
    with_mock_api <- force
}
#
httptest::set_requester(
  function(request){
      httptest::gsub_request(request,"https\\://fantasy.espn.com/apis/v3/games/ffl/","espn/")
  }
)
