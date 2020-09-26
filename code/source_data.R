# Load relevant libraries -----------------------------------------------------

library(tidyverse)
library(data.table)

# =============================================================================
# COVID 19-India API: A volunteer-driven, crowdsourced database 
# for COVID-19 stats & patient tracing in India
# =============================================================================

url <- "https://api.covid19india.org/documentation/csv/"  

# List out all CSV files to source --------------------------------------------

html <- url %>% readLines %>% paste(collapse = "\n")

# pattern for urls containing csv files
pattern <- "https://api.covid19india.org/csv/latest/.*csv"

# Minor hack in pattern to provide so as to parse links correctly
modified_pattern <- paste0(">", pattern)

# URLs with CSVs are stored in `matched`
matched <- html %>% 
  str_match_all(pattern = modified_pattern) %>% 
  unlist %>% 
  substring(first = 2)

# Downloading the Data --------------------------------------------------------

covid_datasets <- vector("list", length = length(matched))

for (i in 1:length(matched)) {
  covid_datasets[[i]] <- tryCatch(fread(matched[i]), error = function(e) NA)
}

# Naming the data objects appropriately ---------------------------------------

exclude_chars <- "https://api.covid19india.org/csv/latest/"

dataset_names <- substr(x = matched, 
                        start = 1 + nchar(exclude_chars), 
                        stop = nchar(matched)- nchar(".csv"))

names(covid_datasets) <- dataset_names

# storing individual datasets as objects
for(i in seq_along(dataset_names)){
  assign(dataset_names[i], covid_datasets[[i]])
}
