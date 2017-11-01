#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(leaflet)
library(lubridate)


citiesBounds = list("Antibes"=c(7.0755705, 43.567747, 7.155705, 43.597747),
                    "Nice"=c(7.239157, 43.678512, 7.269157, 43.718512),
                    "Paris"=c(2.312082, 48.821456, 2.392082, 48.911456),
                    "Sophia"=c(7.02115, 43.610234, 7.055615, 43.631234))
                    

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  tileUrl <- "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png"
  tt <- read.csv("triptemplates_20171027.csv")
  
  tt$activeColor <- "blue"
  tt$activeColor[tt$active=="false"] <- "gray"
  
  timeFormat <- "%H%M"
  
  minLngBound <- 7.239157
  maxLngBound <- 7.269157
  minLatBound <- 43.678512
  maxLatBound <- 43.718512
  
  # add a char vector with the time of departure in local timezone
  tt <- mutate(tt,
               depDatetimeLocal=parse_date_time(depDatetimeLocal,
                                                "ymdHMS"),
               depTime=format(depDatetimeLocal, timeFormat))
  
  minDepTime <- reactive({format(input$minDepTime, timeFormat)})
  maxDepTime <- reactive({format(input$maxDepTime, timeFormat)})
  city <- reactive({input$city})
  
  filteredTt <- reactive({
    tt[minDepTime() <= tt$depTime & tt$depTime <= maxDepTime(),] 
  })
  
  output$tripMap <- renderLeaflet({
    leaflet(tt) %>%
      # setView(7.269157, 43.698512, zoom=14) %>%
      # setView(zoom=14) %>%
      fitBounds(minLngBound, minLatBound,
               maxLngBound, maxLatBound) %>%
      addTiles(urlTemplate = tileUrl) %>%
      addLegend(position="bottomleft",
                labels=c("Active", "Inactive"),
                colors=c("blue", "gray"))
  })
  
  # redraw the filtered trip templates without completely destroying the old map
  # using leafletProxy
  observe({
    newdata <- filteredTt()
    leafletProxy("tripMap", data=newdata) %>% 
      clearMarkers() %>% clearShapes() %>%
      addCircleMarkers(lat=~departureLat,
                       lng=~departureLng,
                       weight=1,
                       color=tt$activeColor)
  })
  
  observe({
    bounds <- citiesBounds[as.integer(city())][[1]]
    print(city())
    print(bounds)
    print(bounds[3])
    
    leafletProxy("tripMap", data=filteredTt()) %>%
      # setView(bounds[1], bounds[2], zoom=14)
      fitBounds(bounds[1], bounds[2],
              bounds[3], bounds[4])      
  })
       
})
