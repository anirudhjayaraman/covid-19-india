# Analyzing the Indian Covid-19 Story

Based on some simple analyses, I conclude that through most of Lockdown 1 and Lockdown 2, the Indian Covid-19 cases has followed a predictable trend, based on which my projections (in red) for the total number of confirmed cases as on 17-May is a little over 100,000. However numbers as of 15-May are much lower, which is great news!

![Figure 1: Anticipated Trends between 10-May and 17-May based on Historical Trends](output/plots/plot_01.png)

In the figure below, the dots correspond to actual cumulative cases (since 30th January) on a given day. The line corresponds to model predictions. However, the y-axis plots values of the cube of the logarithm of cumulative cases between 30-Jan and the i-th date since 09-Mar, with i plotted on the x-axis.
The fit looks good and explains > 99% of in-sample variance.

![Figure 2: Goodness-of-Fit](output/plots/plot_02.png)