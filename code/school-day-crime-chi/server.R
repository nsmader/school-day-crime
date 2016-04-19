#
# This is the server logic for displaying Chicago crime data by time of day
# in the vicinity of schools
#
# Author: Nick Mader (nsmader@gmail.com)
#

#------------------------------------------------------------------------------#
### Set up workspace -----------------------------------------------------------
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
### Set server operations ------------------------------------------------------
#------------------------------------------------------------------------------#

shinyServer(function(input, output) {
  
  mapSch <- reactive(schLoc[schLoc$Short_Name == input$mySchName,])
  
  # Read in crime data for the requested time
  #GET("https://data.cityofchicago.org/resource/6zsd-86xi.json?")
  crselect <- reactive(subset(c2,
                              dDate >= ymd(input$crimeRange[1]) &
                              dDate <= ymd(input$crimeRange[2]) &
                              daytimepd == input$dayTimePeriod  &
                              switch(input$crimeType,
                                     "All" = get("type_all"),
                                     "Violent crimes" = get("type_viol"),
                                     "Drug-related crimes" = get("type_drug"))))
  
  output$crimeMap <- renderLeaflet({
    
    leaflet(data = schLoc) %>%
      addTiles() %>%
      addMarkers(~Long, ~Lat, popup = ~popUpTxt) %>%
      addPopups(lng = mapSch()$Long, lat = mapSch()$Lat, mapSch()$popUpTxt,
                options = popupOptions(closeButton = TRUE)) %>%
      addCircles(data = crselect(), lat = ~Latitude, lng = ~Longitude, popup = ~popUpTxt, color = "red", radius = 20) %>%
      setView(lng = mapSch()$Long, lat = mapSch()$Lat, zoom = 15)
    
    
  })
  
  output$crtable <- renderDataTable(crselect())
  
})
