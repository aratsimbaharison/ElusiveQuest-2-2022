library(tidyverse)
library(haven)

# Downloading and unzipping the WGI data from the WGI website

temp <- tempfile()
download.file("http://info.worldbank.org/governance/wgi/Home/downLoadFile?fileName=wgidataset_stata.zip",temp)
wgiDataRaw <- read_dta(unz(temp, "wgidataset.dta"))
unlink(temp)

head(wgiDataRaw)
names(wgiDataRaw)

# To view the list of countries in the dataset
unique(wgiDataRaw$countryname)

# In order to be consistent throughout the data collection and analysis, we need to replace "Cape Verde" with"Cabo Verde"

wgiDataRaw$countryname <- replace(wgiDataRaw$countryname, wgiDataRaw$countryname == "Cape Verde", "Cabo Verde")

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


wgiDataRaw <- select(wgiDataRaw, country = countryname, iso3c = code, date = year, stability = pve, voiceAndAccountability = vae, governmentEffectiveness = gee, regulatoryQuality = rqe, ruleOfLaw = rle, corruptionControl= cce)

head(wgiDataRaw)
summary(wgiDataRaw)


# Creating a variable with two category of stability ("stabilityCategory2") with dplyr: "1" for stable country, "0" for unstable country
wgiDataRaw <- mutate(wgiDataRaw,
               stabilityCategory2 = if_else(wgiDataRaw$stability > 0, "stable", "unstable"))
wgiDataRaw$stabilityCategory2 <- as.factor(wgiDataRaw$stabilityCategory2)
head(wgiDataRaw)
summary(wgiDataRaw)
table(wgiDataRaw$stabilityCategory2)

# Assuming that countries with stability scores close to zero are either "moderately stable" (scores from 0 to 0.999) or "moderately unstable"" (scores from -0.999 to 0), we also create a variable with four categories of stability with dplyr based on arbitrary thresholds of + 1 (for highly stable) and - 1 (for highly unstable)
wgiDataRaw <- wgiDataRaw %>% mutate(stabilityCategory4 =cut(stability, breaks=c(-Inf, -1, 0, 1, Inf), labels=c("highly unstable","moderately unstable","moderately stable", "highly stable")))
head(wgiDataRaw)
summary(wgiDataRaw)
table(wgiDataRaw$stabilityCategory4)

# # Making wgiDataRaw available in the directory
# wgiDataRaw <- write_csv(wgiDataRaw, "wgiDataRaw.csv")
# 
# wgiDataRaw1 <- write_csv(wgiDataRaw, "dataRaw/wgiDataRaw.csv")
# 
# wgiDataRaw1 <- read_csv("dataRaw/wgiDataRaw.csv")
# 
# wgiDataRaw1 <- as_tibble(wgiDataRaw1)
# 
# View(wgiDataRaw1)


