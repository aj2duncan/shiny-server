# loading packages
library(shiny)
library(miniUI)
miniPage(
  miniTitleBar("Recurrence Relations"),
  miniTabstripPanel(
    miniTabPanel("Info", icon = icon("info"),
                 miniContentPanel(withMathJax(
                   helpText("Use this Shiny app to investigate the behaviour of recurrence relations and how they approach their limit (if they have one)."),
                   helpText("The plot tab shows the values of the recurrence relation as the terms increase. The points are labelled with the term in the sequence they represent. \\((1^{st}, 2^{nd}, 3^{rd}, \\ldots)\\)"),
                   helpText("Remember that for a recurrence relation of the form \\(u_{n+1} = au_n + b\\) the limit is given by $$L = \\frac{b}{1-a}$$ and only exists when $$ -1 < a < 1.$$"),
                   helpText("Use the inputs to control the recurrence relation and then plot the results.")
                 ))
    ),
    miniTabPanel("Inputs", icon = icon("sliders"),
                 miniContentPanel(
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
                 )
    ),
    miniTabPanel("Results", icon = icon("line-chart"),
                 miniContentPanel(
                   plotOutput("Terms_plot"),
                   textOutput("text"),
                   withMathJax(
                     helpText("You should see that if you get a recurrence relation with a limit the plot tends to a horizontal line. This is because we are plotting the points \\((n, L)\\) and \\(L\\) is always the same."))
                 )
    )
  )
)
