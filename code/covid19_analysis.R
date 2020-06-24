# Relevant libraries ----------------------------------------------------------
library(tidyverse)
library(reshape2) # for melt

# Relevant directories --------------------------------------------------------

project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")

# Source scripts to download, load, harvest and structure the data ------------
source(paste0(project_dir, "code/state_wise_data.R"))

# Specifiy plotting config ----------------------------------------------------
options(scipen = as.integer(conf$scientific_notation))

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


# =============================================================================
# State-wise Total Deceased 
# =============================================================================

# Define function to get column with name `Total Deceased` from any dataset
get_total_deceased <- . %>% select(`Total Deceased`)

# list corresponding to Total Deceased column for each state
extracted_cols <- states_data %>% map(get_total_deceased)

# bind all columns together  and then add a Date column
total_deceased <- extracted_cols %>% do.call(what = "cbind")
total_deceased$Date <- states_data$DL$Date  # use any state's dates (here DL)

# rename column names of the dataset
names(total_deceased) <- c(names(states_data), "Date")

# Plotting data
plotting_data <- total_deceased %>% 
  select(-TT) %>%  # do not want total numbers to screw y-axes scale!
  reshape2::melt(variable.name = "State", value.name = "TotalDeceased") %>%
  filter(State != "Date")

plotting_data$Date <- rep(total_deceased$Date,
                          length(unique(plotting_data$State)))

# plot state-wise total deceased for states with cases above a threshold
plotting_data %>%
  ggplot(mapping = aes(x = Date, y = TotalDeceased, color = State)) + 
  geom_line(mapping = aes(y = TotalDeceased), size = 1, show.legend = F) + 
  xlab("") + 
  # scale_y_continuous(trans = 'log10') + 
  facet_wrap(~ State) +
  ggtitle(paste0("Statewise India Covid-19 trends (Total Deceased) as of ", 
                 today()))

# =============================================================================
# State-wise Active Cases
# =============================================================================

# Define function to get column with name `Active` from any dataset
get_active <- . %>% select(Active)

# list corresponding to Active column for each state
extracted_cols <- states_data %>% map(get_active)

# bind all columns together  and then add a Date column
active <- extracted_cols %>% do.call(what = "cbind")
active$Date <- states_data$DL$Date  # use any state's dates (here DL)

# rename column names of the dataset
names(active) <- c(names(states_data), "Date")

# Plotting data
plotting_data <- active %>% 
  select(-TT) %>%  # do not want total numbers to screw y-axes scale!
  reshape2::melt(variable.name = "State", value.name = "Active") %>%
  filter(State != "Date")

plotting_data$Date <- rep(active$Date,
                          length(unique(plotting_data$State)))

# plot state-wise total active cases for states with cases above a threshold
plotting_data %>%
  ggplot(mapping = aes(x = Date, y = Active, color = State)) + 
  geom_line(mapping = aes(y = Active), size = 1, show.legend = F) + 
  xlab("") + 
  # scale_y_continuous(trans = 'log10') + 
  facet_wrap(~ State) +
  ggtitle(paste0("Statewise India Covid-19 trends (Total Active Cases) as of ", 
                 today()))


