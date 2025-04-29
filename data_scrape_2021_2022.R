library(httr2)
library(XML)
library(dplyr)

url_2021 = "https://www.gov.uk/government/publications/highways-maintenance-funding-allocations/highways-maintenance-funding-formula-allocations-2021-to-2022"

response <- request(url_2021) |> 
  req_perform() |> 
  resp_body_string() |> 
  htmlParse()

tables_2021 <- readHTMLTable(response)
  
tables_2021 <- tables_2021[3:4] |> 
  lapply(function(table) {
    colnames(table)[1] <- "Authority" # renaming col 1
    colnames(table)[2] <- "Pothole and Challenge Fund" 
    colnames(table)[3] <- "HMB needs"
    colnames(table)[4] <- "HMB incentive"
    colnames(table)[5] <- "ITB"
    colnames(table)[6] <- "Total"
    table[[1]] <- gsub(" UA$", "", table[[1]]) # removing "UA" from some authority names)
    table[[1]] <- gsub("Sheffield City Region CA", "South Yorkshire CA", table[[1]])
    table[[1]] <- gsub("West Midlands ITA", "West Midlands CA", table[[1]])
    return(table)
  })

tables_combined_2021 <- bind_rows(tables_2021)

  # lapply(function(table) {
  #   colnames(table)[1] <- "Authority" # renaming column 1
  #   colnames(table)[2] <- "Pothole and Challenge Fund" # renaming column 2
  #   table[[1]] <- gsub("^\\s*-\\s*", "", table[[1]]) # removing "-" from start of some authority names
  #   table[[1]] <- gsub("\\[footnote [0-9]+\\]$", "", table[[1]]) # removing "[footnote x]" from some authority names
  #   table[[1]] <- gsub("Cambridgeshire & Peterborough CA", "Cambridgeshire and Peterborough CA", table[[1]])
  #   table[, 2:6] <- as.data.frame(lapply(table[, 2:6], function(column) { # replacing "-" with text in gsub
  #     ifelse(
  #       grepl(" CA$", table[[1]]), 
  #       gsub("^-$", "Money allocated to local authority", column), 
  #       gsub("^-$", "Money allocated to combined authority", column)
  #     )
  #   }))
  #   return(table)
  # })

# rows_to_drop <- c("South East",
#                   "East Midlands", 
#                   "West Midlands", 
#                   "North West",
#                   "North East",
#                   "Yorkshire and the Humber",
#                   "East of England",
#                   "South West")

# tables_combined_2021 <- bind_rows(tables_2021) |>
#   filter(!`Authority` %in% rows_to_drop)



# check for unmatched rows
unmatched_rows <- anti_join(tables_combined_2021, 
                            authorities_2021, 
                            by = c("Authority" = "authority")) 

# fixing unmatched rows (UTLAs)
# tables_combined_2020 <-  tables_combined_2020 |> 
#   mutate(`Authority` = ifelse(
#     `Authority` %in% unmatched_rows$`Authority`,
#     paste0(`Authority`, " UTLA"),
#     `Authority`
#   ))

# check again for unmatched rows
# unmatched_rows <- anti_join(tables_combined_2020, 
#                             authorities, 
#                             by = c("Authority" = "authority")) 

# final data
final_2021 <- left_join(tables_combined_2021, 
                        authorities_2021, 
                        by = c("Authority" = "authority"))

# export
if (!dir.exists("output_data")) {
  dir.create("output_data")
}
write.csv(final_2021, "output_data/capital_expenditure_2021.csv", row.names = FALSE)



