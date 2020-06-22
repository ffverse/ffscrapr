#### Memoise On Load ####
# nocov start
.onLoad <- function(libname, pkgname) {

  # Memoise specific functions
  # Timeout lengths still up for discussion
  #
  mfl_players <<- memoise::memoise(mfl_players,~ memoise::timeout(86400))
  mfl_allrules <<- memoise::memoise(mfl_allrules,~ memoise::timeout(86400))
  ff_scoring <<- memoise::memoise(ff_scoring, ~ memoise::timeout(3600))
  ff_franchises <<- memoise::memoise(ff_franchises, ~ memoise::timeout(60))
  ff_league <<- memoise::memoise(ff_league, ~ memoise::timeout(60))
  ff_rosters <<- memoise::memoise(ff_rosters, ~ memoise::timeout(30))

}
# nocov end
