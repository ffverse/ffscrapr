# Package workflow helper

## DESCRIPTION
# Import
usethis::use_package("httr", type = "Imports", min_version = '1.4.0')
usethis::use_package("ratelimitr", type = "Imports", min_version = '0.4.0')
usethis::use_package("jsonlite", type = "Imports", min_version = '1.6.0')
usethis::use_package("memoise",type = "Imports", min_version = '1.1.0')

# Manipulation
usethis::use_package("dplyr", type = "Imports", min_version = '0.8.0')
usethis::use_package("tidyr", type = "Imports", min_version = '1.0.0')
usethis::use_package("purrr", type = "Imports", min_version = '0.3.0')
usethis::use_package("tibble", type = "Imports", min_version = '3.0.0')
usethis::use_package("rlang", type = "Imports", min_version = '0.4.0')
usethis::use_package("glue", type = "Imports", min_version = '1.3.0')
usethis::use_package("lubridate", type = "Imports", min_version = '1.5.0')

# Testing
usethis::use_package("testthat", type = "Suggests", min_version = '2.0.0')
usethis::use_package("covr", type = "Suggests", min_version = '3.0.0')
usethis::use_package("httptest", type = "Suggests", min_version = '3.0.0')

usethis::use_tidy_description()

## LICENSE
usethis::use_mit_license("Tan Ho")

# bump version
usethis::use_version("dev")

# DOCUMENT AND TEST
devtools::check(document = TRUE)

# REBUILD PKGDOWN
# pkgdown::build_site()
pkgdown::deploy_to_branch(devel = TRUE)
