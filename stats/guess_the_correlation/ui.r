#ui.R

library(shiny)
library(shinythemes)
library(ggplot2)
library(ellipse)


shinyUI(fluidPage(theme = shinytheme("united"),
  
  titlePanel("Guess the Correlation Coefficient"),                
                  
  fluidRow(
    column(width = 12, 
           withMathJax(),
    tags$div(tags$p('The idea here is to guess the value of the 
                      correlation coefficient of the random data 
                      shown in the plot below.'),
             tags$p('Remember that data which is perfectly correlated 
                      will have a correlation coefficient of 1 or -1 and 
                      look like a perfectly straight line.'),
             tags$p('If you get with 0.1 of the actual correlation
                    you will be created with the right answer.')
            ) # finishing div
  )), # finishing the first row
  fluidRow(column(
    width = 4,
    br(),
    br(),
    br(),
    br(),
    sliderInput("slider",
                label = "The correlation between X and Y is...",
                min = -1, max = 1, value = 0, step = 0.01),
    p(textOutput("status1"), style = "font-weight=500; color: #000000;"),
    h5(textOutput("status2"), style = "font-weight=500; color: #00CC00;"),
    h5(textOutput("status3"), style = "font-weight=500; color: #FF0000;"),
    br(),
    actionButton("submit","Submit"),
    actionButton("newplot","New Plot"),
    br(),
    h4(textOutput("score"))
  ),
    
  column(width = 8,plotOutput("plot1",width = "500px",height = "500px"))
            
  )
))
