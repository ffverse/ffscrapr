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
