library(testthat)
library(covr)
library(ffscrapr)

test_check("ffscrapr")
covr::codecov()
