# ffscrapr 1.2.1

### Minor patches
- Caching vignette outputs in tests/testthat to making vignette-rebuilding less internet reliant
- Changing the league_id output of `sleeper_userleagues` to be a character column (because of cran no-longdouble support)

# ffscrapr 1.2.0

The main goal of ffscrapr 1.2.0 is to add a full set of methods for Fleaflicker. This release also adds improved caching options, including writing to your filesystem for persistent caching (see the vignette!), and one hotfix for sleeper_getendpoint.

### BREAKING CHANGES
- `sleeper_getendpoint()` now behaves more like the other getendpoint functions - first argument is the endpoint and any further args are passed as query parameters.

### Other tweaks to existing platforms/methods

- Small copyedits to existing vignettes.
- Added filesystem cache capabilities and a vignette to detailing how to use it.

### Fleaflicker notes

All functions now have Fleaflicker methods! Here are notes about what ***isn't*** the same: 

- `fleaflicker_players()` requires a connection/leagueID by default - acts a little oddly on game days as of right now. 
- `ff_playerscores()` - Fleaflicker's API returns season level data easily, week-level is not readily available yet without some workarounds. 
Everything else seems to be okay. 

# ffscrapr 1.1.0

The main goal of ffscrapr 1.1.0 is to add a full set of methods for Sleeper. Also adds two new generics: `ff_userleagues()` and `ff_starters()`. 

### New generic functions
Here is a list of new functions available at the top level (ie for all platforms)

- `ff_userleagues()` returns a list of user leagues. This is deployed slightly differently for MFL and Sleeper - MFL requires authentication to access user's leagues, while Sleeper doesn't have authentication so you can look up any user you like. 
- `ff_starters()` returns a list of players started/not-started each week. MFL will return the actual score of each player each week and calculate whether they were optimal, while Sleeper just returns the player themselves. 

### Sleeper notes

Almost all functions now have Sleeper methods - implemented in what hopes to be relatively familiar manner to MFL. Outlining the specifics of what ***isn't*** the same:

- `sleeper_userleagues()` is a wrapper on `ff_userleagues()` that makes it easier to look up user leagues without first creating a connection object.
- `ff_playerscores()` is not available for Sleeper because Sleeper removed the player stats endpoint - it will generate a warning (rather than an error). Thinking about creating some functions to calculate scoring based on [nflfastr](https://www.nflfastr.com).
- `sleeper_getendpoint()` is a little more simple than MFL's equivalent - just pass a string url (minus api.sleeper.app/v1) or pass in chunks of code, the function will automatically paste them together with "/". 
- Added generic and method for `ff_userleagues()` - Sleeper league IDs are more annoying than MFL to handle, so the more intuitive way is to look up the user's league_ids by username first. MFL does have a parallel feature even if used for different purposes. 
- Added two vignettes, showing "Getting Started" as well as one for custom API calls

### MFL changes
- Added method for `ff_userleagues()`
- Added handling for offensive_points and defensive_points in `ff_standings()` (#69, nice.)
- Added `ff_starters()` as requested by #76 (thanks, Mike!)
- Added an `httr::handle_reset()` call to fix login-caching bug.
- Polished vignettes a little.

### Other release tweaks in 1.1.0
- Now uses {checkmate} for testing.
- Silently swallowing up unused args in mfl_connect and sleeper_connect.
- Uses describeIn instead of rdname for method documentation.
- Wrap all documentation examples in donttest - ratelimiting AND running in under 5 seconds each is pretty challenging!

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
