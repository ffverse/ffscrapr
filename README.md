
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ffscrapr <a href='#'><img src='man/figures/logo.png' align="right" height="120" /></a>

*An R Client for Fantasy Football League APIs*

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/ffscrapr)](https://CRAN.R-project.org/package=ffscrapr)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
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

Version 1.0.0 is now on CRAN 🎉 and can be installed with:

``` r
install.packages("ffscrapr")
```

Install the development version from GitHub with:

``` r
# install.packages("devtools") OR install.packages("remotes")
## remotes is a subpackage of devtools
remotes::install_github("dynastyprocess/ffscrapr",ref = "dev")
```

### Usage

All `ffscrapr` functions start with a connection object created by
ff\_connect, which stores connection, authentication, and other
user-defined parameters. This object is used by all other functions to
help return the correct data.

``` r
library(ffscrapr)
ssb <- ff_connect(platform = "mfl", league_id = "54040", season = 2020)

# Get a summary of league settings
ff_league(ssb) %>% str()
#> tibble [1 x 13] (S3: tbl_df/tbl/data.frame)
#>  $ league_id      : chr "54040"
#>  $ league_name    : chr "The Super Smash Bros Dynasty League"
#>  $ franchise_count: num 14
#>  $ qb_type        : chr "1QB"
#>  $ idp            : logi FALSE
#>  $ scoring_flags  : chr "0.5_ppr, TEPrem, PP1D"
#>  $ best_ball      : logi TRUE
#>  $ salary_cap     : logi FALSE
#>  $ player_copies  : num 1
#>  $ years_active   : chr "2018-2020"
#>  $ qb_count       : chr "1"
#>  $ roster_size    : num 35
#>  $ league_depth   : num 490

# Get rosters
ff_rosters(ssb)
#> # A tibble: 446 x 11
#>    franchise_id franchise_name player_id player_name pos   team    age
#>    <chr>        <chr>          <chr>     <chr>       <chr> <chr> <dbl>
#>  1 0001         Team Pikachu   13129     Fournette,~ RB    JAC    25.6
#>  2 0001         Team Pikachu   13189     Engram, Ev~ TE    NYG    26  
#>  3 0001         Team Pikachu   11680     Landry, Ja~ WR    CLE    27.7
#>  4 0001         Team Pikachu   13290     Cohen, Tar~ RB    CHI    25.1
#>  5 0001         Team Pikachu   13155     Ross, John  WR    CIN    24.7
#>  6 0001         Team Pikachu   13158     Westbrook,~ WR    JAC    26.7
#>  7 0001         Team Pikachu   10273     Newton, Cam QB    NEP    31.3
#>  8 0001         Team Pikachu   14085     Pollard, T~ RB    DAL    23.3
#>  9 0001         Team Pikachu   13139     Williams, ~ RB    GBP    25.4
#> 10 0001         Team Pikachu   13649     Hamilton, ~ WR    DEN    25.4
#> # ... with 436 more rows, and 4 more variables: roster_status <chr>,
#> #   drafted <chr>, draft_year <chr>, draft_round <chr>

# Get transactions
ff_transactions(ssb)
#> # A tibble: 189 x 12
#>    timestamp           type  type_desc franchise_id franchise_name player_id
#>    <dttm>              <chr> <chr>     <chr>        <chr>          <chr>    
#>  1 2020-08-16 23:51:55 FREE~ dropped   0007         Team Kirby     11529    
#>  2 2020-08-16 23:51:55 FREE~ dropped   0007         Team Kirby     13136    
#>  3 2020-08-15 19:11:44 FREE~ dropped   0007         Team Kirby     14464    
#>  4 2020-08-15 19:11:44 FREE~ dropped   0007         Team Kirby     13144    
#>  5 2020-08-14 09:03:33 IR    deactiva~ 0002         Team Simon Be~ 14093    
#>  6 2020-08-14 09:02:50 FREE~ dropped   0002         Team Simon Be~ 12615    
#>  7 2020-08-10 16:32:55 FREE~ dropped   0013         Team Ness      11925    
#>  8 2020-08-10 16:31:43 FREE~ dropped   0013         Team Ness      12648    
#>  9 2020-08-07 20:38:52 IR    activated 0007         Team Kirby     13871    
#> 10 2020-08-06 17:01:09 IR    deactiva~ 0003         Team Captain ~ 10737    
#> # ... with 179 more rows, and 6 more variables: player_name <chr>, pos <chr>,
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
    guidelines](https://ffscrapr.dynastyprocess.com/CONTRIBUTING.html).

### Terms of Use

The R code for this package is released as open source under the [MIT
license](https://ffscrapr.dynastyprocess.com/LICENSE.html).

The APIs and data accessed by this package belong to their respective
owners, and are governed by their terms of use.
