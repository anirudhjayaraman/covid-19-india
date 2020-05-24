# Summary of Code in this Directory

## Sourcing / Downloading / Cleaning Data -
- **source_data.R**: scrapes through the [Covid-19 India Tracker](https://api.covid19india.org/) to load latest Covid-19 data on India into your R-environment.
- **harvest_data.R**: does what *source_data.R* does, and in addition also stitches some disaggregated raw data and ensures dates are in workable formats.
- **state_wise_data.R**: collates state-wise data into state-specific time series datasets for each state. The data contains daily and cumulative confirmed, recovered and deceased cases for a given state from 14-Mar-2020. In order to check which state datasets are available at any given time:

```r
# Assuming your working directory is set to your local repo directory
source("code/state_wise_data.R")

# Print names of datasets for states (including UTs)
names(states_data)

# Data for the last 6 days for all states / UTs
lapply(states_data, tail)  # states_data is a list storing dataframes of alls states

# Data for Maharashtra
View(MH)  # or
View(states_data$MH)
```

## Analyzing Data -
- **broad_trends.R**: calls *harvest_data.R* and analyzes the *case_time_series.csv* dataset that has the following fields:
	* Confirmed (Daily, Total)
	* Recovered (Daily, Total)
	* Deceased (Daily, Total)
- **extrapolate_trends.R**: uses a time series of cumulative confirmed cases between 09-Mar-2020 and 09-May-2020 to fit a model that extrapolates on the fit to predict total confirmed cases up to 17-May-2020 (end of lockdown 3.0)
