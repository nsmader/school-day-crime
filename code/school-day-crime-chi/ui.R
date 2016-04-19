#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggmap)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("Crime by Time of Day"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("mySchName",
                   "Choose school to zoom to:",
                   choices = schLoc$Short_Name,
                   selected = schLoc$Short_Name[1]),
       dateRangeInput("crimeRange",
                      label = "Select time frame for crimes to display:",
                      start = "2016-01-01",
                      end   = "2016-01-08"),
                      # start = Sys.Date() - 7,
                      # end   = Sys.Date()), # this will really only work when connecting to a more real-time source of crime data
       selectInput("dayTimePeriod",
                   label = "Select the time of day of focus:",
                   choices = c("Midnight to morning (midnight-7am)",
                               "Before school (7-9:30am)",
                               "During school (9:30am-2pm)",
                               "After school (2-4:30pm)",
                               "Evening and night (4:30pm-midnight)"),
                   selected = "Before school (7-9:30am)"),
       selectInput("crimeType",
                   label = "Select the type of crimes to display:",
                   choices = c("All", "Violent crimes", "Drug-related crimes"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("crimeMap"),
      dataTableOutput("crtable")
    )
  )
))
