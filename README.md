
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ffscrapr <a href='#'><img src="man/figures/logo.svg" align="right" width="25%" min-width="120px"/></a>

*An R Client for Fantasy Football League APIs*

<!-- badges: start -->

[![CRAN
status](https://img.shields.io/cran/v/ffscrapr?style=flat-square&logo=R&label=CRAN)](https://CRAN.R-project.org/package=ffscrapr)
[![Dev
status](https://img.shields.io/github/r-package/v/ffverse/ffscrapr/main?label=dev&style=flat-square&logo=github)](https://ffscrapr.ffverse.com/dev/)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-green.svg?style=flat-square)](https://lifecycle.r-lib.org/articles/stages.html)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/ffverse/ffscrapr?label=codecov&style=flat-square&logo=codecov)](https://app.codecov.io/gh/ffverse/ffscrapr?branch=main)
[![R build
status](https://img.shields.io/github/actions/workflow/status/ffverse/ffscrapr/R-CMD-check.yaml?label=R%20check&style=flat-square&logo=github)](https://github.com/ffverse/ffscrapr/actions)
[![API
status](https://img.shields.io/github/actions/workflow/status/ffverse/ffscrapr/test-apis.yml?label=API%20check&style=flat-square&logo=github)](https://github.com/ffverse/ffscrapr/actions)
[![nflverse
discord](https://img.shields.io/discord/789805604076126219?color=7289da&label=nflverse%20discord&logo=discord&logoColor=fff&style=flat-square)](https://discord.com/invite/5Er2FBnnQa)

<!-- badges: end -->

Helps access various Fantasy Football APIs (currently MFL, Sleeper,
Fleaflicker, and ESPN - perhaps eventually Yahoo and others) by handling
authentication/rate-limiting/caching, forming appropriate calls, and
returning tidy dataframes which can be easily connected to other data
sources.

### Installation

Install the stable version of this package from CRAN:

``` r
install.packages("ffscrapr")
```

Install the development version from either
[r-universe](https://ffverse.r-universe.dev) or GitHub:

``` r
install.packages("ffscrapr", repos = c("https://ffverse.r-universe.dev", getOption("repos")))

# pak is recommended, see https://github.com/r-lib/pak
pak::pak("ffverse/ffscrapr")

# can also use remotes
remotes::install_github("ffverse/ffscrapr")
```

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
#> tibble [1 × 17] (S3: tbl_df/tbl/data.frame)
#>  $ league_id        : chr "54040"
#>  $ league_name      : chr "The Super Smash Bros Dynasty League"
#>  $ season           : int 2020
#>  $ league_type      : chr NA
#>  $ franchise_count  : num 14
#>  $ qb_type          : chr "1QB"
#>  $ idp              : logi FALSE
#>  $ scoring_flags    : chr "0.5_ppr, TEPrem, PP1D"
#>  $ best_ball        : logi FALSE
#>  $ salary_cap       : logi FALSE
#>  $ player_copies    : num 1
#>  $ years_active     : chr "2018-2021"
#>  $ qb_count         : chr "1"
#>  $ roster_size      : num 33
#>  $ league_depth     : num 462
#>  $ draft_type       : chr " email draft"
#>  $ draft_player_pool: chr "Both"

# Get rosters
ff_rosters(ssb)
#> # A tibble: 417 × 11
#>   franchise_id franchise_name player_id player_name     pos   team    age
#>   <chr>        <chr>          <chr>     <chr>           <chr> <chr> <dbl>
#> 1 0001         Team Pikachu   13189     Engram, Evan    TE    NYG    28.4
#> 2 0001         Team Pikachu   11680     Landry, Jarvis  WR    CLE    30.2
#> 3 0001         Team Pikachu   13645     Smith, Tre'Quan WR    NOS    27.1
#> 4 0001         Team Pikachu   12110     Brate, Cameron  TE    TBB    31.6
#> 5 0001         Team Pikachu   13168     Reynolds, Josh  WR    LAR    28  
#> # … with 412 more rows, and 4 more variables: roster_status <chr>,
#> #   drafted <chr>, draft_year <chr>, draft_round <chr>
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names

# Get transactions
ff_transactions(ssb)
#> # A tibble: 1,145 × 12
#>   timestamp           type  type_desc   franchise_id franchise_name
#>   <dttm>              <chr> <chr>       <chr>        <chr>         
#> 1 2021-02-12 14:32:39 TRADE traded_away 0008         Team Bowser   
#> 2 2021-02-12 14:32:39 TRADE traded_for  0008         Team Bowser   
#> 3 2021-02-12 14:32:39 TRADE traded_for  0008         Team Bowser   
#> 4 2021-02-12 14:32:39 TRADE traded_for  0008         Team Bowser   
#> 5 2021-02-12 14:32:39 TRADE traded_for  0008         Team Bowser   
#> # … with 1,140 more rows, and 7 more variables: player_id <chr>,
#> #   player_name <chr>, pos <chr>, team <chr>, bbid_spent <dbl>,
#> #   trade_partner <chr>, comments <chr>
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
```

Platform-specific guides on getting started with ffscrapr are here:

- [MyFantasyLeague](https://ffscrapr.ffverse.com/articles/mfl_basics.html)  
- [Sleeper](https://ffscrapr.ffverse.com/articles/sleeper_basics.html)
- [Fleaflicker](https://ffscrapr.ffverse.com/articles/fleaflicker_basics.html)
- [ESPN](https://ffscrapr.ffverse.com/articles/espn_basics.html)

There are also some more advanced guides for custom API calls in the
[Articles section](https://ffscrapr.ffverse.com/articles/), as well as
some guides on [optimizing ffscrapr’s
performance](https://ffscrapr.ffverse.com/articles/ffscrapr_caching.html).

### Support

The best places to get help on this package are:

- the [nflverse discord](https://discord.com/invite/5Er2FBnnQa) (for
  both this package as well as anything R/NFL related)
- opening [an
  issue](https://github.com/ffverse/ffscrapr/issues/new/choose)

### Contributing

Many hands make light work! Here are some ways you can contribute to
this project:

- You can [open an
  issue](https://github.com/ffverse/ffscrapr/issues/new/choose) if you’d
  like to request specific data or report a bug/error.

- You can [sponsor this project with
  donations](https://github.com/sponsors/tanho63)!

- If you’d like to contribute code, please check out [the contribution
  guidelines](https://ffscrapr.ffverse.com/CONTRIBUTING.html).

### Terms of Use

The R code for this package is released as open source under the [MIT
license](https://ffscrapr.ffverse.com/LICENSE.html).

The APIs and data accessed by this package belong to their respective
owners, and are governed by their terms of use.
