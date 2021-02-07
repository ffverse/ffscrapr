httptest::set_redactor(
  function(response){
    httptest::gsub_response(response,"https\\://fantasy.espn.com/apis/v3/games/ffl/","espn/") %>%
      httptest::gsub_response("https\\://api.myfantasyleague.com/","mfl/") %>%
      httptest::gsub_response("https\\://api.sleeper.app/","sleeper/") %>%
      httptest::gsub_response("https\\://www.fleaflicker.com/","flea/") %>%
      httptest::gsub_response("https\\://github.com/DynastyProcess/data/raw/master/files/","gh_dynastyprocess/")
  }
)
