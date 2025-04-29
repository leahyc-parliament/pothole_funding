library(dplyr)

local_authories_2020 <- read.csv("ons_authorities/2020/LAD_(Dec_2020)_Names_and_Codes_in_the_United_Kingdom.csv") |>
  select(ons_code = LAD20CD, authority = LAD20NM)
  
combined_authorities_2020 <- read.csv("ons_authorities/2020/Combined_Authorities_(Dec_2020)_Names_and_Codes_in_England.csv") |> 
  select(ons_code = CAUTH20CD, authority = CAUTH20NM) |> 
  mutate(authority = paste0(authority, " CA"))

upper_tier_authorities_2020 <- read.csv("ons_authorities/2020/Ward to Westminster Parliamentary Constituency to LAD to UTLA (Dec 2020) Lookup in UK (V2).csv") |>
  select(ons_code = UTLA20CD, authority = UTLA20NM) |> 
  distinct(ons_code, .keep_all = TRUE) |> 
  mutate(authority = paste0(authority, " UTLA"))

authorities_2020 <- bind_rows(local_authories_2020, combined_authorities_2020, upper_tier_authorities_2020)
