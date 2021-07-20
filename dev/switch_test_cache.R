library(xfun)

paths <- c(
  "ffscrapr-tests-1.4.2",
  "ffscrapr-tests-main",
  "https://github.com/ffverse/ffscrapr-tests/archive/main.zip",
  "https://github.com/ffverse/ffscrapr-tests/archive/1.4.2.zip"
)

use_ffscrapr_tests_main <- function(){

  gsub_dir("archive/[0-9,\\.]+\\.zip", "archive/main.zip", dir = ".",recursive = TRUE, ext = c("R","Rmd"))

  gsub_dir("ffscrapr\\-tests\\-[0-9\\.]+", "ffscrapr-tests-main", dir = ".", recursive = TRUE, ext = c("R","Rmd"))

  message("Check your version control now!")
  invisible()
}

# use_ffscrapr_tests_main()

use_ffscrapr_tests_version <- function(version){

  stopifnot(length(version)==1)

  gsub_dir("archive/main", paste0("archive/",version), dir = ".", ext = c("R","Rmd"), recursive = TRUE)

  gsub_dir("ffscrapr\\-tests\\-main", paste0("ffscrapr-tests-",version), dir = ".", ext = c("R","Rmd"), recursive = TRUE)

  message("Check your version control now!")
  invisible()
}

# use_ffscrapr_tests_version('1.4.4')
