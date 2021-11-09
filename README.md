
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ffscrapr <a href='#'><img src="man/figures/logo.svg" align="right" width="25%" min-width="120px"/></a>

*An R Client for Fantasy Football League APIs*

<!-- badges: start -->

[![CRAN
status](https://img.shields.io/cran/v/ffscrapr?style=flat-square&logo=R&label=CRAN)](https://CRAN.R-project.org/package=ffscrapr)
[![Dev
status](https://img.shields.io/github/r-package/v/ffverse/ffscrapr/dev?label=dev&style=flat-square&logo=github)](https://ffscrapr.ffverse.com/dev/)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-green.svg?style=flat-square)](https://lifecycle.r-lib.org/articles/stages.html)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/ffverse/ffscrapr?label=codecov&style=flat-square&logo=codecov)](https://app.codecov.io/gh/ffverse/ffscrapr?branch=main)
[![R build
status](https://img.shields.io/github/workflow/status/ffverse/ffscrapr/R-CMD-check?label=R%20check&style=flat-square&logo=github)](https://github.com/ffverse/ffscrapr/actions)
[![API
status](https://img.shields.io/github/workflow/status/ffverse/ffscrapr/Test%20APIs?label=API%20check&style=flat-square&logo=github)](https://github.com/ffverse/ffscrapr/actions)
[![nflverse
discord](https://img.shields.io/discord/789805604076126219?color=7289da&label=nflverse%20discord&logo=discord&logoColor=fff&style=flat-square)](https://discord.com/invite/5Er2FBnnQa)

<!-- badges: end -->

Helps access various Fantasy Football APIs (currently MFL, Sleeper,
Fleaflicker, and ESPN - eventually Yahoo, potentially others) by
handling authentication/rate-limiting/caching, forming appropriate
calls, and returning tidy dataframes which can be easily connected to
other data sources.

### Installation

Install the stable version of this package from CRAN or the [ffverse
r-universe repository](https://ffverse.r-universe.dev):

``` r
install.packages("ffscrapr") # CRAN
install.packages("ffscrapr", repos = "https://ffverse.r-universe.dev")
```

Install the development version from GitHub with:

``` r
remotes::install_github("ffverse/ffscrapr", ref = "dev")
```

The dev version has a [separate documentation site
here](https://ffscrapr.ffverse.com/dev/).

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

# Get rosters
ff_rosters(ssb)

# Get transactions
ff_transactions(ssb)
```

Platform-specific guides on getting started with ffscrapr are here:

-   [MyFantasyLeague](https://ffscrapr.ffverse.com/articles/mfl_basics.html)  
-   [Sleeper](https://ffscrapr.ffverse.com/articles/sleeper_basics.html)
-   [Fleaflicker](https://ffscrapr.ffverse.com/articles/fleaflicker_basics.html)
-   [ESPN](https://ffscrapr.ffverse.com/articles/espn_basics.html)

There are also some more advanced guides for custom API calls in the
[Articles section](https://ffscrapr.ffverse.com/articles/), as well as
some guides on [optimizing ffscrapr’s
performance](https://ffscrapr.ffverse.com/articles/ffscrapr_caching.html).

### Support

The best places to get help on this package are:

-   the [nflverse discord](https://discord.com/invite/5Er2FBnnQa) (for
    both this package as well as anything R/NFL related)
-   opening [an
    issue](https://github.com/ffverse/ffscrapr/issues/new/choose)

### Contributing

Many hands make light work! Here are some ways you can contribute to
this project:

-   You can [open an
    issue](https://github.com/ffverse/ffscrapr/issues/new/choose) if
    you’d like to request specific data or report a bug/error.

-   You can [sponsor this project with
    donations](https://github.com/sponsors/tanho63)!

-   If you’d like to contribute code, please check out [the contribution
    guidelines](https://ffscrapr.ffverse.com/CONTRIBUTING.html).

### Terms of Use

The R code for this package is released as open source under the [MIT
license](https://ffscrapr.ffverse.com/LICENSE.html).

The APIs and data accessed by this package belong to their respective
owners, and are governed by their terms of use.
