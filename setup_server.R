#setup map (US default)
gradmap <- leaflet::leaflet()
gradmap <- leaflet::addTiles(gradmap)
gradmap <- leaflet::fitBounds(gradmap, -125, 25.75, -75, 49)

#add ucsd to the map
ucsd <- c(-117.234, 32.88006)

gradmap <- leaflet::addCircleMarkers(gradmap, lng = ucsd[1], lat = ucsd[2],
                                     opacity = 0.9, radius = 11, 
                                     popup = paste("<b>UCSD</b>"))

#min-max normalization
normalize <- function (x, rem = TRUE) {
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
#     color: what color to mark the group
#     dflist: the dataframe list which contains all the dataframes
# Return:
#     marked_map: the map with markers added to it

addGroupLocs <- function(map, group, color, dflist){
  df <- dflist[group][[group]]
  
  df <- df[!is.na(df$lon) & !is.na(df$lat) & !is.na(df$location),]
  
  #clean location text
  df$location <- gsub(" +", " ", df$location)
  
  #count frequencies for each location
  freq <- as.data.frame(table(df$location))
  freq <- freq[order(as.character(freq$Var1)),]
  
  #store actual frequencies
  real_freqs <- freq$Freq
  
  #grab corresponding lons/lats from df 
  lons <- unique(df[order(as.character(df$location)), c("lon", "location")])
  lats <- unique(df[order(as.character(df$location)), c("lat", "location")])
  
  lons <- lons[!duplicated(lons$location),]
  lats <- lats[!duplicated(lats$location),]
  
  #perform min-max normalization for scaling purposes
  sizes <- normalize(freq$Freq, 10) * 10
  
  #create strings for marker popups
  location_titles <- gsub(" ", ", ", freq$Var1)
  location_titles <- paste0("<b>", location_titles, "</b>")
  location_text <- paste(location_titles, "</br>", "Students:", real_freqs)
  
  #add markers
  marked_map <- addCircleMarkers(map, lng = lons$lon, lat = lats$lat, radius = sizes,
                                 opacity = 0.7, popup = location_text)
  
  return(marked_map)
} 

#function to recursively update a map from a list of maps