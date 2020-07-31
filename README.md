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

## Contributing

Many hands make light work! Here are some ways you can contribute to this project:

- You can [open an issue](https://github.com/DynastyProcess/ffscrapr/issues/new/choose) if you'd like to request specific data or report a bug/error. 

- Happy to accept pull requests for bugfixes, but please open an issue before making a PR for a new feature so I can make sure it fits within the scope of the project!

- You can [sponsor this project by donating to help with server costs](https://github.com/sponsors/tanho63)!
