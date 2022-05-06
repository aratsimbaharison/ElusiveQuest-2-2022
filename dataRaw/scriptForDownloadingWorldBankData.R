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


# Downloading the population data, including total population (SP.POP.TOTL) and population growth (SP.POP.GROW)
populationDF <- wb_data(country = "countries_only", indicator = c("SP.POP.TOTL", "SP.POP.GROW"), start_date = 1996, end_date = 2022)
populationDF <- as_tibble(populationDF)
names(populationDF)
populationDF <- select(populationDF, country, iso2c, iso3c, date, populationTotal = SP.POP.TOTL, populationGrowth = SP.POP.GROW)

populationDF$date <- as.numeric(as.character(populationDF$date))
head(populationDF)
View(populationDF)

# saving the population data in the directory
populationDataRaw <- write_csv(populationDF, "dataRaw/populationDataRaw.csv")


# Downloading the macroeconomic data, including GDP, GDP growth, GNI per capita;
economicData <- wb_data(country = "countries_only", indicator = c("NY.GDP.MKTP.KD", "NY.GDP.MKTP.KD.ZG", "NY.GNP.PCAP.KD"), start_date = 1996, end_date = 2022)
economicData <- as_tibble(economicData)
names(economicData)
economicData <- select(economicData, country, iso2c, iso3c, date, gdp2015 = NY.GDP.MKTP.KD, gdpGrowth = NY.GDP.MKTP.KD.ZG, gniPerCapita = NY.GNP.PCAP.KD)

economicData$date <- as.numeric(as.character(economicData$date))
head(economicData)
View(economicData)

# saving the population data in the directory
economicDataRaw <- write_csv(economicData, "dataRaw/economicDataRaw.csv")


# Downloading the poverty and social inequality data, including poverty gap at $1.90 a day and GINI index;
povertyInequalityData <- wb_data(country = "countries_only", indicator = c("SI.POV.GAPS", "SI.POV.GINI"), start_date = 1996, end_date = 2022)
povertyInequalityData <- as_tibble(povertyInequalityData)
names(povertyInequalityData)
povertyInequalityData <- select(povertyInequalityData, country, iso2c, iso3c, date, gdp2015 = NY.GDP.MKTP.KD, gdpGrowth = NY.GDP.MKTP.KD.ZG, gniPerCapita = NY.GNP.PCAP.KD)

povertyInequalityData$date <- as.numeric(as.character(povertyInequalityData$date))
head(povertyInequalityData)
View(povertyInequalityData)

# saving the population data in the directory
povertyInequalityDataRaw <- write_csv(povertyInequalityData, "dataRaw/povertyInequalityDataRaw.csv")


