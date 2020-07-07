rm(list = ls())

# Relevant Libraries ----------------------------------------------------------
require(tidyverse)
require(hrbrthemes)
require(gridExtra)
require(config)

# Relevant Directories --------------------------------------------------------

project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output/")
download_dir <- paste0(project_dir, "downloaded_data/")

# Configurations --------------------------------------------------------------
config <- config::get(file = paste0(project_dir, "conf/config.yml"))
options(scipen = config$scientific_notation)

# =============================================================================
# Source and stitch the data; also source code to model the exponent
# =============================================================================

source(paste0(project_dir, "code/harvest_data.R"))
source(paste0(project_dir, "code/model_exponent.R"))

# =============================================================================
# Model the data
# =============================================================================

# Model data
model_data <- case_time_series[1:(nrow(case_time_series)), 
                               c("Date", "Total Confirmed")]

# Plot Model Data -------------------------------------------------------------
model_data %>%
  ggplot(aes(x = Date, y = `Total Confirmed`)) +
  geom_line(color="grey") +
  geom_point(shape=21, color="black", fill="#69b3a2", size=2) +
  theme_ipsum() +
  ggtitle("Evolution of Total Confirmed Covid-19 Cases")

model_data %>% model_exponent(calibration_horizon = 45, logarithm = TRUE) 


# -----------------------------------------------------------------------------
# Model the Exponent
# -----------------------------------------------------------------------------

# Use log(Total Confirmed) as dependent variable
model_data$`Log Total Confirmed` <- log(model_data$`Total Confirmed`)

# Plot evolution of modeled exponent over different calibration periods...
# Calibration periods are in days.

calibration_periods <- c(5,7,15,30,45,60,75,90)

exponent_plots <- list()
adjRSq_plots <- list()
adjRSq_densities <- list()

start_time <- Sys.time()

for(k in seq_along(calibration_periods)){
  # Config for rolling-window calibrations
  from <- 1
  calibration_period <- calibration_periods[k]
  till <- nrow(model_data) - calibration_period + 1
  
  # instantiate time series of exponents and adjusted R-squared value
  # on the basis of which the exponent was chosen
  exponents <- chosen_adjRSq <- rep(0, till)
  
  
  # Model Exponents on a moving-window basis
  for(i in from:till){
    exponents_range <- seq(1,10,0.05)
    adjRSq <- rep(0, length(exponents_range))
    
    dat <- model_data[i:(i + calibration_period - 1), ]
    names(dat) <- c("Date","y","ln_y")
    
    for(j in seq_along(exponents_range)){
      exponent <- exponents_range[j]
      modl <- lm(formula = ln_y^exponent ~ Date, data = dat)
      adjRSq[j] <- summary(modl)$adj.r.squared
    }
    
    exponents[i] <- exponents_range[which.max(adjRSq)]
    chosen_adjRSq[i] <- max(adjRSq)
  }
  
  # Ensure plot dates reflect last date of calibration period
  adjustment <- calibration_period - 1
  frOm <- from + adjustment
  ti1l <- till + adjustment
  
  # Data to use for plotting
  exponents_data <- data.frame(Date = model_data$Date[frOm:ti1l],
                               Exponent = exponents)
  adjRSq_data <- data.frame(Date = model_data$Date[frOm:ti1l],
                            AdjRSq = chosen_adjRSq)
  
  # Plot of moving window exponents for a given calibration period 
  g <- exponents_data %>%
    ggplot(aes(x = Date, y = Exponent)) +
    geom_line(color="green", size = 1.2) +
    geom_point(shape=21, color="black", fill="#69b3a2", size=2) +
    theme_ipsum_pub(plot_title_size = 14) +
    ggtitle(paste0("Evolution of modeled ", calibration_period, "-day exponent"))
  
  r <- adjRSq_data %>%
    ggplot(aes(x = Date, y = AdjRSq)) + 
    geom_line(color = "black", size = 1.2) + 
    theme_ipsum_pub(plot_title_size = 10) +
    ggtitle(paste0("Evolution of Adj.R-Sq (Max) based on ", calibration_period, "-day calibration period"))
  
  exponent_plots[[k]] <- g
  adjRSq_plots[[k]] <- r
  
}

time_taken <- Sys.time() - start_time
print(time_taken)

for(p in 1:length(exponent_plots)){
  assign(paste0("plot_", p), exponent_plots[[p]])
  assign(paste0("plot_", p + length(exponent_plots)), 
         adjRSq_plots[[p]])
}

# Exponent plots
grid.arrange(plot_1, plot_2, plot_3,
             plot_4, plot_5, plot_6,
             plot_7, plot_8, plot_9, ncol = 3)

# Adjusted R-Squared plots
grid.arrange(plot_10, plot_11, plot_12,
             plot_13, plot_14, plot_15,
             plot_16, plot_17, plot_18, ncol = 3)

# h <- visreg(modl, "X", gg = TRUE) +
#   labs(titile = "Model Fit on data between 09-Mar and 09-May",
#        x = "Day Count since 09-Mar (up to 09-May)",
#        y = "Cube of the log of Total Confirmed (Cumulative)")
# plot(h)
