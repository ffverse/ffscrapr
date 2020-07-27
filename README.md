# ffscrapr <a href='ffscrapr.dynastyprocess.com'><img src='man/figures/logo.png' align="right" height="120" /></a>
*An R Client for Fantasy Football League APIs*

  <!-- badges: start -->
  [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
  [![Codecov test coverage](https://codecov.io/gh/DynastyProcess/ffscrapr/branch/main/graph/badge.svg)](https://codecov.io/gh/DynastyProcess/ffscrapr?branch=main)
  [![R build status](https://github.com/DynastyProcess/ffscrapr/workflows/R-CMD-check/badge.svg)](https://github.com/DynastyProcess/ffscrapr/actions)
  <!-- badges: end -->


The goal of this package is to abstract the code required to call various Fantasy Football APIs (i.e. MFL, Sleeper, Fleaflicker, ESPN, Yahoo, potentially other platforms) and create methods that handles required authentication, forms appropriate calls, and returns tidy and predictable data which can be easily connected to other data sources.


## Installation
Install from GitHub with:

``` r
# install.packages("devtools") OR install.packages("remotes")
## remotes is a subpackage of devtools
remotes::install_github("dynastyprocess/ffscrapr")
```
