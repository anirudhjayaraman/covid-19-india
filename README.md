# Analyzing the Indian Covid-19 Story

Based on some simple analyses, I conclude that through most of Lockdown 1 and Lockdown 2, Covid-19 cases in India have followed a predictable trend. Based on a model fit on 62 observations, my projections (in red) for the total number of confirmed cases for 17-May is a little over 100,000. 

![Figure 1: Anticipated Trends between 10-May and 17-May based on Historical Trends](output/plots/plot_01.png)

In the figure below, the dots correspond to total confirmed (cumulative) number of cases since the first Covid-19 case was reported in India 30 Jan. The blue line corresponds to model predictions. The numbers of the y-axis, however, are transformed.  **The y-axis plots values of the *cube* of the *log* of cumulative cases between 30-Jan and the i-th date since 09-Mar, with i plotted on the x-axis.**
The fit looks good and explains > 99% of in-sample variance.

![Figure 2: Goodness-of-Fit](output/plots/plot_02.png)