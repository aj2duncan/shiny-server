# Define server logic required to sort data and draw plot
shinyServer(function(input, output) {
  
  output$diamondsPlot <- renderPlot({
    
    # gather info from user but only when asked
    num_diamonds <- isolate(input$diamonds)
    types_cut <- isolate(input$cut)
    
    # listen to go button
    input$go
    
    # sample correct number
    diamonds_to_plot <- sample_n(diamonds, num_diamonds)
    # filter cut
    diamonds_to_plot <- filter(diamonds_to_plot, cut %in% types_cut)
    
    # draw correct plot
    if (input$plot_type == "Barplot") {
      # draw barplot
      ggplot(diamonds_to_plot, aes(x = cut, fill = cut)) + 
        geom_bar()
    } else {
      # draw scatterplot
      ggplot(diamonds_to_plot, aes(x = carat, y = price, colour = cut)) +
        geom_point(size = 2.5)
    }
  })
})