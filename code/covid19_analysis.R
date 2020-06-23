# Relevant libraries ----------------------------------------------------------
library(tidyverse)
library(reshape2) # for melt

# Specifiy plotting config ----------------------------------------------------
options(scipen = as.integer(conf$scientific_notation))

# Relevant directories --------------------------------------------------------

project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")

# Source scripts to download, load, harvest and structure the data ------------
source(paste0(project_dir, "code/state_wise_data.R"))

# =============================================================================
# State-wise Total Confirmed 
# =============================================================================

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

# Plotting data
plotting_data <- total_confirmed %>% 
  select(-TT) %>%  # do not want total numbers to screw y-axes scale!
  reshape2::melt(variable.name = "State", value.name = "TotalConfirmed") %>%
  filter(State != "Date")

plotting_data$Date <- rep(total_confirmed$Date,
                          length(unique(plotting_data$State)))

# plot state-wise total confirmed for states with cases above a threshold
plotting_data %>%
  ggplot(mapping = aes(x = Date, y = TotalConfirmed, color = State)) + 
  geom_line(mapping = aes(y = TotalConfirmed), size = 1, show.legend = F) + 
  xlab("") + 
  # scale_y_continuous(trans = 'log10') + 
  facet_wrap(~ State) +
  ggtitle(paste0("Statewise India Covid-19 trends (Total Confirmed) as of ", 
                 today()))
