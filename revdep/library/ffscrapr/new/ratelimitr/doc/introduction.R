## ----ex1-----------------------------------------------------------------
library(ratelimitr)
f <- function() NULL

# create a version of f that can only be called 10 times per second
f_lim <- limit_rate(f, rate(n = 10, period = 1))

# time without limiting
system.time(replicate(11, f()))

# time with limiting
system.time(replicate(11, f_lim()))

## ----ex2-----------------------------------------------------------------
f_lim <- limit_rate(
    f, 
    rate(n = 10, period = .1), 
    rate(n = 50, period = 1)
)

# 10 calls do not trigger the rate limit
system.time( replicate(10, f_lim()) )

# note that reset does not modify its argument, but returns a new
# rate-limited function with a fresh timer
f_lim <- reset(f_lim)
system.time( replicate(11, f_lim()) )

# similarly, 50 calls don't trigger the second rate limit
f_lim <- reset(f_lim)
system.time( replicate(50, f_lim()) )

# but 51 calls do:
f_lim <- reset(f_lim)
system.time( replicate(51, f_lim()) )

## ----multi-fun-ex--------------------------------------------------------
f <- function() "f"
g <- function() "g"
h <- function() "h"

# passing a named list to limit_rate
limited <- limit_rate(
    list(f = f, g = g, h = h), 
    rate(n = 3, period = 1)
)

# now limited is a list of functions that share a rate limit. examples:
limited$f()
limited$g()

## ----echo = FALSE--------------------------------------------------------
Sys.sleep(1)

## ----multi-fun-ex2-------------------------------------------------------
# the first three function calls should not trigger a delay
system.time(
    {limited$f(); limited$g(); limited$h()}
)

limited <- reset(limited)

# but to evaluate a fourth function call, there will be a delay
system.time({
    limited$f()
    limited$g() 
    limited$h() 
    limited$f()
})

