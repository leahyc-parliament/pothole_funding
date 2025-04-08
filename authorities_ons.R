library(dplyr)

local_authories <- read.csv("ons_authorities/Local_Authority_Districts_(December_2024)_Names_and_Codes_in_the_UK.csv") |>
  select(ons_code = LAD24CD, authority = LAD24NM)
  
combined_authorities <- read.csv("ons_authorities/Combined_Authorities_(May_2024)_Names_and_Codes_in_England.csv") |> 
  select(ons_code = CAUTH24CD, authority = CAUTH24NM) |> 
  mutate(authority = paste0(authority, " CA"))

authorities <- bind_rows(local_authories, combined_authorities)

