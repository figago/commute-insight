#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinyTime)
library(leaflet)

defValue = strptime("07:30:00", "%T")
cities = list("Antibes"=1, "Nice"=2, "Paris"=3, "Sophia"=4)

# Define UI for application that draws a map
shinyUI(navbarPage("City Mobility Insights",

  tabPanel("Commuter's map",
    tags$head(
             # Include our custom CSS
             includeCSS("main.css")
    ),
    div(class="outer",
        tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),

        # Show a plot of the generated distribution
        leafletOutput("tripMap", width = "100%", height = "100%"),
         
        # Sidebar with a slider input for number of bins 
        absolutePanel(id="controls", top = 70, right = 10,
                      
             timeInput("minDepTime", "Min Departure Time:",
                       value=defValue),
             
             timeInput("maxDepTime", "Max Departure Time:",
                       value=defValue + period(30, units="minute")),
             
             selectInput("city", 
                         "City", 
                         choices=cities, 
                         selected=2,
                         multiple=FALSE, selectize=TRUE)
        )
    )
  ),
  tabPanel(
    "Help",
    div(id="help",
        p("This app shows a map of commuters departures 
          in a given city in a given time range."),
        h2("Outputs"),
        p("Each circle represents a departure of a regular commuter. 
          A regular commuter is a user who commutes at least once a week between two places
          (generally home and work)."),
        h4("Blue circles"),
        p("Active users"),
        h4("Gray circles"),
        p("Inactive users"),
        
        h2("Inputs"),
        h4("Min Departure Time"),
        p("Minimum departure time. All commutes departing before this time are filtered out."),
        h4("Max Departure Time"),
        p("Max departure time. All commutes departing after this time are filtered out."),
        h4("City"),
        p("City around which the map is centered.
          Think of it as a short-cut to repositioning/zooming the map.")

    )
  )
  
))
