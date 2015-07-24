library(shiny)
library(shinyBS)

# Define UI for random distribution application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Lotka-Volterra Predator Prey Model"),
  
  sidebarLayout(
    sidebarPanel(
      tags$div(
        tags$p("Move the sliders to change the input values of the 
               variables in the system.")
      ),
      sliderInput("N", "Initial Number of Prey", 
                  value = 10, min = 0,  max = 100, step = 1),
      sliderInput("P", "Initial Number of Predators", 
                  value = 10, min = 0,  max = 100, step = 1),
      sliderInput("a", "Rate of Birth for Prey", 
                  value = 0.1, min = 0,  max = 2, step = 0.01),
      sliderInput("b", "Rate of Death for Prey", 
                  value = 0.02, min = 0,  max = 2, step = 0.01),
      sliderInput("c", "Rate of Birth for Predators", 
                  value = 0.02, min = 0,  max = 2, step = 0.01),
      sliderInput("d", "Rate of Death for Predators", 
                  value = 0.4, min = 0,  max = 2, step = 0.01),
      sliderInput("time", "Length of time",
                  value = 500, min = 100, max = 2000, step = 100),
      bsTooltip("time", "Note that the longer the time period, the 
                longer the plots will take to generate.")
    ),
    
  
    mainPanel(
      withMathJax(),
      tags$div(
        tags$p("The plots below show the number of predators and prey as 
               predicted by the ",
        tags$a(href = "https://en.wikipedia.org/wiki/Lotka–Volterra_equation",
               target = '_blank', "Lotka-Volterra"),
               "predator-prey model:
               $$\\begin{align} 
               \\frac{\\textrm{dN}}{\\textrm{dt}} &= a N - b N P \\\\
               \\frac{\\textrm{dP}}{\\textrm{dt}} &= c N P - d P.
               \\end{align}$$
               \\(a\\) and \\(c\\) are the birth rates with \\(b\\) and 
               \\(d\\) the death rates of the prey and predators respectively.
               "),
        tags$p("The first plot shows the number of predators and prey as 
               time progresses. Change the variables and see how the numbers
               change. Can you make either species die out?")
      ),
      plotOutput("plot_numbers"),
      tags$div(
        tags$p("The second plot shows the phase portrait of the system. The
               numbers of prey are plotted along the horizontal, with the 
               predators along the vertical. Where is the equilibrium point?")
      ),
      plotOutput("phase_portrait")
    )
  )
))