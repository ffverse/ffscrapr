library(checkmate)

test_that("ff_userleagues works for Yahoo", {
  xml_doc <- xml2::read_xml("./leagues-teams.xml")
  xml2::xml_ns_strip(xml_doc)
  response <- process_yahoo_userleagues_response(xml_doc)
  expect_tibble(response, min.rows = 6)
})

test_that("ff_franchises works for Yahoo", {
  xml_doc <- xml2::read_xml("./single-league-teams.xml")
  xml2::xml_ns_strip(xml_doc)
  response <- process_yahoo_franchises_response(xml_doc)
  expect_tibble(response, min.rows = 16)
})

