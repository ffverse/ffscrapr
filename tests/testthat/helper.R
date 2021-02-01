suppressPackageStartupMessages({
  library(httptest)
  library(checkmate)
})

if (Sys.getenv("MOCK_BYPASS") == "true") {
    with_mock_api <- force
}

httptest::set_requester(
  function(request){
    httptest::gsub_request(request,"https\\://fantasy.espn.com/apis/v3/games/ffl/","espn/") %>%
      httptest::gsub_request("https\\://api.myfantasyleague.com/","mfl/") %>%
      httptest::gsub_request("https\\://api.sleeper.app/","sleeper/") %>%
      httptest::gsub_request("https\\://www.fleaflicker.com/","flea/") %>%
      httptest::gsub_request("https\\://github.com/DynastyProcess/data/raw/master/files/","gh_dynastyprocess/")
  }
)

httptest::set_redactor(
  function(response){
    httptest::gsub_response(response,"https\\://fantasy.espn.com/apis/v3/games/ffl/","espn/") %>%
      httptest::gsub_response("https\\://api.myfantasyleague.com/","mfl/") %>%
      httptest::gsub_response("https\\://api.sleeper.app/","sleeper/") %>%
      httptest::gsub_response("https\\://www.fleaflicker.com/","flea/") %>%
      httptest::gsub_response("https\\://github.com/DynastyProcess/data/raw/master/files/","gh_dynastyprocess/")
  }
)
