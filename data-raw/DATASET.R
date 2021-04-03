## code to prepare `DATASET` dataset goes here
stat_mapping <- read.csv("data-raw/stat_mapping.csv")
usethis::use_data(stat_mapping, overwrite = TRUE, internal = TRUE)
