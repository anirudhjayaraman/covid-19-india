rm(list = ls())

# Relevant libraries ----------------------------------------------------------
library(tidyverse)

# Relevant directories --------------------------------------------------------
project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output_data/")
download_dir <- paste0(project_dir, "downloaded_data/")

source(paste0(project_dir, "code/source_stitch.R"))

# =============================================================================
# Maharashtra 
mh_ <- raw_data %>% filter(`State code` == "MH" & !is.na(`Patient Number`)) %>% 
  arrange(`Patient Number`)



