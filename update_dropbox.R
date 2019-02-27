#generate folder path check if year entered is existing or new
folderpath <- paste("firstdestinations/",input$newyear, sep = "")

#if folder doesn't exist create it first
if(!(rdrop2::drop_exists(folderpath))) rdrop2::drop_create(folderpath)

#either rewrite file in existing folder or upload it to the new one
rdrop2::drop_upload(input$newdata$datapath, path = folderpath, autorename = F)

#set proper filename by copying file and deleting old one(s)
filepath_original <- paste(folderpath,"/0.xlsx", sep = "")
filepath_new <- paste(folderpath,"/master_outcomes.xlsx", sep = "")

if(rdrop2::drop_exists(filepath_new))  rdrop2::drop_delete(filepath_new)

rdrop2::drop_copy(filepath_original, filepath_new)
rdrop2::drop_delete(filepath_original)
