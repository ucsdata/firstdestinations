#grab the data from dropbox for the selected year

fpath <- paste("firstdestinations/", year, "/master_outcomes.xlsx", sep = "")

rdrop2::drop_download(fpath, local_path = "data", overwrite = T)

#store each sheet as a df in a list
sheetnames <- excel_sheets("data/master_outcomes.xlsx")

mydfs <<- lapply(sheetnames, readxl::read_excel, path = "data/master_outcomes.xlsx")

names(mydfs) <<- sheetnames
