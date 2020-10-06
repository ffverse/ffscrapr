# ffscrapr (development version)

The main goal of ffscrapr 1.1.0 will be to replicate the features of 1.0.0 but for Sleeper. Some other changes and tweaks will be added eventually!

### Sleeper progress
- Cleaned up `sleeper_connect()` code
- Created a `sleeper_getendpoint()` lower level wrapper - design seems a little awkward ("pass each element of the url to become slash-separated parts of the path") - but will roll forward with it anyway, I think that makes the most sense. 
- Got rid of passing the conn object into `sleeper_getendpoint()` - wasn't really being used, would be used by higher-level functions. May change if cookies etc are used later.
- Added generic and method for `ff_userleagues()` - Sleeper league IDs are more annoying than MFL to handle, so the more intuitive way is to look up the user's league_ids by username. MFL does have a parallel feature even if used for different purposes. 

### New generics
Here is a list of new functions available at the top level (ie for all platforms)
- `ff_userleagues()` returns a list of user leagues. This is deployed slightly differently for MFL and Sleeper - MFL requires authentication to access user's leagues, while Sleeper doesn't have authentication so you can look up any user you like. 

### MFL changes
- Added method for `ff_userleagues()`
- Added handling for offensive_points and defensive_points in `ff_standings()` (#69, nice.)
- Added an `httr::handle_reset()` call to fix login bug.

### Other tweaks
- Now uses {checkmate} for testing.
- Silently swallowing up unused args in mfl_connect and sleeper_connect.

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
