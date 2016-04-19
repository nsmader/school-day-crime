setwd("~/GitHub/school-day-crime/")

#------------------------------------------------------------------------------#
### Read data ------------------------------------------------------------------
#------------------------------------------------------------------------------#

### Read in school locations data
#schLoc <- readOGR(dsn = "./data", layer = "sch-locations-1516", encoding = "UTF-8")@data
schLoc <- read.csv("https://data.cityofchicago.org/api/views/mb74-gx3g/rows.csv",
                   stringsAsFactors = FALSE)
schLoc <- schLoc[order(schLoc$Short_Name),]
schLoc <- within(schLoc, {
  #schTitle <- sapply(Short_Name, simpleCap)
  popUpTxt <- paste(p0("<b>School: ", Short_Name, "</b>"),
                    p0("Governance: ", Governance),
                    p0("Network: ", Network), sep = "<br/>")
  
})

### Read crime data
# /!\ Need to connect this to the City of Chicago API
crime <- read.csv("data/Crimes_-_2015_to_present.csv",
                  stringsAsFactors = FALSE)
c2 <- within(crime, {
  dDate <- mdy_hms(Date)
  time <- hour(dDate) + minute(dDate)/60
  daytimepd <- cut(time,
                   breaks = c(0, 7, 9.5, 14, 16.5, 24),
                   labels = c("Midnight to morning (midnight-7am)",
                              "Before school (7-9:30am)",
                              "During school (9:30am-2pm)",
                              "After school (2-4:30pm)",
                              "Evening and night (4:30pm-midnight)"))
  
  type_viol <- grepl("ASSAULT|BATTERY|HOMICIDE", Primary.Type)
  type_drug <- grepl("NARCOTICS", Primary.Type)
  type_all <- TRUE
}) %>%
  subset(!is.na(Latitude) & !is.na(Longitude))