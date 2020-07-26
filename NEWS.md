# ffscrapr (development version)

- 2020-05-18 - initial commit and roadmap generated, add mfl_connect and mfl_endpoint_league functions
- 2020-05-19 - following [httr API vignette](https://httr.r-lib.org/articles/api-packages.html) and created generic call to MFL API via `get_mfl_endpoint()`
- 2020-05-23 - adding rate limiting and beginnings of Sleeper connection code
- 2020-05-27 - adding test folder, renamed main-level functions to "ff_" prefix for ease of autocomplete later
- 2020-05-30 - add start of league summary code
- 2020-06-07 - taking a big whack at testing stuff
- 2020-06-08 - add pkgdown site
- 2020-06-13 - switch to S3 methods and add memoise
- 2020-06-21 - add ff_rosters and ff_franchises
- 2020-07-10 - add ff_draft
- 2020-07-16 - add dynastyprocess helpers
- 2020-07-26 - add ff_playerscores
