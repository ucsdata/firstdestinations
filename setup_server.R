# setwd("C:/Users/Ryan/Documents/data_research position/data projects/first_destination/firstdestinations")

#setup map (US default)
gradmap <- leaflet::leaflet()
gradmap <- leaflet::addTiles(gradmap)
gradmap <- leaflet::fitBounds(gradmap, -125, 25.75, -75, 49)

#add ucsd to the map
ucsd <- c(-117.234, 32.88006)

gradmap <- leaflet::addCircleMarkers(gradmap, lng = ucsd[1], lat = ucsd[2],
                                     opacity = 0.9, radius = 11, 
                                     popup = paste("<b>UCSD</b>"))

#(log) min-max normalization
normalize <- function (x, rem = TRUE) {
  x <- log(x)
  
  if (!is.numeric(x)) 
    return(x)
  mx <- max(x, na.rm = rem)
  mn <- min(x, na.rm = rem)
  if (mx == mn) 
    return((x - mn)/(mx - mn + 1e-06))
  return((x - mn)/(mx - mn))
}

#function to add location data to a map for a given group in a df-list
# Inputs:
#     map: the map to add the locations to
#     group: a character string containing the group name
#     loc.var: location variable (string - either location or grad_univ)
#     color: what color to mark the group
#     dflist: the dataframe list which contains all the dataframes
# Return:
#     marked_map: the map with markers added to it

addGroupLocs <- function(map, group, color, dflist){
  df <- dflist[group][[group]]
  
  df <- df[!is.na(df$lon) & !is.na(df$lat) & 
          (!is.na(df$location) || (!is.na(df$grad_univ))),]
  
  #clean location text
  df$location <- gsub(" +", " ", df$location)
  
  if(group == "continue_edu"){
    df$grad_univ <- gsub(" +", " ", df$grad_univ)
  }
  
  #count frequencies for each location
  if(group == "employed") {
    freq <- as.data.frame(table(df$location))
  } else {
    freq <- as.data.frame(table(df$grad_univ)) 
  }
  
  
  freq <- freq[order(as.character(freq$Var1)),]
  
  #store actual frequencies
  real_freqs <- freq$Freq
  
  #grab corresponding lons/lats from df 
  if(group == "employed") {
    lons <- unique(df[order(as.character(df$location)), c("lon", "location")])
    lats <- unique(df[order(as.character(df$location)), c("lat", "location")])
  } else {
    lons <- unique(df[order(as.character(df$grad_univ)), c("lon", "grad_univ")])
    lats <- unique(df[order(as.character(df$grad_univ)), c("lat", "grad_univ")])
  }
  
  #perform min-max normalization for scaling purposes
  sizes <- normalize(freq$Freq, 10) * 10
  
  #create strings for marker popups
  location_titles <- freq$Var1
  location_titles <- paste0("<b>", location_titles, "</b>")
  location_text <- paste(location_titles, "</br>", "Students:", real_freqs)
  
  #add markers
  marked_map <- addCircleMarkers(map, lng = lons$lon, lat = lats$lat, radius = sizes,
                                 opacity = 0.7, popup = location_text)
  
  return(marked_map)
} 

# Columns for interactive DataTables
select.columns.all <- c("status", "Date Graduated", "Subdepartment", "College",
                        "Age", "Gender")

select.columns.employed <- c("employment_type", "job_title", "base_salary", 
                             "company", "major", "grad_date", "college")

select.columns.c_ed <- c("grad_univ", "grad_program", "grad_degree", "grad_field",
                         "major", "grad_date", "college")

select.columns.other <- c("major", "college", "grad_date", "gender", "age")

select.columns.vol <- c("job_title", "company", "base_salary", "major",
                        "grad_date", "college")