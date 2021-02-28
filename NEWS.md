# ffscrapr (development version)

### ESPN Progress

-   `espn_connect()`/`ff_connect()`: implemented with SWID/ESPN_S2 arguments, which act a lot like the API keys. Will need vignettes or demos to help users find these. Python package has [not yet found a way](https://github.com/cwendt94/espn-api/discussions/128) to make username/password work yet - this is annoying and I'll let them tackle it since I'd rather just build out the R functionality first. (v1.2.1.2)
-   Fixed cookie-based authentication from connect and added `espn_getendpoint()` low-level function (v1.2.1.3)
-   Added warning for `ff_draftpicks()` - ESPN does not support draft pick trades (v1.2.1.4)
-   Added `ff_league()` method for ESPN connection. (v1.2.1.5) (Thanks, @TonyElHabr!)
-   Added warning for `ff_userleagues()` - ESPN does not support looking up user leagues (v1.2.1.6)
-   Edited `espn_getendpoint()` lower-level function to take a json-formatted `x_fantasy_filter` argument which is passed in as a request header. This helps filter and sort the response, somewhat. (v1.2.1.7)
-   Added `espn_players()`, which returns just the name/team/positions/IDs. Rankings and player scores should be returned from a different function. (v1.2.1.7)
-   Added `ff_franchises()` method for ESPN. (v1.2.1.8)
-   Added `ff_draft()` method for ESPN - hopefully covers auction/keeper as well as regular drafts. (v1.2.1.9)
-   Added `ff_rosters()` method for ESPN (v1.2.2.14)
-   Added `ff_scoring()` method for ESPN (v1.2.2.16)
-   Added `ff_standings()` method for ESPN (v1.2.2.17)

### Minor patches

- Converted GET requests to use `httr::RETRY` instead - this adds some robustness for server-side issues. As suggested by Maelle Salmon's blog post on [not reinventing the wheel](https://blog.r-hub.io/2020/04/07/retry-wheel/). (v1.2.1.1)
- Documentation and vignette updates/tweaks (v1.2.1.1)
- Added some type conversions and renaming for snake_case consistency to mfl_rosters and mfl_playerscores (v1.2.1.2)
- Added `dp_cleannames()`, a utility function for cleaning player names that removes common suffixes, periods, and apostrophes. (v1.2.1.9)
- Fixed bug in MFL's `ff_playerscores()` function so that it correctly pulls older names. (Resolves #196) (v1.2.2.11)
- Actually export `dp_cleannames()` and add it to the NAMESPACE so it's accessible to the end user, whoops.
- Refactored all tests to move test cache files to a separate/non-package location (https://github.com/dynastyprocess/ffscrapr-tests) - so that it is not included in CRAN's package sizing (v1.2.2.12)
- Fixed bugs in MFL's `ff_starters()` function - bad default arg, bad players call. (Fixes #202) (v1.2.2.14)
- Resolve MFL's playerscores to handle vectorized request (Fixes #206) (v1.2.2.15)


---

# ffscrapr 1.2.2

Minor patches to dp_import functions to address issues discovered by CRAN checks. 

~~Also adds minor helper function, `dp_cleannames()`, which is a utility function for cleaning player names that removes common suffixes, preiods, and apostrophes.~~ 

Messed up the export here, whoops. Fixing for next release.

### Minor patches
-  Refactored `dp_values()` and `dp_playerids()` functions to use httr backend for compat with httptest, preventing CRAN errors.
- Added inst-level redactor for httptest. 

---

# ffscrapr 1.2.1

### Minor patches

-   Caching vignette outputs in tests/testthat to making vignette-rebuilding less internet reliant
-   Changing the league_id output of `sleeper_userleagues` to be a character column (because of cran no-longdouble support)

---

# ffscrapr 1.2.0

The main goal of ffscrapr 1.2.0 is to add a full set of methods for Fleaflicker. This release also adds improved caching options, including writing to your filesystem for persistent caching (see the vignette!), and one hotfix for sleeper_getendpoint.

### BREAKING CHANGES

-   `sleeper_getendpoint()` now behaves more like the other getendpoint functions - first argument is the endpoint and any further args are passed as query parameters.

### Other tweaks to existing platforms/methods

-   Small copyedits to existing vignettes.
-   Added filesystem cache capabilities and a vignette to detailing how to use it.

### Fleaflicker notes

All functions now have Fleaflicker methods! Here are notes about what ***isn't*** the same:

-   `fleaflicker_players()` requires a connection/leagueID by default - acts a little oddly on game days as of right now.
-   `ff_playerscores()` - Fleaflicker's API returns season level data easily, week-level is not readily available yet without some workarounds. Everything else seems to be okay.

---

# ffscrapr 1.1.0

The main goal of ffscrapr 1.1.0 is to add a full set of methods for Sleeper. Also adds two new generics: `ff_userleagues()` and `ff_starters()`.

### New generic functions

Here is a list of new functions available at the top level (ie for all platforms)

-   `ff_userleagues()` returns a list of user leagues. This is deployed slightly differently for MFL and Sleeper - MFL requires authentication to access user's leagues, while Sleeper doesn't have authentication so you can look up any user you like.
-   `ff_starters()` returns a list of players started/not-started each week. MFL will return the actual score of each player each week and calculate whether they were optimal, while Sleeper just returns the player themselves.

### Sleeper notes

Almost all functions now have Sleeper methods - implemented in what hopes to be relatively familiar manner to MFL. Outlining the specifics of what ***isn't*** the same:

-   `sleeper_userleagues()` is a wrapper on `ff_userleagues()` that makes it easier to look up user leagues without first creating a connection object.
-   `ff_playerscores()` is not available for Sleeper because Sleeper removed the player stats endpoint - it will generate a warning (rather than an error). Thinking about creating some functions to calculate scoring based on [nflfastr](https://www.nflfastr.com).
-   `sleeper_getendpoint()` is a little more simple than MFL's equivalent - just pass a string url (minus api.sleeper.app/v1) or pass in chunks of code, the function will automatically paste them together with "/".
-   Added generic and method for `ff_userleagues()` - Sleeper league IDs are more annoying than MFL to handle, so the more intuitive way is to look up the user's league_ids by username first. MFL does have a parallel feature even if used for different purposes.
-   Added two vignettes, showing "Getting Started" as well as one for custom API calls

### MFL changes

-   Added method for `ff_userleagues()`
-   Added handling for offensive_points and defensive_points in `ff_standings()` (\#69, nice.)
-   Added `ff_starters()` as requested by \#76 (thanks, Mike!)
-   Added an `httr::handle_reset()` call to fix login-caching bug.
-   Polished vignettes a little.

### Other release tweaks in 1.1.0

-   Now uses {checkmate} for testing.
-   Silently swallowing up unused args in mfl_connect and sleeper_connect.
-   Uses describeIn instead of rdname for method documentation.
-   Wrap all documentation examples in donttest - ratelimiting AND running in under 5 seconds each is pretty challenging!

---

# ffscrapr 1.0.0

This is the first (major) version of ffscrapr and it is intended to build out the full set of functions for the first API platform: MFL.

Future versions will add more platforms via methods mapped to the same functions.

Functions include: 

- `ff_connect` (and sibling `mfl_connect`) to establish connection parameters and ratelimiting 
- `mfl_getendpoint` as a low-level function for making GET requests from MFL 
- `ff_draft` gets draft results 
- `ff_draftpicks` gets current and future draft picks that have not yet been selected 
- `ff_franchises` gets franchise-level identifiers and divisions 
- `ff_league` gets league-level summaries of rules, players, and franchises 
- `ff_playerscores` gets playerweek-level scores 
- `ff_rosters` gets franchise-level rosters complete with naming 
- `ff_schedule` gets weekly fantasy schedules 
- `ff_scoring` gets scoring rules 
- `ff_standings` gets league-level season summaries 
- `ff_transactions` gets a list of all transactions and cleans them into a data frame.
