#store a proxy map
proxy <- leaflet::leafletProxy("map", session)

# clear map
proxy <- leaflet::clearMarkers(proxy)
proxy <- leaflet::clearShapes(proxy)

#change between US/World map
if(input$maptype == "US") {
  proxy <- leaflet::fitBounds(proxy, -125,25.75,-75,49)
} else {
  proxy <- leaflet::fitBounds(proxy, -125, -38, -40, 70)
}

#add markers for the selected groups, recursively adding them to the map
proxy <- addGroupLocs(proxy, input$mapGroup, "green", mydfs)