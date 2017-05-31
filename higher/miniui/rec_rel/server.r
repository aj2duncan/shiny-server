# loading packages
library(shiny)
library(ggplot2)
library(scales)
library(latex2exp)

u_n = c(1:101)
u_n_plus_one = c()

shinyServer(function(input, output) {

  create_rec_rel = eventReactive(input$plot, {
    num_terms = input$terms
    u_n = c(1:(num_terms + 1))
    terms = c(1:num_terms)
    u_n[1] = input$u0
    for (i in terms) {
      u_n[i + 1] = input$a * u_n[i] + input$b
    }
    u_n_plus_one = u_n[2:(num_terms + 1)]
    u_n = u_n[1:num_terms]
    if (input$a < 1 && input$a > -1) {
      L = rep(as.numeric(input$b/(1 - input$a)), length.out = num_terms)
    } else {
      L = rep(-exp(1)/pi, length.out = num_terms)
    }
    return(data.frame(cbind(terms = terms,
                            u_n = u_n, 
                            u_n_plus_one = u_n_plus_one
                            )))
  }, ignoreNULL = FALSE) # ignore false should let it run on loading
  
  #output$Regression_plot = renderPlot({
  #  rec_rel = create_rec_rel()
  #  ggplot(rec_rel, aes(x = u_n, y = u_n_plus_one, label = terms)) + 
  #    geom_point() +
  #    geom_text(aes(label = terms, hjust = 0, vjust = 0)) +
  #    labs(x = expression(u[n]), y = expression(u[n + 1]),
  #         title = "Recurrence Relation\nterm by term") +
  #    theme(axis.title = element_text(size = 14),
  #          plot.title = element_text(size = 20, face = "bold")) + 
  #    scale_x_continuous(labels = comma) + 
  #    scale_y_continuous(labels = comma)
  #})
  
  output$Terms_plot = renderPlot({
    rec_rel = create_rec_rel()
    p1 = ggplot(rec_rel, aes(x = terms, y = u_n, label = terms)) + 
      geom_point() +
      geom_text(aes(label = terms, hjust = 0, vjust = 0)) + 
      labs(x = "Term in sequence", 
           y = TeX("Value of u_n"),
           title = "") +
      theme(axis.title = element_text(size = 14),
            plot.title = element_text(size = 20, face = "bold")) + 
      scale_x_continuous(labels = comma) + 
      scale_y_continuous(labels = comma)
    p1
  })
})

