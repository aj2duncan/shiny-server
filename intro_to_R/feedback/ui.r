library(shiny)
library(shinythemes)

# add an asterisk to an input label
labelMandatory = function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}


# CSS to use in the app
appCSS = ".mandatory_star { color: red; } 
.shiny-input-container { margin-top: 25px; }
#submit_msg { margin-left: 15px; }
#error { color: red; }"

shinyUI(fluidPage(theme = shinytheme("united"),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "sliders.css")
    ),
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(appCSS),
    titlePanel("Feedback Form"),
    h4("Hopefully you can answer the questions below and help provide feedback 
       on the Introduction to R Course."),
    p("Please note this questionnaire is entirely anonymous."),
    fluidRow(
      column(3),
      column(6,
        div(
          id = "form",
          sliderInput("course_enjoyment", 
                      p("Did you enjoy the course?", br(), 
                      "(1: Not at all - 5: Completely)"), 
                      1, 5, 3, ticks = TRUE, width = "100%"),
          textInput("course_enjoyment_comment",
                    "Was there anything in particular that you enjoyed?",
                    width = "100%"),
          sliderInput("course_speed", 
                      p("How fast did you find the course?", br(),  
                      "(1: Too slow - 5: Too fast)"),
                      1, 5, 3, ticks = TRUE, width = "100%"),
          sliderInput("course_teaching", 
                      p("How did you find the teaching on the course?", br(), 
                        "(1: Terrible - 5: Excellent)"),
                      1, 5, 3, ticks = TRUE, width = "100%"),
          textInput("course_teaching_comment",
                    "Was there anything in particular that you want to comment on with regard to the teaching?",
                    width = "100%"),
          sliderInput("course_material", 
                      p("How did you find the notes and other course material?", br(), 
                        "(1: Terrible - 5: Excellent)"),
                      1, 5, 3, ticks = TRUE, width = "100%"),
          textInput("course_material_comment", 
                    "Was there anything in particular about the course materials that you'd like to comment on?",
                    width = "100%"),          
          textInput("course_assessments_comment",
                      "What did you think of the final course task?", 
                      width = "100%"),
          textInput("course_best",
                    "What was the best thing about the course?",
                    width = "100%"),
          textInput("course_worst",
                    "What was the worst thing about the course?",
                    width = "100%"),
          textInput("course_improvement",
                    "What (if anything) about the course needs to be improved?",
                    width = "100%"),
          textInput("course_change",
                    "If you could change one thing about the course, what would it be?",
                    width = "100%"),
          actionButton("submit", "Submit", class = "btn-primary"),
          p(br()),
          
          shinyjs::hidden(
            span(id = "submit_msg", "Submitting..."),
            div(id = "error",
                div(br(), tags$b("Error: "), span(id = "error_msg"))
            )
          )
        ),

        shinyjs::hidden(
          div(
            id = "thankyou_msg",
            h3("Thanks, your response was submitted successfully!"),
            actionLink("submit_another", "Submit another response")
          )
        )
      ),
      column(3)
    )
  )
)
