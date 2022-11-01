test_that("ff_scoringhistory returns a tibble of player scores", {
  local_mock_api()

  if (!identical(Sys.getenv("MOCK_BYPASS"), "true")) {
    testthat::local_mock(
      nflfastr_weekly = function(seasons, type) {
        if(type == "offense") return(readRDS(file.path(cache_path, "gh_nflfastr/player_stats.rds")))
        if(type == "kicking") return(readRDS(file.path(cache_path, "gh_nflfastr/kicker_stats.rds")))
        },
      nflfastr_rosters = function(seasons) {
        purrr::map_df(seasons, ~ readRDS(file.path(cache_path, glue::glue("gh_nflfastr/roster_{.x}.rds"))))
      }
    )
  }

  sfb_conn <- mfl_connect(2020, 65443)
  sfb_scoringhistory <- ff_scoringhistory(sfb_conn, 2019:2020)
  expect_tibble(sfb_scoringhistory, min.rows = 6000)

  foureight_conn <- mfl_connect(2020, 22627)
  foureight_scoringhistory <- ff_scoringhistory(foureight_conn, 2019:2020)
  expect_tibble(foureight_scoringhistory, min.rows = 6000)
  expect_lt(max(foureight_scoringhistory$points), 60)

  jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
  jml_scoringhistory <- ff_scoringhistory(jml_conn, 2019:2020)
  expect_tibble(jml_scoringhistory, min.rows = 6000)

  joe_conn <- fleaflicker_connect(2020, 312861)
  joe_scoringhistory <- ff_scoringhistory(joe_conn, 2019:2020)
  expect_tibble(joe_scoringhistory, min.rows = 6000)

  tony_conn <- espn_connect(season = 2020, league_id = 899513)
  tony_scoringhistory <- ff_scoringhistory(tony_conn, 2019:2020)
  expect_tibble(tony_scoringhistory, min.rows = 3000)

  template_scoringhistory <- ff_template(scoring_type = "sfb11", roster_type = "sfb11") %>%
    ff_scoringhistory(2019:2020)

  expect_tibble(template_scoringhistory, min.rows = 6000)
})
