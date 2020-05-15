# =============================================================================
# Stitch Together and Save all the Covid-19 Datasets
# =============================================================================

rm(list = ls())

# Load relevant libraries -----------------------------------------------------
library(tidyverse)
library(lubridate)

# Relevant directories --------------------------------------------------------
project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output_data/")
download_dir <- paste0(project_dir, "downloaded_data/")

# Downloading and sourcing patient level data to the R environement -----------
source(paste0(project_dir, "source_patient_data.R"))


# =============================================================================
# stitch patient level data together 
# =============================================================================

# Convert the 3 patient level datasets from data.table to data.frame
raw_data1 <- as.data.frame(raw_data1)
raw_data2 <- as.data.frame(raw_data2)
raw_data3 <- as.data.frame(raw_data3)


# save column names for each patient level dataset
data1_names <- names(raw_data1)
data2_names <- names(raw_data2)
data3_names <- names(raw_data3)

# union of column names of all 3 datasets
all_column_names <- base::union(data1_names, 
                                base::union(data2_names, data3_names))

# Replacing variables missing from each dataset with NA
if(length(setdiff(all_column_names, data1_names)) != 0){
  raw_data1[, setdiff(all_column_names, data1_names)] <- NA
}

if(length(setdiff(all_column_names, data2_names)) != 0){
  raw_data2[, setdiff(all_column_names, data2_names)] <- NA
}

if(length(setdiff(all_column_names, data3_names) !=0)){
  raw_data3[, setdiff(all_column_names, data3_names)] <- NA
}

# Rearranging order of dataset variables such that they are the same
raw_data2 <- raw_data2[ , match(names(raw_data2), names(raw_data1))] 
raw_data3 <- raw_data3[ , match(names(raw_data3), names(raw_data1))]

# Concatenating the 3 datasets by rows
raw_data <- rbind(raw_data1, raw_data2, raw_data3)

# =============================================================================
# stitch death and recovery data together
# =============================================================================

# This comes pre-stitched (death_and_recovered)

# =============================================================================
# Save the datasets
# =============================================================================

fwrite(x = raw_data, file = paste0(download_dir, "raw_data_", 
                                   lubridate::today(), ".csv"))
fwrite(x = case_time_series, 
       file = paste0(download_dir, "case_time_series_", 
                     lubridate::today(), ".csv"))
fwrite(x = death_and_recovered, 
       file = paste0(download_dir, "death_and_recovered_", 
                     lubridate::today(), ".csv"))
fwrite(x = district_wise, 
       file = paste0(download_dir, "district_wise_", 
                     lubridate::today(), ".csv"))
fwrite(x = state_wise, 
       file = paste0(download_dir, "state_wise_", 
                     lubridate::today(), ".csv"))
fwrite(x = state_wise_daily, 
       file = paste0(download_dir, "state_wise_daily_", 
                     lubridate::today(), ".csv"))
fwrite(x = statewise_tested_numbers_data, 
       file = paste0(download_dir, 
                     "statewise_tested_numbers_data_", 
                     lubridate::today(), ".csv"))


