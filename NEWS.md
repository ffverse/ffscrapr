# ffscrapr (development version)

- Force MFL playerscores to use season + league specific players call where possible (Fixes #239) (v1.3.0.02)
- Reduce minimum rows for flea rosters test to 200, which fixes an API check issue (v1.3.0.03)
- Fixes CRAN check issue where digest is no longer imported by memoise - switched cache package to cachem which is apparently just better designed. Resolves #244 (v1.3.0.04)
- Eliminate LazyData to silence CRAN note. Resolves #244 (v1.3.0.04)
- Fix sleeper transactions issue where it was not handling multiple dropped players in one transaction. Resolves #246 (v1.3.0.05)
- Add `ff_scoringhistory()`  for MFL to pull scoring history back to 1999 using [nflfastR](https://www.nflfastr.com/reference/load_player_stats.html) `load_player_stats()` function. (v1.3.0.06)
- Add `ff_scoringhistory()` for Fleaflicker (v1.3.0.07)
- Add `ff_scoringhistory()` and breakout `ff_scoring()` by position for Sleeper (v1.3.0.08)
- Add `ff_scoringhistory()` and breakout `ff_scoring()` by position (Breaking Change) for ESPN (v1.3.0.09)
---

# ffscrapr 1.3.0

The main goal of ffscrapr 1.3.0 is to add support for the ESPN platform. It also includes several bug fixes, code quality improvements, and a major refactor of tests to reduce overall package size. 

A huge thank-you goes to [Tony ElHabr](https://twitter.com/TonyElHabr) for his contributions to the package for the ESPN methods.

### Breaking Changes

- `custom_players` arguments are deprecated for MFL - it will now return them by default. 

### ESPN Details
 
ESPN is a tricky and undocumented API. Private leagues are accessible if you use the SWID/ESPN_S2 authentication arguments, which are a lot like API keys - see the ESPN authentication vignette.

Unsupported functions: 

- `ff_draftpicks()` - this does not apply to ESPN primarily because it does not support draft pick trades. 
- `ff_userleagues()` - ESPN does not support looking up user's leagues, even when authenticated
- Username and password features - ESPN used to have a way to authenticate via username/password, but this has been recently [made more difficult](https://github.com/cwendt94/espn-api/discussions/128). It is an area that can be revisited if/when the Python package manages it, but at this time will only be accessible with the SWID/ESPN_S2 keys. 

### New Functions

- `dp_cleannames()` is a utility function for cleaning player names that removes common suffixes, periods, and apostrophes.
- `espn_potentialpoints()` calculates the optimal lineup for each week. This is 

### Minor patches

- Converted GET requests to use `httr::RETRY` instead - this adds some robustness for server-side issues. As suggested by Maelle Salmon's blog post on [not reinventing the wheel](https://blog.r-hub.io/2020/04/07/retry-wheel/).
- Added some type conversions and renaming for snake_case consistency to mfl_rosters and mfl_playerscores
- Fixed bug in MFL's `ff_playerscores()` function so that it correctly pulls older names. (Resolves #196)
- Refactored all tests to move test cache files to a separate/non-package location (https://github.com/dynastyprocess/ffscrapr-tests) - so that it is not included in CRAN's package sizing
- Fixed bugs in MFL's `ff_starters()` function - bad default arg, bad players call. (Fixes #202)
- Resolve MFL's playerscores to handle vectorized request (Fixes #206)
- Resolve bugs related to .fn_choose_season for tests (Fixes #217, #219)
- Resolved bug in MFL's `ff_rosters()` by adding a week parameter (Fixes #215)
- Coerced `ff_transactions()` bid_amount into a numeric (Fixes #210)
- Removed bye franchises from `ff_starters()` (Fixes #212)

---

# ffscrapr 1.2.2

Minor patches to dp_import functions to address issues discovered by CRAN checks. 

~~Also adds minor helper function, `dp_cleannames()`, which is a utility function for cleaning player names that removes common suffixes, periods, and apostrophes.~~ 

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
