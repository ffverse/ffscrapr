# ratelimitr 0.4.1

* update maintainer email address

# ratelimitr 0.4.0

* added the method UPDATE_RATE to modify existing rate-limited functions in place. 

# ratelimitr 0.3.8

* ratelimitr now measures time from just after prior function executions, rather than just before. This allows rate limits to be obeyed even in the presence of network latency (see #14). Thanks to @stephlocke.
* Due to inherent imprecision of `Sys.sleep`, there were rare occasions where rate-limited functions displayed unexpected and wrong behavior (see #12 and #13). In order to fix the problem, rate-limited functions now wait at least .02 seconds longer than necessary.
* Use `proc.time` instead of `Sys.time` to measure time (for increased precision).

# ratelimitr 0.3.7

* Edit unit tests so that tests relying on microbenchmark ("Suggests") are conditional on microbenchmark's presence

# ratelimitr 0.3.6

* Added a `NEWS.md` file to track changes to the package.
* First release on CRAN
