library(wbstats)
library(tidyverse)
library(haven)

# Downloading and unzipping the WGI data from the WGI website

temp <- tempfile()
download.file("http://info.worldbank.org/governance/wgi/Home/downLoadFile?fileName=wgidataset_stata.zip",temp)
wgiDataRaw <- read_dta(unz(temp, "wgidataset.dta"))
unlink(temp)

head(wgiDataRaw)

write.table(wgiData, file="wgiDataRaw.csv",sep=",",row.names=F)

# In order to be consistent throughout the data collection and analysis, we need to replace "Cape Verde" with"Cabo Verde"

WGI2$country <- replace(WGI2$country, WGI2$country == "Cape Verde", "Cabo Verde")

# Selecting the variables of interest for this study by selecting their estimated values from the WGI dataset:
# Here is the list of the variables with their definition:
# stability (pve): Political Stability and Absence of Violence/Terrorism Estimate – capturing perceptions of the likelihood that the government will be destabilized or overthrown by unconstitutional or violent means, including politically‐motivated violence and terrorism.
# 
# voiceAndAccountability (vae): Voice and Accountability Estimate – capturing perceptions of the extent to which a country's citizens are able to participate in selecting their government, as well as freedom of expression, freedom of association, and a free media.
# 
# governmentEffectiveness (gee): Government Effectiveness Estimate – capturing perceptions of the quality of public services, the quality of the civil service and the degree of its independence from political pressures, the quality of policy formulation and implementation, and the credibility of the government's commitment to such policies.
# 
# regulatoryQuality (rqe): Regulatory Quality Estimate – capturing perceptions of the ability of the government to formulate and implement sound policies and regulations that permit and promote private sector development.
# 
# ruleOfLaw (rle): Rule of Law Estimate – capturing perceptions of the extent to which agents have confidence in and abide by the rules of society, and in particular the quality of contract enforcement, property rights, the police, and the courts, as well as the likelihood of crime and violence.
# 
# corruptionControl (cce): Control of Corruption Estimate – capturing perceptions of the extent to which public power is exercised for private gain, including both petty and grand forms of corruption, as well as "capture" of the state by elites and private interests.


WGI2 <- select(WGI2, country, iso3c = code, date = year, stability = pve, voiceAndAccountability = vae, governmentEffectiveness = gee, regulatoryQuality = rqe, ruleOfLaw = rle, corruptionControl= cce)

head(WGI2)
summary(WGI2)

# The summary shows that there are up to 177 NA in some of the variables, so we decided to impute these missing values using knn imputation:

WGI2 <- kNN(WGI2)
WGI2 <- select(WGI2, country, iso3c, date, stability, voiceAndAccountability, governmentEffectiveness, regulatoryQuality, ruleOfLaw, corruptionControl)
head(WGI2)
summary(WGI2)
