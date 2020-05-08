# Clear your environment
rm(list = ls())

# Load relevant libraries

library(covid19.analytics)
library(rjson)


# Functions to read "live" time series data as reported by JHU's CCSE repository
# Add .JHU in order to read most recent data

confirmed_ts <- covid19.analytics::covid19.JHU.data(case = "ts-confirmed")
confirmed_agg <- covid19.analytics::covid19.JHU.data()

# =============================================================================
# Granular Covid Data on India
# =============================================================================

api_url <- "https://api.covid19india.org/raw_data3.json"
json_data <- rjson::fromJSON(file = api_url)

# =============================================================================
# Convert the JSON data into tidy data 
# =============================================================================

# Store your column names first before dealing with that horrendous list

fields <- names(json_data$raw_data[[1]])  # 20 would-be columns


# Initially you want all your data to be in the character / string format
# We can change their format later

char_raw_data <- lapply(json_data$raw_data, as.character)


# Convert your R list into an R data frame by first flattening out your list
# and shaping it into a matrix before transforming it to a data.frame object

covid_19_india <- data.frame(matrix(unlist(char_raw_data), 
                                    nrow = length(char_raw_data), 
                                    byrow = T),
                             stringsAsFactors = FALSE)

names(covid_19_india) <- fields
