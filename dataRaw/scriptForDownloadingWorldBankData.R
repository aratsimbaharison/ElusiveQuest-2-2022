library(wbstats)
library(tidyverse)


# To view the world bank's list of countries
countries <- wb_countries(lang = "en")
View(countries)


# To list and identify the world bank indicators
indicators <- wb_search(pattern = "wgi")
indicators <- as_tibble(indicators)
indicators

View(indicators)

# Downloading the wgi data from the World Bank website 

# Example: downloading the outcome variable political stability estimates (polStabEst) = GV.POLI.ST.ES

polStabEstData <- wb_data(indicator = "GV.POLI.ST.ES", country = "countries_only", start_date = 1996, end_date = 2020)
head(polStabEstData)
names(polStabEstData)
polStabEstData <- select(polStabEst, iso2c, iso3c, country, date, polStabEst = GV.POLI.ST.ES)
View(polStabEstData)
