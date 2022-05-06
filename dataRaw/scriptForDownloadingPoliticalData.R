# Script for downloading political data from democracyData

library(democracyData)
library(tidyverse)

# Downloading Freedoom House data on political rights (pr) and civil liberty (cl)

fh <- download_fh(verbose = FALSE)
fh
names(fh)

freedomHouseData <- select(fh, country = fh_country, date = year, politicalRights = pr, civilLiberties = cl, fhCombinedScore = fh_total, fhCombinedScoreReversed = fh_total_reversed,status) %>%
  filter(date > 1995)

head(freedomHouseData)
View(freedomHouseData)

# # saving the freedom house data in the directory
# freedomHouseDataRaw <- write_csv(freedomHouseData, "dataRaw/freedomHouseDataRaw.csv")


# Downloading polity5 data on institutionalized democracy, institutionalized 

polity5Data <- download_polity_annual(verbose = FALSE)
polity5Data
names(polity5Data)

polity5Data <- select(polity5Data, country = polity_annual_country, polityCountryCode = polity_annual_ccode, alphabetCountryCode = scode, date = year, institutionalizedDemocracy = democ,  institutionalizedAutocracy = autoc,  polityScore = polity, polityScoreRevised = polity2, regimeDurability = durable) %>%
  filter(date > 1995)

head(polity5Data)
View(polity5Data)

# Saving the polity data in the directory
polity5DataRaw <- write_csv(polity5Data, "dataRaw/polity5DataRaw.csv")
