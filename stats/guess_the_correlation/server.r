#server.R

library(shiny)
library(ggplot2)
library(ellipse)

shinyServer(
  
  func = function(input, output, clientData, session) {

    #session-specific variables
    correlation <- -1 #current correlation
    score <- 0 #user's score
    answered <- FALSE # an indicator for whether question has been answered

    observe({
      #this observer monitors when input$submit is invalidated
      #and displays the answer
      input$submit
      
      isolate({
        #by isolating input$answer from the observer,
        #we wait until the submit button is pressed before displaying answer
        answer = as.numeric(input$slider)  
      })
      
      if (abs(answer - correlation) < 0.1) {
        output$status1 <- renderText({""})
        output$status2 <- 
          renderText({paste(generateResponse(1),
                            sprintf("(True correlation: %f)",
                                    round(correlation,2)))})
        output$status3 <- renderText({""})
        if (!answered) {
          score <<- score + 10
          output$score <- renderText({sprintf("Your score: %d",score)})
          answered <<- TRUE
        }
      }else if (abs(answer - correlation) < 0.2) {
        output$status1 <- renderText({""})
        output$status2 <- renderText({""})
        output$status3 <- renderText({generateResponse(2)})
        if (!answered) {
          score <<- score + 5
          output$score <- renderText({sprintf("Your score: %d",score)})
          answered <<- TRUE
        }
      } else if (abs(answer - correlation) < 0.3) {
        output$status1 <- renderText({""})
        output$status2 <- renderText({""})
        output$status3 <- renderText({generateResponse(3)})
        if (!answered) {
          score <<- score + 2
          output$score <- renderText({sprintf("Your score: %d",score)})
          answered <<- TRUE
        }
      } else {
        output$status1 <- renderText({""})
        output$status2 <- renderText({""})
        output$status3 <- renderText({generateResponse(4)})
        answered <<- TRUE
      }
      
    })
    
    observe({
      #this observer monitors when input$newplot is invalidated
      #or when input$difficulty is invalidated
      #and generates a new plot
      
      #update plot, calculate correlation
      input$newplot
      
      data = generateData()
      
      #VERY IMPORTANT <<- "double arrow" can assign values 
      #outside of the local envir!
      #i.e. outside of this observer!
      correlation <<- round(cor(data[,1],data[,2]),2)
      
      isolate({observe({
        options = is.na(pmatch(c("Averages", "Standard deviation line",
                                 "Ellipse"), 
                               input$options))
        output$plot1 <- renderPlot({
          p <- ggplot(data, aes(X,Y)) +
            geom_point(size = 4, alpha = 1/2) +
            theme(text = element_text(size = 20),
                  axis.ticks = element_blank(), 
                  axis.text = element_blank()) +
            coord_cartesian(xlim = c(min(data$X) - sd(data$X),
                                     max(data$X) + sd(data$X)),
                            ylim = c(min(data$Y) - sd(data$Y),
                                     max(data$Y) + sd(data$Y))) +
            labs(x = "x", y = "y", 
                 title = "Scatterplot of Correlated Data")
          print(p)
        }) # end renderPlot
      })}) # end isolate and observe
      
      #update radio buttons
      answer_options <- list(correlation,
                             generateAnswer(correlation),
                             generateAnswer(correlation),
                             generateAnswer(correlation),
                             generateAnswer(correlation),
                             generateAnswer(correlation))
      answer_display = answer_options[sample(5, 5, replace = FALSE)]
      updateRadioButtons(session, "answer", choices = answer_display)
      
      #display text
      output$status1 <- renderText({"Mark your answer and click 'Submit!'"})
      output$status2 <- renderText({""})
      output$status3 <- renderText({""})
      
      #reset answered status
      answered <<- FALSE
    })
})

generateData = function() {
  numPoints = 100
  x_center = rnorm(1,0,10)
  x_scale = rgamma(1,4,1)
  X = rnorm(numPoints,x_center,x_scale)
  Y = rnorm(numPoints,rnorm(1)*X,rgamma(1,1)*x_scale)
  return(data.frame(X,Y))
}

generateAnswer = function(correlation) {
  
  #generate answer
  answer = runif(1,-1,1)
  
  #base case
  if (abs(correlation - answer) > 0.05) {
    return(round(answer,2))
  }
  else {
    generateAnswer(correlation)
  }
  
}

generateResponse = function(response){
  if (response == 1) {
    print(sample(list("Correct!","Spot on!","Got it!"),1)[[1]])
  }
  else if (response == 2) {
    print(sample(list("Almost.","Close.","Just a bit off.."),1)[[1]])
  }
  else if (response == 3) {
    print(sample(list("Warmer...","Getting there..."),1)[[1]])
  }
  else if (response == 4) {
    print(sample(list("Try again.","Nope!"),1)[[1]])
  }
}
