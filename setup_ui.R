#load necessary packages 
packages <- c("leaflet", "plyr", "readxl", "rdrop2", "markdown", "shinythemes")
lapply(packages, library, character.only = T)

#store choices for grad years with available data (which folders exist)
year_choices <- rdrop2::drop_dir("firstdestinations")$name

#the different groups (post-grad status)
groupNames <- c("Employed", "Continuing Education", "Volunteer", "Service")
groupValues <- c("emp","ce","v","svc")
