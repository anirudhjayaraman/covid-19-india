# Load relevant libraries -----------------------------------------------------

library(stringr)
library(data.table)

# =============================================================================
# COVID 19-India API: A volunteer-driven, crowdsourced database 
# for COVID-19 stats & patient tracing in India
# =============================================================================

url <- "https://api.covid19india.org/csv/"  

# List out all CSV files to source --------------------------------------------

html <- url %>% readLines %>% paste(collapse = "\n")

pattern <- "https://api.covid19india.org/csv/latest/.*csv"

matched <- html %>% str_match_all(pattern = pattern) %>% unlist

# Downloading the Data --------------------------------------------------------

covid_datasets <- matched %>% as.list %>% lapply(fread)

# Naming the data objects appropriately ---------------------------------------

exclude_chars <- "https://api.covid19india.org/csv/latest/"

dataset_names <- substr(x = matched, 
                        start = 1 + nchar(exclude_chars), 
                        stop = nchar(matched)- nchar(".csv"))

# assigning variable names

for(i in seq_along(dataset_names)){
  assign(dataset_names[i], covid_datasets[[i]])
}

