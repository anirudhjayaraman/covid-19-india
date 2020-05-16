rm(list = ls())

# Relevant DIrectories --------------------------------------------------------

project_dir <- "C:/git/covid-19/"
output_dir <- paste0(project_dir, "output_data/")
download_dir <- paste0(project_dir, "downloaded_data/")

# =============================================================================
# Source and stitch the data
# =============================================================================

source(paste0(project_dir, "code/source_stitch.R"))

# =============================================================================
# Extrapolate Trends based on Data b/w 09-Mar and 09-May for predictions 
# =============================================================================

# #############################################################################
# After not more than 20 minutes of playing with the data 
# (meaning, there could be homework done here)
#
# Observed Trend b/w Day 40 and Day 101
###############################################################################

trends <- log(case_time_series$`Total Confirmed`)[40:101]
model_data <- data.frame(X = 1:length(trends), y = trends)


possible_exponents <- seq(1.5,4,0.01)
adjRSq <- rep(0, length(possible_exponents))

for(i in possible_exponents){
  modl <- lm(formula = y^i ~ X, data = model_data)
  adjRSq[which(possible_exponents == i)] <- 
    summary(lm(trends^i ~ c(1:length(trends))))$adj.r.squared
}

exponent <- possible_exponents[which.max(adjRSq)]  # 2.71

# overriding exponent
exponent <- 3

model_data <- data.frame(X = 1:length(trends), y = trends)
modl <- lm(formula = y^exponent ~ X, data = model_data)
summary(modl)

start_pred <- nrow(model_data) + 1
stop_pred <- start_pred + 14

predicted <- predict(object = modl, data.frame(X = start_pred:stop_pred))

predicted_transformed <- exp(predicted^(1/exponent))

plot(case_time_series$`Total Confirmed`, type = 'l')

dates <- c(case_time_series$Date[1:101], 
           case_time_series$Date[102] + 0:7)
cases <- c(case_time_series$`Total Confirmed`[1:101], 
           predicted_transformed[1:8])

datset <- data.frame(Date = dates, Cases = cases)
dates_highlight <- tail(datset$Date, n = 8)
datset$highlight <- ifelse(datset$Date %in% dates_highlight, "red", "black")



g <- ggplot(datset, aes(x = Date, y = cases, color = highlight, group = 1)) + 
  geom_line(size = 1) +
  scale_colour_identity(datset$highlight) + 
  labs(title = "Confirmed Cases: Historical (up to 09-May) and Projected",
       x = "Date",
       y = "Confirmed Cases")

plot(g)


h <- visreg(modl, "X", gg = TRUE) +
  labs(titile = "Model Fit on data between 09-Mar and 09-May",
       x = "Day Count since 09-Mar (up to 09-May)",
       y = "Cube of the log of Total Confirmed (Cumulative)")
plot(h)
