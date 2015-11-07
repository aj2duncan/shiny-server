library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("united"),
  
  headerPanel("Distribution Calculator"),
  
  sidebarPanel(
    #radio button or dropdown?

    selectInput(inputId = "dist",
                label = "Distribution:",
                choices = c("Normal" = "rnorm",
                            "Binomial" = "rbinom"),
                selected = "rnorm"),
    br(),
    uiOutput("mean"),
    uiOutput("sd"),
    uiOutput("n"),
    uiOutput("p"),
    br(),
    br(),
    h4("Model:"),
    div(textOutput("model"), style = "text-indent:20px;font-size:125%;"),
    br(),
    uiOutput("tail"),
    uiOutput("lower_bound"),
    uiOutput("upper_bound"),
    uiOutput("a"),
    uiOutput("b")
  ), #ending sidebarPanel
  mainPanel(
    div(p("This app allows you to calculate the probability of an event based on a normal distribution or a binomial distribution. You can change the type of test you wish to do by changing the model. The distribution values and the value being tested can be altered by changing the sliders.")),
    plotOutput("plot"),
    div(textOutput("area"), align = "center", style = "font-size:150%;")
  ) #ending mainPanel
))