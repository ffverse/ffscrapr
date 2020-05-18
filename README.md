# fantasyscrapr
*An R Interface for Fantasy Football League APIs*

The goal of this package is to abstract the code required to call various Fantasy APIs (i.e. MFL, Sleeper, Fleaflicker, ESPN, Yahoo, potentially other platforms) and create methods that handle any authentication required, forms appropriate calls, and returns tidy and predictable data which can be easily connected to DynastyProcess (and FantasyPros) information.

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
2020-05-18 - initial commit and roadmap generated
