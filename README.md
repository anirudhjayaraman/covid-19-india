# Summary of Code in this Repo

All code are kept in code/

## Sourcing / Downloading / Cleaning Data -
- **source_patient_data.R**: scrapes through the [Covid-19 India Tracker](https://api.covid19india.org/) to load latest Covid-19 data on India into your R-environment.
- **download_data.R**: This can be run to download the data (daily, weekly or to a frequency that matches one's need) to a particular directory. It does what *source_patient_data.R* does, and in addition also saves all the loaded datasets into a directory of choice.
- **source_stitch.R**: does what *source_patient_data.R* does, and in addition also stitches some disaggregated raw data and ensures dates are in workable formats.



## Analyzing Data -
- **broad_trends.R**: calls source_stitch.R and analyzes the *case_time_series.csv* dataset that has the following fields:
	* Confirmed (Daily, Total)
	* Recovered (Daily, Total)
	* Deceased (Daily, Total)
- **extrapolate_trends.R**: uses a time series of cumulative confirmed cases between 09-Mar-2020 and 09-May-2020 to fit a model that extrapolates on the fit to predict total confirmed cases up to 17-May-2020 (end of lockdown 3.0)


# Humble First Attempt at Modeling the Evolution of Total Confirmed Covid-19 Cases in India

Based on some simple analyses, I conclude that through most of Lockdown 1 and Lockdown 2, Covid-19 cases in India have followed a predictable trend. Based on a model fit on 62 observations, my projections (in red) for the total number of confirmed cases for 17-May is a little over 100,000. 

![Figure 1: Anticipated Trends between 10-May and 17-May based on Historical Trends](output/plots/plot_01.png)

In the figure below, the dots correspond to total confirmed (cumulative) number of cases since the first Covid-19 case was reported in India 30 Jan. The blue line corresponds to model predictions. The numbers of the y-axis, however, are transformed.  **The y-axis plots values of the *cube* of the *log* of cumulative cases between 30-Jan and the i-th date since 09-Mar, with i plotted on the x-axis.**
The fit looks good and explains > 99% of in-sample variance.

![Figure 2: Goodness-of-Fit](output/plots/plot_02.png)

More analyses and models are expected to be updated to this space as more data comes in.



