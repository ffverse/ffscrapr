# FFscrapR
*An R Client for Fantasy Football League APIs*

  <!-- badges: start -->
  [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
  [![Codecov test coverage](https://codecov.io/gh/DynastyProcess/ffscrapr/branch/master/graph/badge.svg)](https://codecov.io/gh/DynastyProcess/ffscrapr?branch=master)
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

## Functions List
Loose roadmap:


- Create connection to x league platform
- Get raw API endpoints
- Get league settings (i.e. number of teams, roster spots, starting-positions, number of QBs, IDPs, best ball etc)
- Get scoring settings (PPR, PP1D, positional-scoring)
- Get franchise data
- Get draft/draft_picks
- Get player data
- Get transaction data
- Get standings data (standings, potential-points, all-play, ?)
- Get raw API endpoint (how do I construct argument calls from dots?)

## Nomenclature decisions log

Ordinary user functions are prefixed with `ff_` for easy autocomplete and wrap the corresponding function for each platform.

League-specific functions are prefixed with the league - i.e. `mfl_`, `sleeper_`, `espn_`, `yahoo_` etc.

## Changelog

- 2020-05-18 - initial commit and roadmap generated, add mfl_connect and mfl_endpoint_league functions
- 2020-05-19 - following [httr API vignette](https://httr.r-lib.org/articles/api-packages.html) and created generic call to MFL API via `get_mfl_endpoint()`
- 2020-05-23 - adding rate limiting and beginnings of Sleeper connection code
- 2020-05-27 - adding test folder, renamed main-level functions to "ff_" prefix for ease of autocomplete later
- 2020-05-30 - add start of league summary code
- 2020-06-07 - taking a big whack at testing stuff
