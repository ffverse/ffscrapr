## SUBMISSION

## CRAN Check Corrections

This release corrects a CRAN check issue where a dependency changed from using digest to cachem as an underlying package. ffscrapr has been rewritten to use cachem as per memoise's suggestions on best practice. 

## New features

This release adds functions to connect to another source of data. 

## Test environments
* local (Windows) R installation, R 4.0.4
* ubuntu 20.04 (on GitHub Actions), R 4.0.4
* MacOS (on GitHub Actions), R 4.0.4
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 0 note
