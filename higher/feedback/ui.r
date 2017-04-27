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
       on the maths classes you've attended this year."),
    p("Please note this questionnaire is entirely anonymous."),
    fluidRow(
      column(3),
      column(6,
        div(
          id = "form",
          selectInput("course", labelMandatory("Class"), 
                      choices = c("Higher", "Maths for Science")),
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
          sliderInput("course_equipment", 
                      p("How did you find the classrooms and equipment on the course?", br(), 
                        "(1: Terrible - 5: Excellent)"),
                      1, 5, 3, ticks = TRUE, width = "100%"),
          sliderInput("course_variation", 
                      p("How did you find the variety of activities on the course?", br(), 
                        "(1: No variation - 5: Too varied)"),
                      1, 5, 3, ticks = TRUE, width = "100%"),
          sliderInput("course_assessments",
                      p("Did you feel prepared for the course assessments?", br(), 
                      "(1: Not at all - 5: Completely)"), 1, 5, 3, ticks = TRUE, 
                      width = "100%"),
          textInput("course_assessments_comment",
                      "Is there anything you think could have helped with this?", 
                      width = "100%"),
          sliderInput("statistics",
                      p("(Higher Only) Did you enjoy the additional statistics unit?", 
                      br(), "(1: Not at all - 5: Completely)"), 1, 5, 3, ticks = TRUE, 
                      width = "100%"),
          textInput("statistics_comment",
                    "(Higher Only) Anything about the statistics that you want to comment on?",
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
