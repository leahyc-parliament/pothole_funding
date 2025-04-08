library(httr2)
library(XML)
library(dplyr)

url_2020 = "https://www.gov.uk/government/publications/highways-maintenance-funding-allocations/highways-maintenance-and-itb-funding-formula-allocations-2020-2021"

response <- request(url_2020) |> 
  req_perform() |> 
  resp_body_string() |> 
  htmlParse()

tables_2020 <- readHTMLTable(response) |> 
  lapply(function(table) {
    colnames(table)[1] <- "Authority (local & combined)" # renaming column 1
    colnames(table)[2] <- "Pothole and Challenge Fund" # renaming column 2
    table[[1]] <- gsub("^\\s*-\\s*", "", table[[1]]) # removing "-" from start of some authority names
    table[[1]] <- gsub("\\[footnote [0-9]+\\]$", "", table[[1]]) # removing "[footnote x]" from some authority names
    table[, 2:6] <- as.data.frame(lapply(table[, 2:6], function(column) { # replacing "-" with text in gsub
      ifelse(
        grepl(" CA$", table[[1]]), 
        gsub("^-$", "Money allocated to local authority", column), 
        gsub("^-$", "Money allocated to combined authority", column)
      )
    }))
    table <- as.data.frame(table)
    return(table)
  })

# for (i in seq_along(tables_2020)) {
#   assign(paste0("table_", i, "_2020"), tables_2020[[i]])
# }

tables_combined_2020 <- bind_rows(tables_2020) 


# gsub("^\\s*-\\s*", "", df[[1]])
# gsub("\\[footnote \d+\\]$", "", df[[1]])