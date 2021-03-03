
## SUBMISSION

## CRAN Check Corrections

This release corrects an issue where URL parameters were being programmatically determined by a date threshold (which caused tests to fail when the date threshold was crossed and there were no mock files to support the new query). This has been fixed by rewriting the function to take dates from function-arguments, so that tests will not fail when the date threshold is crossed. 

## New features

This release extends the package to support another fantasy football platform, ESPN. 

## Test environments
* local (Windows) R installation, R 4.0.2
* ubuntu 16.04 (on GitHub Actions), R 4.0.2
* MacOS (on GitHub Actions), R 4.0.2
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 0 note
