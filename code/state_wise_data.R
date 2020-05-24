# Relevant libraries ----------------------------------------------------------
library(tidyverse)

# Relevant directories --------------------------------------------------------
project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")

source(paste0(project_dir, "code/harvest_data.R"))

# =============================================================================
# GET CLEAN STATE-WISE DATA
# =============================================================================

# Names of all states / UTs in the 'state_wise_daily' dataset
states <- names(state_wise_daily)[3:ncol(state_wise_daily)]


# Creates separate state level data, harvesting the 'state_wise_daily' dataset

# The state_wise_daily data has Confirmed, Recovered and Deceased data
# and hence has (3 x number_of_Dates) rows
# Confirmed corresponds to rows 1, 4, 7, and so on.
# Recovered corresponds to rows 2, 5, 8, and so on.
# Deceased corresponds to rows 3, 6, 9 and so on.

confirmed_idx <- seq(1, nrow(state_wise_daily), 3)
recovered_idx <- seq(2, nrow(state_wise_daily), 3)
deceased_idx <- seq(3, nrow(state_wise_daily), 3)

for(i in 1:length(states)){
  state_code <- states[i]
  state_wise_daily <- as.data.frame(state_wise_daily)
  
  col_idx <- which(names(state_wise_daily) == state_code)
  
  df <- data.frame(Date = unique(state_wise_daily$Date),
                   Confirmed = state_wise_daily[confirmed_idx, col_idx],
                   Recovered = state_wise_daily[recovered_idx, col_idx],
                   Deceased = state_wise_daily[deceased_idx, col_idx])
  
  
  df$Active <- cumsum(df$Confirmed) - cumsum(df$Recovered) - cumsum(df$Deceased)
  
  
  df$`Total Confirmed` <- cumsum(df$Confirmed)
  df$`Total Recovered` <- cumsum(df$Recovered)
  df$`Total Deceased` <- cumsum(df$Deceased)
  
  assign(as.character(state_code), df)
}

# Store curated state data in a list
states_data <- mget(states)


