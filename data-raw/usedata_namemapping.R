library(tidyverse)
# Import Name Mapping CSV
dp_name_mapping <- read.csv("data-raw/mismatches.csv") %>%
  dplyr::select(alt_name, correct_name) %>%
  dplyr::distinct(alt_name, .keep_all = TRUE) %>%
  tibble::deframe()

use_data(dp_name_mapping, overwrite = TRUE)
