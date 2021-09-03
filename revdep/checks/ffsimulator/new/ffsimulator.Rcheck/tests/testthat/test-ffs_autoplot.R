
test_that("autoplot works", {

  foureight_sim <- readRDS(system.file("cache/foureight_sim.rds", package = "ffsimulator"))

  wins <- plot(foureight_sim, type = "win")
  rank <- plot(foureight_sim, type = "rank")
  points <- plot(foureight_sim, type = "points")

  vdiffr::expect_doppelganger("wins plot", wins)
  vdiffr::expect_doppelganger("rank plot", rank)
  vdiffr::expect_doppelganger("points plot", points)
})
