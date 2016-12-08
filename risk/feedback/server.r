library(shiny)

# which fields get saved 
fieldsAll = c("module_enjoyment", "module_enjoyment_comment",
              "module_speed", "module_teaching", "module_teaching_comment",
              "module_material", "module_material_comment",  
              "module_assessments_comment",
              "module_best", "module_worst", 
              "module_improvement", "module_change")


# directory where responses get stored
responsesDir = file.path("responses")

# get current Epoch time
epochTime <- function() {
  return(as.integer(Sys.time()))
}

# get a formatted string of the timestamp (exclude colons as they are invalid
# characters in Windows filenames)
humanTime <- function() {
  format(Sys.time(), "%Y%m%d-%H%M%OS")
}

# save the results to a file
saveData <- function(data) {
  fileName <- sprintf("%s_%s.csv",
                      humanTime(),
                      digest::digest(data))
  
  write.csv(x = data, file = file.path(responsesDir, fileName),
            row.names = FALSE, quote = TRUE)
}


shinyServer(function(input, output) {
  
  # Enable the Submit button when all mandatory fields are filled out
  #observe({
  #  shinyjs::toggleState(id = "submit")
  #})
  
  # Gather all the form inputs (and add timestamp)
  formData <- reactive({
    data <- sapply(fieldsAll, function(x) input[[x]])
    data <- c(data, timestamp = epochTime())
    data <- t(data)
    data
  })    
  
  # When the Submit button is clicked, submit the response
  observeEvent(input$submit, {
    
    # User-experience stuff
    shinyjs::disable("submit")
    shinyjs::show("submit_msg")
    shinyjs::hide("error")
    
    # Save the data (show an error message in case of error)
    tryCatch({
      saveData(formData())
      shinyjs::reset("form")
      shinyjs::hide("form")
      shinyjs::show("thankyou_msg")
    },
    error = function(err) {
      shinyjs::html("error_msg", err$message)
      shinyjs::show(id = "error", anim = TRUE, animType = "fade")
    },
    finally = {
      shinyjs::enable("submit")
      shinyjs::hide("submit_msg")
    })
  })
  
  
  # submit another response
  observeEvent(input$submit_another, {
    shinyjs::show("form")
    shinyjs::hide("thankyou_msg")
  })
})