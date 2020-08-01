
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ffscrapr <a href='ffscrapr.dynastyprocess.com'><img src='man/figures/logo.png' align="right" height="120" /></a>

*An R Client for Fantasy Football League APIs*

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/DynastyProcess/ffscrapr/branch/main/graph/badge.svg)](https://codecov.io/gh/DynastyProcess/ffscrapr?branch=main)
[![R build
status](https://github.com/DynastyProcess/ffscrapr/workflows/R-CMD-check/badge.svg)](https://github.com/DynastyProcess/ffscrapr/actions)

<!-- badges: end -->

Helps access various Fantasy Football APIs (i.e. MFL, Sleeper,
Fleaflicker, ESPN, Yahoo, potentially other platforms) by handling
authentication and rate-limiting, forming appropriate calls, and
returning tidy dataframes which can be easily connected to other data
sources.

### Installation

Install from GitHub with:

``` r
# install.packages("devtools") OR install.packages("remotes")
## remotes is a subpackage of devtools
remotes::install_github("dynastyprocess/ffscrapr")
```

### Usage

All `ffscrapr` functions start with a connection object created by
ff\_connect, which stores connection, authentication, and other
user-defined parameters. This object is used by all other functions to
help return the correct data.

``` r
library(ffscrapr)

ssb <- ff_connect(platform = "mfl", league_id = "54040")
#> No season supplied - choosing 2020 based on system date.

# Get a summary of league settings
ff_league(ssb)
#> # A tibble: 1 x 13
#>   league_id league_name franchise_count qb_type idp   scoring_flags best_ball
#>   <chr>     <chr>                 <dbl> <chr>   <lgl> <chr>         <lgl>    
#> 1 54040     The Super ~              14 1QB     FALSE 0.5_ppr, TEP~ TRUE     
#> # ... with 6 more variables: salary_cap <lgl>, player_copies <dbl>,
#> #   years_active <chr>, qb_count <chr>, roster_size <dbl>, league_depth <dbl>

# Get transactions
ff_transactions(ssb)
#> # A tibble: 172 x 12
#>    timestamp           type  type_desc franchise_id franchise_name player_id
#>    <dttm>              <chr> <chr>     <chr>        <chr>          <chr>    
#>  1 2020-07-31 16:19:51 IR    deactiva~ 0004         Team Ice Clim~ 11688    
#>  2 2020-07-31 16:19:51 IR    deactiva~ 0004         Team Ice Clim~ 13277    
#>  3 2020-07-31 16:19:51 IR    deactiva~ 0004         Team Ice Clim~ 12667    
#>  4 2020-07-31 16:16:36 IR    deactiva~ 0013         Team Ness      14140    
#>  5 2020-07-31 16:00:00 BBID~ dropped   0004         Team Ice Clim~ 13190    
#>  6 2020-07-31 16:00:00 BBID~ added     0007         Team Kirby     14129    
#>  7 2020-07-31 16:00:00 BBID~ added     0004         Team Ice Clim~ 14333    
#>  8 2020-07-31 16:00:00 BBID~ added     0014         Team Luigi     12164    
#>  9 2020-07-31 16:00:00 BBID~ added     0014         Team Luigi     10297    
#> 10 2020-07-31 16:00:00 BBID~ added     0013         Team Ness      7813     
#> # ... with 162 more rows, and 6 more variables: player_name <chr>, pos <chr>,
#> #   team <chr>, bbid_spent <dbl>, trade_partner <chr>, comments <chr>
```

For a more detailed usage example, including a template dynasty league
analysis script, please check out the reference articles and/or
vignettes\!

### Contributing

Many hands make light work\! Here are some ways you can contribute to
this project:

  - You can [open an
    issue](https://github.com/DynastyProcess/ffscrapr/issues/new/choose)
    if you’d like to request specific data or report a bug/error.

  - You can [sponsor this project by donating to help with server
    costs](https://github.com/sponsors/tanho63)\!

  - If you’d like to contribute code, please check out [the contribution
    guidelines](CONTRIBUTING.md).
