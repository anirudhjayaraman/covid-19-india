# Summary of Code in this Directory

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
