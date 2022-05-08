## Collecting the data on armed conflicts from UCDP, after reading the article on ViEWS (political violence early-warning system) by Hegre et al. (2019):

library(tidyverse)
library(xlsx)

# # Download a file from the web
# temp <- tempfile()
# download.file("https://ucdp.uu.se/downloads/ucdpprio/ucdp-prio-acd-211-csv.zip",temp)
# conflictData <- read_csv(temp, "ucdp-prio-acd-211-csv.zip")
# unlink(temp)

# Saving the raw data in the directory
conflictDataRaw <- write_csv(conflictData, "dataRaw/conflictDataRaw.csv")
# Reading the data into r
conflictDataRaw <- read_csv("dataRaw/conflictDataRaw.csv", skip = 1)
head(conflictDataRaw)
names(conflictDataRaw)

# To view the list of countries in the dataset
unique(conflictDataRaw$location)

