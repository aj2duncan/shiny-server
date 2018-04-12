# load packages
library(shiny)
library(igraph)
library(sigmaNet)
library(magrittr)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(),
    mainPanel(sigmaNetOutput("network"))
  )  
)

server <- function(input, output, session) {
  
  output$network <- renderSigmaNet({
    data(lesMis)
    
    clust <- cluster_edge_betweenness(lesMis)$membership
    V(lesMis)$group <- clust
    
    layout <- layout_with_fr(lesMis)
    
    sig <- sigmaFromIgraph(lesMis, layout = layout) %>%
      addNodeLabels(labelAttr = 'label') %>%
      addEdgeSize(sizeAttr = 'value', minSize = .1, maxSize = 2) %>%
      addNodeSize(sizeMetric = 'degree', minSize = 2, maxSize = 8) %>%
      addNodeColors(colorAttr = 'group', colorPal = 'Set1')
    sig
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

