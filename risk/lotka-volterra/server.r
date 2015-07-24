#------ Loading libraries needed for app --------------------------------------
library(shiny)
library(deSolve)
library(ggplot2)
library(tidyr)

#------ Function for Lotka-Volterra system ------------------------------------
lvmodel = function(t, state, parameters){
  with(as.list(c(state, parameters)),{
    #rate of change
    dN = (a * N) - (b * N * P)
    dP = (c * N * P) - (d * P)
    list(c(dN, dP))
  })
}

#----- Function to calculate solution to Lotka-Volterra system ----------------
lotka_volterra = function(N_in, P_in, a_in, b_in, c_in, d_in, time_limit){
  times = seq(0, time_limit, by = 0.05)
  parameters = c(a = a_in, b = b_in, c = c_in, d = d_in)
  state = c(N = N_in, P = P_in)
  results = data.frame(ode(y = state, times = times, func = lvmodel, 
                           parms = parameters))
  return(results)
}


shinyServer(function(input, output, session) {
  # ------------- get data from slider inputs ---------------------------------
  data = reactive({
    lotka_volterra(N_in = input$N, 
                   P_in = input$P, 
                   a_in = input$a, 
                   b_in = input$b, 
                   c_in = input$c, 
                   d_in = input$d,
                   time_limit = input$time)
                  
  })
  
  # -------- Generate plot of numbers of predator/prey ------------------------
  output$plot_numbers <- renderPlot({
    out_long = gather(data(), species, num_anim, N:P)
    
   ggplot(out_long, aes(x = time, y = num_anim, colour = species)) + 
      geom_line(size = 1) + 
      labs(x = "Time", y = "Number of Animals",
           title = "Number of Predator and Prey against Time") +
      scale_colour_discrete(name = "Species", labels = c("Prey", "Predator")) +
      theme(text = element_text(size = 18))
  })
  
  # -------- Generate phase portrait ------------------------------------------
  output$phase_portrait <- renderPlot({
    ggplot(data(), aes(x = N, y = P)) + 
      geom_point() +
      labs(x = "Number of Prey", y = "Number of Predators",
           title = "Phase Plot of Predator-Prey Model") +
      theme(text = element_text(size = 18))
  })
  
})