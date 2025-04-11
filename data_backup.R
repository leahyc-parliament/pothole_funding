# change URL (line7) and file name (line25) to scrape all tables on a HTML 

library(httr2)
library(XML)
library(openxlsx)

url = "https://www.gov.uk/government/publications/highways-maintenance-funding-allocations/highways-maintenance-block-formula-allocations-2025-to-2026"

response <- request(url) |> 
  req_perform() |> 
  resp_body_string() |> 
  htmlParse() |> 
  readHTMLTable()

excel_file <- createWorkbook()

for (i in seq_along(response)) {
  addWorksheet(excel_file, sheetName = i)
  writeData(excel_file, sheet=i, x=response[[i]])
}

if (!dir.exists("data_backup")) {
  dir.create("data_backup")
}
saveWorkbook(excel_file, "data_backup/tables_2025_2026.xlsx", overwrite = TRUE)