# load packages
library(shiny)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)

# read in data
tot_rod_catch_long = read_csv("data/rod_catch_clean.csv")

ui <- fluidPage(
  # textbox info in col-md-4
  sliderInput(inputId = "year", label = c("Years"), 
              min = as.Date("1960-01-01"), max = as.Date("2014-01-01"),
              value = c(as.Date("1960-01-01"), as.Date("2014-01-01")), 
              step = 1, 
              sep = "", timeFormat = "%Y"),
  # select for species
  selectInput(inputId = "species", label = "Species", 
              choices = c("Wild Salmon", "Wild Grilse", "Sea Trout",
                          "Finnock", "Farmed Salmon", "Farmed Grilse")),
  # select for rivers
  selectInput(inputId = "district", label = "River",
              choices = unique(tot_rod_catch$District_Name), 
              multiple = TRUE, selected = "Dee (Aberdeenshire)")
)

server <- function(input, output) {
  
}


# Return a Shiny app object
shinyApp(ui = ui, server = server)