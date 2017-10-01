library(shiny)

shinyUI(pageWithSidebar(
  headerPanel('GIFP Salmon Report'),
  sidebarPanel(
    fileInput('file1', 'Choose out.raw file',
              accept = c('')),
    fileInput('file2', 'Choose outallele.raw file',
              accept = c('')),
    tags$hr(),
   # radioButtons('format', 'Output format', c('PDF', 'Word', 'Just PNG files'),
   #             inline = TRUE),
    downloadButton('download_report', 'Download Report')
  ),
  mainPanel(
    
  )
))