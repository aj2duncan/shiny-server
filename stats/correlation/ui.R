library(shiny)

# Define UI for OLS demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Diagnostics for simple linear regression"),
  
  sidebarPanel(
    
    radioButtons("type", "Select a trend:",
                 list("Linear up" = "linear.up",
                      "Linear down" = "linear.down",
                      "Curved up" = "curved.up",
                      "Curved down" = "curved.down",
                      "Fan-shaped" = "fan.shaped")),
    br(),
    
    checkboxInput("show.resid", "Show residuals", FALSE),
    
    br(),
    
    helpText("What we are trying to show with this app is show that correlation alone doesn't necessarily tell us about the fit of the data. Try changing the trend and seeing how the line looks vs the value of the correlation.")),

  
  
  
  # Show the main display
  mainPanel(
    tabsetPanel(
      tabPanel("Linear Regression",
                plotOutput("scatter")
      ),
      tabPanel("Residuals",
                plotOutput("residuals")
      )
    ) # finishing tabsetPanel
  ) # finishing mainPanel
))
