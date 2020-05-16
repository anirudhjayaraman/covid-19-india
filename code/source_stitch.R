# Load relevant libraries -----------------------------------------------------

library(stringr)
library(data.table)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(visreg)
library(lubridate)


# Relevant directories --------------------------------------------------------
project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output_data/")
download_dir <- paste0(project_dir, "downloaded_data/")


# =============================================================================
# COVID 19-India API: A volunteer-driven, crowdsourced database 
# for COVID-19 stats & patient tracing in India
# =============================================================================

url <- "https://api.covid19india.org/csv/"  

# List out all CSV files to source --------------------------------------------

html <- paste(readLines(url), collapse="\n")
pattern <- "https://api.covid19india.org/csv/latest/.*csv"
matched <- unlist(str_match_all(string = html, pattern = pattern))

# Downloading the Data --------------------------------------------------------

covid_datasets <- lapply(as.list(matched), fread)

# Naming the data objects appropriately ---------------------------------------


exclude_chars <- "https://api.covid19india.org/csv/latest/"

dataset_names <- substr(x = matched, 
                        start = 1 + nchar(exclude_chars), 
                        stop = nchar(matched)- nchar(".csv"))

# assigning variable names
for(i in seq_along(dataset_names)){
  assign(dataset_names[i], covid_datasets[[i]])
}

# Up to this point we have sourced all our data
# =============================================================================
# Some stitching is required because the data are in chunks
# =============================================================================

# Convert the 3 patient level datasets from data.table to data.frame
raw_data1 <- as.data.frame(raw_data1)
raw_data2 <- as.data.frame(raw_data2)
raw_data3 <- as.data.frame(raw_data3)


# save column names for each patient level dataset
data1_names <- names(raw_data1)
data2_names <- names(raw_data2)
data3_names <- names(raw_data3)

# =============================================================================
#              YOU WANT THE UNION OF ALL COLUMNS IN EACH DATASET 
# =============================================================================

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

# =============================================================================
#                            BIND THE DATA TOGETHER
# =============================================================================

raw_data <- rbind(raw_data1, raw_data2, raw_data3)

# ENSURE DATES ARE IN THE DATE FORMAT AND NOT CHARACHTER ----------------------

date_cols <- names(raw_data)[grep("Date", names(raw_data))]

raw_data <- raw_data %>% mutate_at(date_cols, lubridate::dmy)

# State Patient Number needs to be numeric ------------------------------------
numer_cols <- names(raw_data)[grep("Number", names(raw_data))]

raw_data <- raw_data %>% mutate_at(numer_cols, as.numeric)

# Age Bracket has to be Numeric -----------------------------------------------
raw_data$`Age Bracket` <- as.numeric(raw_data$`Age Bracket`)

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

###############################################################################
############              THAT'S ALL FOLKS!                 ###################
###############################################################################