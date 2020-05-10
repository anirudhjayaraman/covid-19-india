library(ggplot2)
library(visreg)

# Extrapolate Trends

# Observed Trend b/w Day 40 and Today
trends <- log(case_time_series$`Total Confirmed`)[40:101]

model_data <- data.frame(X = 1:length(trends), y = trends)


possible_exponents <- seq(1.5,4,0.01)
adjRSq <- rep(0, length(possible_exponents))

for(i in possible_exponents){
  modl <- lm(formula = y^i ~ X, data = model_data)
  adjRSq[which(possible_exponents == i)] <- summary(lm(trends^i ~ c(1:length(trends))))$adj.r.squared
}

exponent <- possible_exponents[which.max(adjRSq)]
model_data <- data.frame(X = 1:length(trends), y = trends)
modl <- lm(formula = y^3 ~ X, data = model_data)
summary(modl)

start_pred <- nrow(model_data) + 1
stop_pred <- start_pred + 14

predicted <- predict(object = modl, data.frame(X = start_pred:stop_pred))

predicted_transformed <- exp(predicted^(1/3))
predicted_transformed

plot(case_time_series$`Total Confirmed`, type = 'l')

dates <- c(case_time_series$Date, case_time_series$Date[nrow(case_time_series)] + c(1:8))
cases <- c(case_time_series$`Total Confirmed`, predicted_transformed)

datset <- data.frame(Date = dates, Cases = cases)
dates_highlight <- tail(datset$Date, n = 8)
datset$highlight <- ifelse(datset$Date %in% dates_highlight, "red", "black")



ggplot(datset, aes(x = Date, y = cases, color = highlight, group = 1)) +
  geom_line(size = 1) +
  scale_colour_identity(datset$highlight) + 
  labs(title = "Confirmed Cases: Historical (up to 09-May) and Projected",
       x = "Date",
       y = "Confirmed Cases")


visreg(modl, "X", gg = TRUE)
