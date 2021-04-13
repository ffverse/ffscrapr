
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ffscrapr <a href='#'><img src="man/figures/logo.png" align="right" height="200"/></a>

*An R Client for Fantasy Football League APIs*

<!-- badges: start -->

[![CRAN
status](https://img.shields.io/cran/v/ffscrapr?style=flat-square&logo=R&label=CRAN)](https://CRAN.R-project.org/package=ffscrapr)
[![Dev
status](https://img.shields.io/github/r-package/v/dynastyprocess/ffscrapr/dev?label=dev&style=flat-square&logo=github)](https://ffscrapr.dynastyprocess.com/dev/)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-green.svg?style=flat-square)](https://lifecycle.r-lib.org/articles/stages.html)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/dynastyprocess/ffscrapr?label=codecov&style=flat-square&logo=codecov)](https://codecov.io/gh/DynastyProcess/ffscrapr?branch=main)
[![R build
status](https://img.shields.io/github/workflow/status/dynastyprocess/ffscrapr/R-CMD-check?label=R%20check&style=flat-square&logo=github)](https://github.com/DynastyProcess/ffscrapr/actions)
[![API
status](https://img.shields.io/github/workflow/status/dynastyprocess/ffscrapr/Test%20APIs?label=API%20check&style=flat-square&logo=github)](https://github.com/DynastyProcess/ffscrapr/actions)

<!-- badges: end -->

Helps access various Fantasy Football APIs (currently MFL, Sleeper,
Fleaflicker, and ESPN - eventually Yahoo, potentially others) by
handling authentication/rate-limiting/caching, forming appropriate
calls, and returning tidy dataframes which can be easily connected to
other data sources.

### Installation

Version 1.4.0 is now on CRAN :tada: and can be installed with:

``` r
install.packages("ffscrapr")
# or from GitHub release with the remotes package via:
# install.packages("remotes")
remotes::install_github("dynastyprocess/ffscrapr", ref = "v1.4.0")
```

Install the development version from GitHub with:

``` r
remotes::install_github("dynastyprocess/ffscrapr", ref = "dev")
```

The dev version has a [separate documentation site
here](https://ffscrapr.dynastyprocess.com/dev/).

### Usage

All `ffscrapr` functions start with a connection object created by
`ff_connect()`, which stores connection, authentication, and other
user-defined parameters. This object is used by all other functions to
help return the correct data.

``` r
library(ffscrapr)
ssb <- ff_connect(platform = "mfl", league_id = "54040", season = 2020)

# Get a summary of league settings
ff_league(ssb) %>% str()
#> Using request.R from "ffscrapr"
#> No encoding supplied: defaulting to UTF-8.
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
#>  $ roster_size    : num 28
#>  $ league_depth   : num 392

# Get rosters
ff_rosters(ssb)
#> # A tibble: 443 x 11
#>   franchise_id franchise_name player_id player_name     pos   team    age
#>   <chr>        <chr>          <chr>     <chr>           <chr> <chr> <dbl>
#> 1 0001         Team Pikachu   13189     Engram, Evan    TE    NYG    26.6
#> 2 0001         Team Pikachu   11680     Landry, Jarvis  WR    CLE    28.4
#> 3 0001         Team Pikachu   13645     Smith, Tre'Quan WR    NOS    25.3
#> 4 0001         Team Pikachu   12110     Brate, Cameron  TE    TBB    29.8
#> 5 0001         Team Pikachu   13168     Reynolds, Josh  WR    LAR    26.2
#> # ... with 438 more rows, and 4 more variables: roster_status <chr>,
#> #   drafted <chr>, draft_year <chr>, draft_round <chr>

# Get transactions
ff_transactions(ssb)
#> # A tibble: 152 x 12
#>   timestamp           type       type_desc franchise_id franchise_name   
#>   <dttm>              <chr>      <chr>     <chr>        <chr>            
#> 1 2020-07-09 17:25:20 FREE_AGENT dropped   0004         Team Ice Climbers
#> 2 2020-07-09 17:25:20 FREE_AGENT dropped   0004         Team Ice Climbers
#> 3 2020-06-16 01:56:49 TAXI       promoted  0014         Team Luigi       
#> 4 2020-06-16 01:56:49 TAXI       demoted   0014         Team Luigi       
#> 5 2020-06-12 23:51:44 FREE_AGENT dropped   0010         Team Yoshi       
#> # ... with 147 more rows, and 7 more variables: player_id <chr>,
#> #   player_name <chr>, pos <chr>, team <chr>, bbid_spent <dbl>,
#> #   trade_partner <chr>, comments <chr>
```

Platform-specific guides on getting started with ffscrapr are here:

-   [MyFantasyLeague](https://ffscrapr.dynastyprocess.com/articles/mfl_basics.html)  
-   [Sleeper](https://ffscrapr.dynastyprocess.com/articles/sleeper_basics.html)
-   [Fleaflicker](https://ffscrapr.dynastyprocess.com/articles/fleaflicker_basics.html)
-   [ESPN](https://ffscrapr.dynastyprocess.com/articles/espn_basics.html)

There are also some more advanced guides for custom API calls in the
[Articles section](https://ffscrapr.dynastyprocess.com/articles/), as
well as some guides on [optimizing ffscrapr’s
performance](https://ffscrapr.dynastyprocess.com/articles/ffscrapr_caching.html).

### Contributing

Many hands make light work! Here are some ways you can contribute to
this project:

-   You can [open an
    issue](https://github.com/DynastyProcess/ffscrapr/issues/new/choose)
    if you’d like to request specific data or report a bug/error.

-   You can [sponsor this project with
    donations](https://github.com/sponsors/tanho63)!

-   If you’d like to contribute code, please check out [the contribution
    guidelines](https://ffscrapr.dynastyprocess.com/CONTRIBUTING.html).

### Terms of Use

The R code for this package is released as open source under the [MIT
license](https://ffscrapr.dynastyprocess.com/LICENSE.html).

The APIs and data accessed by this package belong to their respective
owners, and are governed by their terms of use.
