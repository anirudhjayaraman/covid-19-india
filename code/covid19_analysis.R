# Relevant libraries ----------------------------------------------------------
library(tidyverse)

# Relevant directories --------------------------------------------------------

project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")

# Source scripts to download, load, harvest and structure the data ------------
source(paste0(project_dir, "code/state_wise_data.R"))
source(paste0(project_dir, "code/plot_state_trends.R"))

# State-wise Total Confirmed --------------------------------------------------

# Define function to get column with name `Total Confirmed` from any dataset
get_total_confirmed <- . %>% select(`Total Confirmed`)

# list corresponding to Total Confirmed column for each state
extracted_cols <- states_data %>% map(get_total_confirmed)

# bind all columns together  and then add a Date column
total_confirmed <- extracted_cols %>% 
  do.call(what = "cbind")
total_confirmed$Date <- states_data$DL$Date  # use any state's dates (here DL)

# rename column names of the dataset
names(total_confirmed) <- c(names(states_data), "Date")

# plot state-wise total confirmed for states with cases above a threshold
