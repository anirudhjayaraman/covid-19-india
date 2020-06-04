# Load relevant libraries -----------------------------------------------------

library(tidyverse)
library(lubridate)
library(ggplot2)
library(visreg)
library(lubridate)
library(readr)


# Relevant directories --------------------------------------------------------
project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")


# =============================================================================
# COVID 19-India API: A volunteer-driven, crowdsourced database 
# for COVID-19 stats & patient tracing in India
# =============================================================================

source(paste0(project_dir, "code/source_data.R"))


# =============================================================================
# Some stitching is required because the data are in chunks
# =============================================================================

# Store all raw_data1, raw_data2, ... variables (dataframes) in a list 
raw_datasets <- mget(ls()[grep("raw_data[0-9]", ls(), fixed = FALSE)])

# Convert the patient level datasets from data.table to data.frame
raw_datasets <- lapply(raw_datasets, as.data.frame)

# =============================================================================
# Ensure datasets are complete
# =============================================================================

# Ensure data corresponds to non-empty time stamps
case_time_series <- case_time_series %>% 
  filter(!is.na(Date) & Date != "")

state_wise_daily <- state_wise_daily %>% 
  filter(!is.na(Date) & Date != "")

# =============================================================================
# Dates in the CASE TIME SERIES data are messed up
# case_time_series dataset 
# =============================================================================

# Convert date in "dd Month" character format to Date objects with lubridate
case_ts_dates <- case_time_series$Date

# substrings corresponding to date and month
date_chars <- substr(case_ts_dates, start = 1, stop = 2)
month_chars <- substr(case_ts_dates, start = 4, stop = 6)

# transform Date variable into an easily readable format
case_time_series$Date <- 
  lubridate::dmy(paste0(date_chars, "-", month_chars, "-2020"))


# =============================================================================
# Dates in the STATE WISE DAILY data are strings
# state_wise_daily
# =============================================================================
state_wise_daily$Date <- lubridate::dmy(state_wise_daily$Date)

# =============================================================================
# Download your data at this point
# =============================================================================

source(paste0(project_dir, "code/save_data.R"))
