httptest::set_requester(
  function(request){
    httptest::gsub_request(request,"https\\://fantasy.espn.com/apis/v3/games/ffl/","espn/") %>%
      httptest::gsub_request("https\\://api.myfantasyleague.com/","mfl/") %>%
      httptest::gsub_request("https\\://api.sleeper.app/","sleeper/") %>%
      httptest::gsub_request("https\\://www.fleaflicker.com/","flea/") %>%
      httptest::gsub_request("https\\://github.com/DynastyProcess/data/raw/master/files/","gh_dynastyprocess/")
  }
)
