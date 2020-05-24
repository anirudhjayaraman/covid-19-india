rm(list = ls())

# Relevant DIrectories --------------------------------------------------------

project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")

# =============================================================================
# Source and stitch the data
# =============================================================================

source(paste0(project_dir, "code/harvest_data.R"))

# DAILY CUMULATIVE EVOLUTION --------------------------------------------------

daily_evolution <- as.data.table(case_time_series) %>% 
  melt(id.vars = "Date") %>% 
  filter(variable %in% c('Total Confirmed','Total Deceased','Total Recovered'))


# =============================================================================
# Plot 1 - Stacked Column Chart Time Series 

g <- ggplot(data = daily_evolution, 
            aes(x = Date, fill = variable)) + 
  geom_col(aes(y = value, fill = variable), 
           position = position_stack(reverse = TRUE)) +
  labs(title = "Evolution of COVID-19 Cases in India (Cumulative)",
       x = "Time Since First Covid-19 (India) Case",
       y = "Cumulative Number of Cases")

plot(g)

# =============================================================================
# Plot 2 - Variant of Plot 1 with deceased population reducing cum. numbers 

daily_evolution$value[which(daily_evolution$variable == "Total Deceased")] <- -1 * 
  daily_evolution$value[which(daily_evolution$variable == "Total Deceased")] 

g <- ggplot(data = daily_evolution, 
            aes(x = Date, fill = variable)) + 
  geom_col(aes(y = value, fill = variable), 
           position = position_stack(reverse = TRUE)) +
  labs(title = "Evolution of COVID-19 Cases in India (Cumulative)",
       x = "Time Since First Covid-19 (India) Case",
       y = "Cumulative Number of Cases")

plot(g)

# EVOLUTION OF DAILY STATUS ---------------------------------------------------

daily_evolution <- as.data.table(case_time_series) %>% 
  melt(id.vars = "Date") %>%
  filter(variable %in% c('Daily Confirmed','Daily Deceased','Daily Recovered'))


# =============================================================================
# Plot 1 - Stacked Column Chart Time Series 

g <- ggplot(data = daily_evolution, 
            aes(x = Date, fill = variable)) + 
  geom_col(aes(y = value, fill = variable), 
           position = position_stack(reverse = TRUE)) +
  labs(title = "Evolution of COVID-19 Cases in India (Daily Status)",
       x = "Time Since First Covid-19 (India) Case",
       y = "Number of Individuals (Daily Status)")

plot(g)

# =============================================================================
# Plot 2 - Variant of Plot 1 with deceased population reducing cum. numbers

daily_evolution$value[which(daily_evolution$variable == "Daily Deceased")] <- -1 * 
  daily_evolution$value[which(daily_evolution$variable == "Daily Deceased")] 

g <- ggplot(data = daily_evolution, 
            aes(x = Date, fill = variable)) + 
  geom_col(aes(y = value, fill = variable), 
           position = position_stack(reverse = TRUE)) +
  labs(title = "Evolution of COVID-19 Cases in India (Daily Status)",
       x = "Time Since First Covid-19 (India) Case",
       y = "Number of Individuals (Daily Status)") 

plot(g)
