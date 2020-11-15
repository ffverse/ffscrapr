# ffscrapr (development version)

The main goal of ffscrapr 1.1.0 will be to replicate the features of 1.0.0 but for Sleeper. Some other changes and tweaks will be added eventually!

### Sleeper progress
- Cleaned up `sleeper_connect()` code
- Created a `sleeper_getendpoint()` lower level wrapper - design seems a little awkward ("pass each element of the url to become slash-separated parts of the path") - but will roll forward with it anyway, I think that makes the most sense. 
- Got rid of passing the conn object into `sleeper_getendpoint()` - wasn't really being used, would be used by higher-level functions. May change if cookies etc are used later.
- Added generic and method for `ff_userleagues()` - Sleeper league IDs are more annoying than MFL to handle, so the more intuitive way is to look up the user's league_ids by username. MFL does have a parallel feature even if used for different purposes. 
- Added method for `ff_schedule()` (1.0.0.9003)
- Added method for `ff_standings()` (1.0.0.9004)
- Added method for `ff_franchises()` (1.0.0.9005) and added separate testing file.
- Added method for `ff_rosters()` (1.0.0.9006)
- Added method for `ff_draftpicks()` (1.0.0.9007)
- Added warning for `ff_playerscores()` (1.0.0.9008) related to Sleeper deprecating stats endpoint
- Added method for `ff_draft()` (1.0.0.9009)
- Added method for `ff_scoring()` (1.0.0.9010) and a separated test file for scoring.
- Added method for `ff_starters()` (1.0.0.9011) and tests for MFL/Sleeper.
- Added method for `ff_league()` (1.0.0.9012) and tests for sleeper.
- Added method for `ff_transactions()` (1.0.0.9013) and tests for sleeper.

### New generics
Here is a list of new functions available at the top level (ie for all platforms)
- `ff_userleagues()` returns a list of user leagues. This is deployed slightly differently for MFL and Sleeper - MFL requires authentication to access user's leagues, while Sleeper doesn't have authentication so you can look up any user you like. 
- `ff_starters()` returns a list of players started/not-started each week. MFL will return the actual score of each player each week and calculate whether they were optimal, while Sleeper just returns the player themselves. (1.0.0.9011)

### MFL changes
- Added method for `ff_userleagues()`
- Added handling for offensive_points and defensive_points in `ff_standings()` (#69, nice.)
- Added an `httr::handle_reset()` call to fix login bug.
- Added `ff_starters()` (1.0.0.9011) as requested by #76 (thanks, Mike!)

### Other tweaks
- Now uses {checkmate} for testing.
- Silently swallowing up unused args in mfl_connect and sleeper_connect.
- Uses describeIn instead of rdname for method documentation. (1.0.0.9008)

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
