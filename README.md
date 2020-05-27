# FFscrapR
*An R Client for Fantasy Football League APIs*

  <!-- badges: start -->
  [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
  <!-- badges: end -->

The goal of this package is to abstract the code required to call various Fantasy Football APIs (i.e. MFL, Sleeper, Fleaflicker, ESPN, Yahoo, etc) and create methods that handle any authentication required, forms appropriate calls, and returns tidy and predictable data which can be easily connected to DynastyProcess (and FantasyPros) information.

## Installation
Install from GitHub with:
``` r
# install.packages("devtools") OR install.packages("remotes")
## remotes is a subpackage of devtools
remotes::install_github("dynastyprocess/ffscrapr")
```

## Functions List
Loose roadmap:

- Create connection to x league platform i.e.
  - `mfl_connect()`, `sleeper_connect()`, `fleaflicker_connect()`, `espn_connect()`, `yahoo_connect()`
  - Wrap said functions into `ff_connect(platform,leagueID,...)`
- Get raw API endpoint (how do I construct argument calls from dots?)
  - [x] Done for MFL.
  - [] Sleeper next!
- Get league settings (i.e. number of teams, roster spots, starting-positions, number of QBs, IDPs, best ball etc?)
- Get scoring settings (PPR, PP1D, positional-scoring)
- Get franchise data
- Get draft/draft_picks
- Get player data
- Get transaction data
- Get standings data (standings, potential-points, all-play, ?)
- Get raw API endpoint (how do I construct argument calls from dots?)


## Changelog

- 2020-05-18 - initial commit and roadmap generated, add mfl_connect and mfl_endpoint_league functions
- 2020-05-19 - following [httr API vignette](https://httr.r-lib.org/articles/api-packages.html) and created generic call to MFL API via `get_mfl_endpoint()`
- 2020-05-23 - adding rate limiting and beginnings of Sleeper connection code
- 2020-05-27 - adding test folder, renamed main-level functions to "ff_" prefix for ease of autocomplete later
