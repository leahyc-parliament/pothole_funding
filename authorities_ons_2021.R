library(dplyr)
library(readxl)

local_authories_2021 <- read_excel("ons_authorities/2021/LAD_DEC_2021_UK_NC.xlsx") |>
  select(ons_code = LAD21CD, authority = LAD21NM)

combined_authorities_2021 <- read_excel("ons_authorities/2021/CAUTH_DEC_2021_EN_NC_v2.xlsx") |> 
  select(ons_code = CAUTH21CD, authority = CAUTH21NM) |> 
  mutate(authority = paste0(authority, " CA"))

counties_2021 <- read.csv("ons_authorities/2021/Counties_(Dec_2021)_Names_and_Codes_in_England.csv") |> 
  select(ons_code = CTY21CD, authority = CTY21NM)

# upper_tier_authorities_2020 <- read.csv("ons_authorities/2020/Ward to Westminster Parliamentary Constituency to LAD to UTLA (Dec 2020) Lookup in UK (V2).csv") |>
#   select(ons_code = UTLA20CD, authority = UTLA20NM) |> 
#   distinct(ons_code, .keep_all = TRUE) |> 
#   mutate(authority = paste0(authority, " UTLA"))

authorities_2021 <- bind_rows(local_authories_2021, combined_authorities_2021, counties_2021)
