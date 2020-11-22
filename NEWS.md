# ffscrapr (development version)

Fleaflicker looks like it's going to be the next platform. 

Also amassing some tweaks and hotfixes for a patch version (probably with improved vignettes).

### BREAKING CHANGES
- `sleeper_getendpoint()` now behaves more like the other getendpoint functions - first argument is the endpoint and any further args are passed as query parameters. (1.1.0.9003)

### Tweaks to be released with 1next version

- Small copyedits to existing vignettes. (1.1.0.9000)
- Added filesystem cache capabilities and a vignette to detailing how to use it (1.1.0.9001)

### Fleaflicker Progress

- Added `fleaflicker_getendpoint()` (1.1.0.9002)
- Added `ff_connect()` (1.1.0.9002)
- Added `ff_rosters()` (1.1.0.9002)
- Added `ff_userleagues()` - interestingly, has feature for looking up by email but doesn't return actual user ID? (1.1.0.9002)
- Added `fleaflicker_players()` - requires a connection/leagueID by default. (1.1.0.9003)
- Added `ff_scoring()` and tests. (1.1.0.9003)
- Added `ff_schedule()` and tests. (1.1.0.9003)
- Added `ff_franchises()` and tests.
- Added `ff_standings()` and tests.
- Added `ff_league()` and tests.
- Added `ff_playerscores()` and tests. Fleaflicker's API returns season level data easily, week-level is not readily available yet without some workarounds. 
- Added `ff_starters()` and tests.

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
- Added `ff_starters()` (1.0.0.9011) as requested by #76 (thanks, Mike!)
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
