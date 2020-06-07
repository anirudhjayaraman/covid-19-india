# Relevant libraries ----------------------------------------------------------
library(tidyverse)
library(gridExtra)

# Relevant directories --------------------------------------------------------

project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")

source(paste0(project_dir, "code/state_wise_data.R"))
source(paste0(project_dir, "code/plot_state_trends.R"))

# =============================================================================
# Plotting trends state-wise
# =============================================================================


# Total Confirmed ---------------------------------------------------------

for(i in 1:length(states)){
  # get COVID-19 dataset for i-th state
  dat <- get(states[i])
  
  # Sve the plot
  assign(paste0("p",i), 
         dat %>%
           ggplot(mapping = aes(x = Date)) +
           geom_line(mapping = aes(y = `Total Confirmed`), 
                     color = 'steelblue', size = 1, show.legend = TRUE) +
           xlab("") + ylab("") +
           ggtitle(paste0(states[i], " Total Confirmed")))
}


plot_state_trends()



# Total Active ------------------------------------------------------------

for(i in 1:length(states)){
  # get COVID-19 dataset for i-th state
  dat <- get(states[i])
  
  # Sve the plot
  assign(paste0("p",i), 
         dat %>%
           ggplot(mapping = aes(x = Date)) +
           geom_line(mapping = aes(y = Active), 
                     color = 'forestgreen', size = 1, show.legend = TRUE) +
           xlab("") + ylab("") +
           ggtitle(paste0(states[i], " Total Active")))
}


plot_state_trends()
