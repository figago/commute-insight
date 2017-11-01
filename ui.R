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

defValue = strptime("07:30:00", "%T")
cities = list("Antibes"=1, "Nice"=2, "Paris"=3, "Sophia"=4)

# Define UI for application that draws a histogram
#shinyUI(bootstrapPage(
shinyUI(bootstrapPage(
 
  tags$head(
    # Include our custom CSS
    includeCSS("main.css")
  ), 
  
  # Application title
  titlePanel("Commuter Mobility Insight"),
  
  
 
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
        
    
    
  
))
