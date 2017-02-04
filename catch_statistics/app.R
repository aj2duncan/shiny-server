# load packages
library(shiny)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(shinythemes)


# read in data
tot_rod_catch_long = read_csv("data/rod_catch_clean.csv")

ui <- fluidPage(theme = shinytheme("united"),
  titlePanel("Scottish River Rod Catch Statistics"),
  includeCSS("../css/sliders.css"),
  fluidRow(
    column(12, 
           p("This", 
             a(href = "http://shiny.rstudio.com", target = "_blank", "shiny"), 
             "app calculates and plots the total rod catch of various species
             of fish in Scottish Rivers. The data was collected by marine
             scotland as is available online", 
             a(href = "http://www.gov.scot/Topics/marine/Publications/stats/SalmonSeaTroutCatches/2015/rodcatchretained", target = "_blank",
               "here")),
           p("You can use the slider and dropdown menus below to change what
             is shown in the plot. You can select", strong("multiple"),
             "rivers but only one species. Once you've made your selections,
             click the button to change the plot. If you wish to add the trend,
             click the tickbox."),
           p(strong("If you want to find the exact values of the catch 
                    each year hover your mouse over the chosen year."))
           )
  ),
  fluidRow(
    column(12,
           fluidRow(
             # year
             column(4, sliderInput(inputId = "year", label = c("Years"), 
                                   min = 1960, max = 2014, 
                                   value = c(1960, 2014), sep = ""),
             p(strong("Please Note:"), "The plot will respond automatically to changes in the range of years.")),
             # species
             column(4, 
                    selectInput(inputId = "species", label = "Species", 
                          choices = unique(tot_rod_catch_long$Species))),
             # river (will change depending on year/species)
             column(4, 
                    selectInput(inputId = "district", label = "Rivers",
                          choices = unique(tot_rod_catch_long$District_Name), 
                                multiple = TRUE, selected = "Annan"),
                    checkboxInput(inputId = "trend", 
                                  label = "Add trend to plot", 
                                  value = FALSE),
                    actionButton(inputId = "GO", label = "Plot Total Catch"))
           ),
           # plotly graph output
           fluidRow(column(12, plotlyOutput("plotly")))
           ))
)

server <- function(input, output, session) {
  
  # observer on species and years to control river inputs
  observe({
    # pick just that Species and those years
    tot_rod_catch_long = tot_rod_catch_long %>%
      filter(Species == input$species, 
             Year >= input$year[1], Year <= input$year[2])
    
    # count the number of entries to ensure 
    # the rivers have all the years
    full_results = tot_rod_catch_long %>%
      count(District_Name) %>%
      filter(n == input$year[2] - input$year[1] + 1)
    
    # update the dropdown
    updateSelectInput(session, inputId = "district",
                      choices = unique(full_results$District_Name),
                      selected = unique(full_results$District_Name[1]))
  })
  
  # reactive function to filter dataset
  filter_catch = reactive({
    # isolate the inputs  
    cur_species = isolate(input$species)
    min_year = isolate(input$year[1])
    max_year = isolate(input$year[2])
    cur_river = isolate(input$district)
    # except the plot button
    input$GO 
    # filter the data by species, year and river
    filtered_catch = tot_rod_catch_long %>%
      filter(Species == cur_species, Year >= min_year, Year <= max_year) %>%
      filter(District_Name %in% cur_river) %>%
      select(-Species) %>% # remove species as unnecessary for plotting
      ungroup()
    return(list(filtered_catch, cur_species))
  })
  
  # reactive function to plot results
  output$plotly = renderPlotly({
    p =  filter_catch()[[1]] %>%
      rename(River = District_Name) %>%
      ggplot(aes(x = Year, y = Catch, colour = River)) +
      geom_line() +
      ggtitle(paste("Total Rod Catch of", filter_catch()[[2]], 
                    "from", input$year[1], "to", input$year[2])) +
      ylab("Total Catch") +
      xlim(c(input$year[1], input$year[2]))
    
    # add trend if requested
    if (input$trend) {
      p = p + geom_smooth(se = FALSE, linetype = "dashed")
    }
    
    # construct plotly version
    ggplotly(p)
  })
# finishing server
}


# Return a Shiny app object
shinyApp(ui = ui, server = server)