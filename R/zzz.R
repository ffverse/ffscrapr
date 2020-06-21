#### Memoise On Load ####
# nocov start
.onLoad <- function(libname, pkgname) {

  # Memoise specific functions
  mfl_players <<- memoise::memoise(mfl_players,~ memoise::timeout(86400))
  mfl_allrules <<- memoise::memoise(mfl_allrules,~ memoise::timeout(86400))

}
# nocov end