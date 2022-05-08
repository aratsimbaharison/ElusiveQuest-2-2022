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


## Downloading the Data on the UN Country Names and Codes with their Classification into Region and Subregion from a GitHub Repository Maintained by Luke Duncalfe   



# We downloaded the data on the UN country names and codes with their classification into region and subregion from the github repository maintained by Luke Duncalfe   
# at: https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/all/all.csv
# According to the author and contributors to this database, "These lists are the result of merging data from two sources, the Wikipedia ISO 3166-1 article for alpha and numeric country codes, and the UN Statistics site for countries' regional, and sub-regional codes. In addition to countries, it includes dependent territories."

regionSubregionDf <- read_csv("https://raw.githubusercontent.com/aratsimbaharison/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")
regionSubregionDf <- tbl_df(regionSubregionDf)
regionSubregionDf <- select(regionSubregionDf, country = name, iso2c = `alpha-2`, iso3c = `alpha-3`, M49Code = `country-code`, region, subregion = `sub-region`)
regionSubregionDf <- na.omit(regionSubregionDf) # this will get rid of some locations that does not have codes
head(regionSubregionDf)
View(regionSubregionDf)
# In order to be consistent throughout the data collection and analyses, and particularly to align the UN country names and codes with those used by the World Bank, we need to make the following changes:

# The following country names have been changed:

# First, we need to remove the special characters from Cote d'Ivoire and Sao Tome and Principe


regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Côte d'Ivoire", "Cote d'Ivoire")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "São Tomé and Principe", "Sao Tome and Principe")

regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Bahamas", "Bahamas, The")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Bolivia (Plurinational State of)", "Bolivia")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Congo", "Congo, Rep.")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Congo (Democratic Republic of the)", "Congo, Dem. Rep.")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Egypt", "Egypt, Arab Rep.")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Gambia", "Gambia, The")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Hong Kong", "Hong Kong SAR, China")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Korea (Democratic People's Republic of)", "Korea, Dem. People's Rep.")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Korea (Republic of)", "Korea, Rep.")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Iran (Islamic Republic of)", "Iran, Islamic Rep.")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Lao People's Democratic Republic", "Lao PDR")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Macedonia (the former Yugoslav Republic of)", "Macedonia, FYR")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Kyrgyzstan", "Kyrgyz Republic")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Macao", "Macao SAR, China")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Micronesia (Federated States of)", "Micronesia, Fed. Sts")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Moldova (Republic of)", "Moldova")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Palestine, State of", "West Bank and Gaza")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Slovakia", "Slovakia Republic")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Taiwan, Province of China", "Taiwan, China")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Tanzania, United Republic of", "Tanzania")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "United States of America", "United States")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "United Kingdom of Great Britain and Northern Ireland", "United Kingdom")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Yemen", "Yemen, Rep.")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Viet Nam", "Vietnam")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Venezuela (Bolivarian Republic of)", "Venezuela")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Saint Kitts and Nevis", "St. Kitts and Nevis")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Saint Vincent and the Grenadines", "St. Vincent and the Grenadines")
regionSubregionDf$country <- replace(regionSubregionDf$country, regionSubregionDf$country == "Saint Lucia", "St. Lucia")
regionSubregionDf$iso3c <- replace(regionSubregionDf$iso3c, regionSubregionDf$iso3c == "COD", "ZAR")

# The following country names have been deleted:

regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Bonaire, Sint Eustatius and Saba",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Åland Islands",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Anguilla",]

regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Falkland Islands (Malvinas)",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "French Guiana",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "French Polynesia",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Gibraltar",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Guadeloupe",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Holy See",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Isle of Man",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Guernsey",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Jersey",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Martinique",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Mayotte",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Montserrat",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Northern Mariana Islands",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Réunion",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Saint Barthélemy",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Saint Helena, Ascension and Tristan da Cunha",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Saint Martin (French part)",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Sint Maarten (Dutch part)",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Tokelau",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Turks and Caicos Islands",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Wallis and Futuna",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Svalbard and Jan Mayen",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "New Caledonia",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Norfolk Island",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Pitcairn",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Saint Barthélemy",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Saint Pierre and Miquelon",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Western Sahara",]
regionSubregionDf <- regionSubregionDf[! regionSubregionDf$country == "Virgin Islands (British)",]

head(regionSubregionDf)
View(regionSubregionDf)
# List of 208 countries in the world according to the Wikipedia ISO 3166-1 article for alpha and numeric country codes, and the UN Statistics site for countries' regional, and sub-regional codes:
unique(regionSubregionDf$country)

# # Saving the UN country names, codes, regions, and subregion
# unContryNameCodeRegion <- write_csv(regionSubregionDf, "dataRaw/unCountryNameCodeRegion.csv")
