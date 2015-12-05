# loading packages
library(shiny)
library(shinythemes)

# Define UI for OLS demo application
shinyUI(fluidPage(theme = shinytheme("united"),
                  
                  #  Application title
                  headerPanel("Recurrence Relations"),
                  sidebarPanel(
                    sliderInput("a", "Value of a:", min = -3, max = 3,
                                value = 1.5, step = 0.1),
                    sliderInput("b", "Value of b:", min = -15, max = 15,
                                value = 4, step = 1),
                    numericInput("u0", "Initial value", min = -100, 
                                 max = 100, step = 1, value = 1),
                    numericInput("terms", "Number of Terms to Plot", min = 5,
                                 max = 100, step = 1, value = 20),
                    withMathJax(helpText("Once you change the values of the \\(a\\), \\(b\\) and \\(u_0\\) click on the button to plot them.")),
                    actionButton("plot", "Plot the Recurrence Relation")
                  ),
                  # Show the main display
                  mainPanel(
                    withMathJax(
                      helpText("Use this Shiny app to investigate the behaviour of recurrence relations and how they approach their limit (if they have one)."),
                      helpText("The plots below show the values of the recurrence relation you've chosed in two ways."),
                      helpText("The first shows the value of the recurrence relation as the terms increase whilst the second plot shows the sequence as coordinates in the form \\((u_n, u_{n+1})\\). In both plots the points are labelled with the term in the sequence they represent. \\((1^{st}, 2^{nd}, 3^{rd}, \\ldots)\\)"),
                      helpText("Remember that for a recurrence relation of the form \\(u_{n+1} = au_n + b\\) the limit is given by $$L = \\frac{b}{1-a}$$ and only exists when $$ -1 < a < 1.$$")
                      ),
                    column(width = 6, 
                           plotOutput("Terms_plot")),
                    column(width = 6,
                           plotOutput("Regression_plot")),
                    withMathJax(
                      helpText("You should see that if you get a recurrence relation with a limit, the first plot tends to a horizontal line and the second just ends up in one place. This is because the first plot is plotting the points \\((n, L)\\) and the second is plotting the \\((L, L)\\) again and again and again."))
                  ) # finishing mainPanel
))
