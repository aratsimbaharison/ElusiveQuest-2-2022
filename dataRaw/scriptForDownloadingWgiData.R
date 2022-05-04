library(wbstats)
library(tidyverse)
library(haven)


wgi_indicators <- wb_search(pattern = "wgi")
wgi_indicators <- as_tibble(wgi_indicators)
wgi_indicators

#To view the list of world governance indicators
View(wgi_indicators)

# Downloading the wgi data from the World Bank website led to the problem of having to download each variable one by one and the limitation of the series to 2013.

# Example: downloading the outcome variable political stability estimates (polStabEst) = GV.POLI.ST.ES

polStabEstData <- wb_data(indicator = "GV.POLI.ST.ES", country = "countries_only", start_date = 2000, end_date = 2020)
head(polStabEstData)
names(polStabEstData)
polStabEstData <- select(polStabEst, iso2c, iso3c, country, date, polStabEst = GV.POLI.ST.ES)
View(polStabEstData)



# Directly download and unzip the file from WGI website

temp <- tempfile()
download.file("http://info.worldbank.org/governance/wgi/Home/downLoadFile?fileName=wgidataset_stata.zip",temp)
wgiDataRaw <- read_dta(unz(temp, "wgidataset.dta"))
unlink(temp)

head(wgiDataRaw)

write.table(wgiData, file="wgiDataRaw.csv",sep=",",row.names=F)

