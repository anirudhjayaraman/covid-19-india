# Required Libraries ------------------------------------------------------

library(tidyverse)

# Defining the log exponent function --------------------------------------

model_exponent <- function(df, calibration_horizon = 30, 
                           logarithm = FALSE, exp_min = 1, exp_max = 10){
  #' Finds a linear relationship between the exponent of a data series and 
  #' time stamps.
  #' 
  #' @param df: Dataframe with 2 columns; one has time / date and the other
  #' has the variable for which an exponential relationship is sought
  #' @param calibration_horizon: Number of time stamps to include in model
  #' which defaults to the minimum of 30 and number of rows in the data
  #' @param logarithm: Indicator variable specifying whether to take the 
  #' logarithm of the second column before finding model exponent
  
  df <- as.data.frame(df)
  
  n_row <- nrow(df)
  calibration_horizon <- ifelse(n_row < 30, n_row, calibration_horizon)
  
  df <- df %>% tail(n = calibration_horizon)
  
  # dependent variable assignment
  if(logarithm){
    y <- log(df[,2])
  } else {
    y <- df[,2]
  }
  
  # independent variable assignment
  if(class(df[,1]) == "Date"){
    X <- df[,1]
  } else {
    X <- 1:calibration_horizon
  }

  exponent_range <- seq(from = exp_min, to = exp_max, by = 0.05)
  adj_R_Sq <- rep(0, length(exponent_range))
  
  for(i in seq_along(exponent_range)){
    exponent <- exponent_range[i]
    modl <- lm(formula = y^exponent ~ X)
    adj_R_Sq[i] <- summary(modl)$adj.r.squared
  }
  
  result_obj <- list()
  
  # Estimated optimal model exponent ------------------------------------------
  exp_nent <- exponent_range[which.max(adj_R_Sq)]
  
  # Plot illustrating optimal model exponent ----------------------------------
  plot_data <- data.frame(exponents = exponent_range,
                          adj_R_Sq = adj_R_Sq)
  plot_goodness_of_fit <- plot_data %>%
    ggplot(mapping = aes(x = exponents, y = adj_R_Sq)) + 
    geom_line(size = 1) + 
    theme_light() +
    labs(title = "Optimal Exponent") + 
    xlab("Exponent") + 
    ylab("Adjusted R-Squared")
  
  # Store the results ---------------------------------------------------------
  result_obj[[1]] <- exp_nent
  result_obj[[2]] <- plot_goodness_of_fit
  names(result_obj) <- c("Exponent","OptimalExponent")
  
  return(result_obj)
}


