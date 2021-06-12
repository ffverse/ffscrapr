library(tidyverse)
# Import Name Mapping CSV
dp_name_mapping <- read.csv("data-raw/mismatches.csv") %>%
  dplyr::select(alt_name, correct_name) %>%
  tibble::deframe()

use_data(dp_name_mapping, overwrite = TRUE)
