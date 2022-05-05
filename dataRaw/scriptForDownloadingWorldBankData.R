# Script to download World Bank data using 'wbstats'

library(wbstats)
library(tidyverse)
library(lubridate)
library(Hmisc)
library(caret)
library(kernlab)
library(stringr)
library(knitr)
library(VIM)
library(haven)


# # To view the world bank's list of countries
# countries <- wb_countries(lang = "en")
# View(countries)
# 
# # To view all indicators covered by wbstats
# allIndicators <- wb_indicators(lang = "en")
# allIndicators <- as_tibble(allIndicators)
# allIndicators
# 
# # To search for specific indicators
# indicators <- wb_search(pattern = "population growth")
# indicators <- as_tibble(indicators)
# indicators
# populationIndicators <- write_csv(indicators, "populationIndicators")


# Downloading the data on total population (SP.POP.TOTL) and populattion growth (SP.POP.GROW)
populationDF <- wb_data(country = "countries_only", indicator = c("SP.POP.TOTL", "SP.POP.GROW"), start_date = 1996, end_date = 2022)
populationDF <- as_tibble(populationDF)
names(populationDF)
populationDF <- select(populationDF, country, iso2c, iso3c, date, populationTotal = SP.POP.TOTL, populationGrowth = SP.POP.GROW)

populationDF$date <- as.numeric(as.character(populationDF$date))
head(populationDF)
View(populationDF)

# saving the population data in the directory
populationDataRaw <- write_csv(populationDF, "dataRaw/populationDataRaw.csv")
