# Relevant libraries ----------------------------------------------------------
library(tidyverse)
library(reshape2) 

# Relevant directories --------------------------------------------------------

project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")

# Source scripts to download, load, harvest and structure the data ------------
source(paste0(project_dir, "code/state_wise_data.R"))

# Source the function modeling the trend by computing the best exponent (power)
# to which, when the time series is raised, the fit with time is linear

source("code/model_exponent.R")

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

# Plot 1 ======================================================================
# plot state-wise total confirmed cases
plot_total_confirmed <- total_confirmed %>% 
  select(-TT) %>%  # do not want total numbers to screw y-axes scale!
  reshape2::melt(variable.name = "State", value.name = "TotalConfirmed") %>%
  filter(State != "Date")

plot_total_confirmed$Date <- rep(total_confirmed$Date,
                                 length(unique(plot_total_confirmed$State)))


p1 <- plot_total_confirmed %>%
  ggplot(mapping = aes(x = Date, y = TotalConfirmed, color = State)) + 
  geom_line(mapping = aes(y = TotalConfirmed), size = 1, show.legend = F) + 
  xlab("") + 
  facet_wrap(~ State) +
  ggtitle(paste0("Statewise India Covid-19 trends (Total Confirmed) as of ", 
                 today()))

ggsave(filename = "output/plots/plot_total_confirmed.png", plot = p1)

# Plot 2 ======================================================================
# Plot the most recent number of total confirmed cases by state / region
total_confirmed %>%
  slice_tail() %>%
  select(AN:UN) %>%   # exclude the total (TT) and Date
  melt() %>% 
  rename(State = variable, `Total Confirmed` = value) %>% 
  mutate(State = fct_reorder(State, `Total Confirmed`), 
         Percentage = 100 * `Total Confirmed` / sum(`Total Confirmed`)) %>% 
  ggplot() + 
  theme_light() + 
  geom_col(mapping = aes(x = `Total Confirmed`, 
                         y = State, 
                         fill = `Total Confirmed`),
           show.legend = FALSE) +
  xlab(paste0("Total Confirmed as of ",
              total_confirmed %>% slice_tail() %>% pull(Date)))

# Plot 3 ======================================================================
# Let's visualize the above plot in percentages
total_confirmed %>%
  slice_tail() %>%
  select(AN:UN) %>% 
  melt() %>% 
  rename(State = variable, `Total Confirmed` = value) %>% 
  mutate(State = fct_reorder(State, `Total Confirmed`),
         `Total Confirmed` = 100 * `Total Confirmed` / 
           sum(`Total Confirmed`)) %>% 
  ggplot() + 
  theme_light() + 
  geom_col(mapping = aes(x = `Total Confirmed`, 
                         y = State,
                         fill = `Total Confirmed`),
           show.legend = FALSE) + 
  xlab(paste0("% Share of all confirmed cases by state as of ",
              total_confirmed %>% slice_tail() %>% pull(Date)))

# Plot 4 ======================================================================
# Let's visualize the data as a circular bar-plot
# The plot doesn't make sense with the kind of numbers seen in MH in comparison 
# to other states

circular_bar_data <- total_confirmed %>%
  slice_tail() %>%
  select(AN:UN) %>% 
  melt() %>% 
  rename(State = variable, `Total Confirmed` = value) %>% 
  mutate(id = 1:length(State)) %>%
  select(id, State, `Total Confirmed`)

num_bars <- nrow(circular_bar_data)  # Number of bars to plot

# Assign angle for each 'id' in the dataset just created
# where text will appear. Should be above the bars and centered
angle <-  90 - (360 / num_bars) * (data_to_plot$id - 0.5)     

# Alignment of labels - angles less than 90 degrees correspond to left plot
circular_bar_data$hjust <- ifelse(angle < -90, 1, 0)

# Flip labels on the left part of the plot by 180 degrees
circular_bar_data$angle <- ifelse(angle < -90, angle + 180, angle)


plot_circular <- circular_bar_data %>% 
  ggplot(mapping = aes(x = factor(id), y = `Total Confirmed`)) +
  
  # Note that id is a factor. 
  # If x is numeric, there is some space between the first bar
  
  geom_bar(stat = "identity", fill = "steelblue") +
  
  # Limits of the plot.
  # The negative value controls the size of the inner circle 
  # The positive one is useful to add size over each bar
  
  ylim(-50,5*10^5) +
  
  # Custom the theme: no axis title and no cartesian grid
  
  theme_minimal() +
  
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    
    # Adjust the margin to make in sort labels are not truncated!
    plot.margin = unit(rep(-1,4), "cm")
    
  ) +
  
  # This makes the coordinate polar instead of cartesian.
  coord_polar(start = 0) +
  
  # Add the labels, using the data_to_plot dataframe
  geom_text(data = circular_bar_data, 
            aes(x = id, y = `Total Confirmed` + 1, 
                label = State, 
                hjust = hjust), 
            color = "black", 
            fontface = "bold",
            alpha = 0.6, 
            size = 2.5, 
            angle = circular_bar_data$angle, 
            inherit.aes = FALSE)

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
p2 <- plotting_data %>%
  ggplot(mapping = aes(x = Date, y = TotalDeceased, color = State)) + 
  geom_line(mapping = aes(y = TotalDeceased), size = 1, show.legend = F) + 
  xlab("") + 
  facet_wrap(~ State) +
  ggtitle(paste0("Statewise India Covid-19 trends (Total Deceased) as of ", 
                 today()))

ggsave(filename = "output/plots/plot_total_deceased.png", plot = p2)

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
p3 <- plotting_data %>%
  ggplot(mapping = aes(x = Date, y = Active, color = State)) + 
  geom_line(mapping = aes(y = Active), size = 1, show.legend = F) + 
  xlab("") + 
  # scale_y_continuous(trans = 'log10') + 
  facet_wrap(~ State) +
  ggtitle(paste0("Statewise India Covid-19 trends (Total Active Cases) as of ", 
                 today()))

ggsave(filename = "output/plots/plot_total_active.png", plot = p3)

# =============================================================================
# Modeling Trends
# =============================================================================

case_time_series %>%
  select(Date, `Total Confirmed`) %>% 
  ggplot() +
  hrbrthemes::theme_ipsum() +
  geom_line(mapping = aes(x = Date, y = `Total Confirmed`)) + 
  geom_point(mapping = aes(x = Date, y = `Total Confirmed`))
  


# Applying the model_exponent function to state-wise `Total Confirmed` cases
get_log_exponent <- . %>% 
  select(Date, `Total Confirmed`) %>% 
  model_exponent(calibration_horizon = 30, logarithm = TRUE)

case_time_series %>% get_log_exponent()
MH %>% get_log_exponent()
DL %>% get_log_exponent()
