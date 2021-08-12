# Import Stat Mapping CSV
nflfastr_stat_mapping <- read.csv("data-raw/stat_mapping.csv")

usethis::use_data(nflfastr_stat_mapping, overwrite = TRUE)
