# =============================================================================
# Custom code to save specific datasets
# to be used after having harvested data using harvest_data.R
# =============================================================================

# Load required libraries -------------------------------------------------

library(readr)

if(!exists("download_dir")){
  download_dir <- "C:/git/covid-19/downloaded_data/"
}


# Check Download Destination Exists ---------------------------------------

# Add code to check if destination path exists
dir.create(paste0(download_dir, today(),"/"))


# Save all data.frame objects as CSVs -------------------------------------

for(el in ls()){
  if("data.frame" %in% class(get(el))){
    write_csv(get(el), paste0(download_dir, today(), "/", el, ".csv"))
  }
}

# =============================================================================