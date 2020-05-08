# load packages
library(shiny)
library(tidyverse)

# put diamond cut in alphabetical order
diamond_choices <- levels(diamonds$cut)

# Define what the user sees
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Diamonds"),
    
    # Sidebar with inputs for user to control 
    sidebarLayout(
        sidebarPanel(
            selectInput(label = "Type of plot", inputId = "plot_type",  
                        choices = c("Scatterplot", "Barplot")),         
            sliderInput(label = "Number of Diamonds",              
                        inputId = "diamonds",
                        min = 1, max = 10000, value = 500),
            selectizeInput(label = "Choose cut",                        
                           inputId = "cut",                             
                           choices = diamond_choices,                   
                           selected = diamond_choices,                  
                           multiple = TRUE),                            
            actionButton(inputId = "go", label = "Plot Data")
        ),
        
        # Show the generated plot
        mainPanel(plotOutput("diamondsPlot"))
    )
)
)
