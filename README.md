# fantasyscrapr
*An R Interface for Fantasy Football League APIs*

The goal of this package is to abstract the code required to call various Fantasy APIs (i.e. MFL, Sleeper, Fleaflicker, ESPN, Yahoo, potentially other platforms) and create methods that return tidy and predictable data. This package is designed to make it easier to build league-analysis scripts by making it easier to connect roster data to DynastyProcess/FantasyPros etc.

## Installation
Install from GitHub with:
``` r
# install.packages("devtools") OR install.packages("remotes") ## remotes is a subpackage of devtools
remotes::install_github("dynastyprocess/fantasyscrapr")
```

## Functions List
Loose roadmap:
- Create connection to x league platform
- Get league settings
- Get franchise data
- Get player data
- Get transaction data
- Get standings data (standings, potential-points, all-play, ?)

## Changelog
2020-05-18 - initial commit and roadmap
