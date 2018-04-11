# load packages
library(shiny)
library(igraph)
library(sigmaNet)
library(tidyverse)
library(shinyjs)
library(shinythemes)

# load data and create graphs on start up
dolphins = read_graph("data/dolphins.gml", format = "gml")
football = read_graph("data/football.gml", format = "gml")
lesmis = read_graph("data/lesmis.gml", format = "gml")

dolphins_bet = dolphins
dolphins_rand = dolphins
V(dolphins_bet)$group = cluster_edge_betweenness(dolphins_bet)$membership
V(dolphins_rand)$group = cluster_walktrap(dolphins_rand)$membership

football_bet = football
football_rand = football
V(football_bet)$group = cluster_edge_betweenness(football_bet)$membership
V(football_rand)$group = cluster_walktrap(football_rand)$membership

lesmis_bet = lesmis
lesmis_rand = lesmis
V(lesmis_bet)$group = cluster_edge_betweenness(lesmis_bet)$membership
V(lesmis_rand)$group = cluster_walktrap(lesmis_rand)$membership

dolphins_circle = layout_in_circle(dolphins)
dolphins_nicely = layout_nicely(dolphins)
dolphins_kk = layout_with_kk(dolphins)
dolphins_tree = layout_as_tree(dolphins)

football_circle = layout_in_circle(football)
football_nicely = layout_nicely(football)
football_kk = layout_with_kk(football)
football_tree = layout_as_tree(football)

lesmis_circle = layout_in_circle(lesmis)
lesmis_nicely = layout_nicely(lesmis)
lesmis_kk = layout_with_kk(lesmis)
lesmis_tree = layout_as_tree(lesmis)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("united"),
                tags$head(
                  tags$script(src = 'highlight.pack.js'),
                  tags$script(src = 'shiny-showcase.js'),
                  tags$link(rel = "stylesheet", type = "text/css", 
                            href = "highlight.css")
                ),
                # Application title
                titlePanel("Plotting Networks Using sigmaNet"),
                includeCSS("../../css/sliders.css"),
                useShinyjs(),
                fluidRow(
                  column(6,
                         div(id = "intro", includeMarkdown("markdown/intro.md")),
                         div(id = "load_data",
                             div(id = "load_dolphins", 
                                 includeMarkdown("markdown/load_dolphins.md")),
                             div(id = "load_lesmis", hidden = "true",
                                 includeMarkdown("markdown/load_lesmis.md")),
                             div(id = "load_football", hidden = "true",
                                 includeMarkdown("markdown/load_football.md"))
                         ),
                         div(id = "node_colour", 
                             div(id = "colour_edge", hidden = "true",
                                 includeMarkdown("markdown/colour_edge.md")),
                             div(id = "colour_random", hidden = "true",
                                 includeMarkdown("markdown/colour_random.md"))
                         ),
                         div(id = "layout",
                             div(id = "layout_nicely", hidden = "true",
                                 includeMarkdown("markdown/layout_nicely.md")),
                             div(id = "layout_circle", hidden = "true",
                                 includeMarkdown("markdown/layout_circle.md")),
                             div(id = "layout_tree", hidden = "true",
                                 includeMarkdown("markdown/layout_tree.md")),
                             div(id = "layout_kk", hidden = "true",
                                 includeMarkdown("markdown/layout_kk.md"))
                         ),
                         div(id = "size_col", hidden = "true", 
                             includeMarkdown("markdown/size_col.md")
                         ),
                         div(id = "node_size", 
                             div(id = "size_degree", hidden = "true",
                                 includeMarkdown("markdown/size_degree.md")),
                             div(id = "size_between", hidden = "true",
                                 includeMarkdown("markdown/size_between.md")),
                             div(id = "size_close", hidden = "true",
                                 includeMarkdown("markdown/size_close.md"))
                         ),
                         div(id = "colour_graph", hidden = "true",
                             includeMarkdown("markdown/colour_graph.md")
                         ),
                         div(id = "final", hidden = "true",
                             includeMarkdown("markdown/final.md")
                         )
                  ), # finishing first column
                  column(6,
                         fluidRow(
                           column(6, 
                                  selectInput(inputId = "dataset", label = "Dataset to plot",
                                              choices = c("Dolphins", 
                                                          "American Football",
                                                          "Les Miserables"), 
                                              selected = "Dolphins"),
                                  selectInput(inputId = "layout", label = "Layout for Network",
                                              c("Nicely", "Circle", "Tree", "kk"),
                                              selected = "Nicely")
                           ),
                           column(6, 
                                  selectInput(inputId = "size_metric", label = "Metric for Size of Nodes",
                                              choices = c("None", "Degree" = "degree", 
                                                          "Closeness" = "closeness", 
                                                          "Betweenness" = "betweenness"),
                                              selected = "None"),
                                  selectInput(inputId = "col_metric", label = "Metric for Colour of Nodes",
                                              choices = c("None", "Edge Betweenness", "Random Walk"),
                                              selected = "None")
                           )
                         ),
                         # network output
                         fluidRow(column(12,sigmaNetOutput("network")))
                  ) # finishing second column
                ) # finishing row
)

server <- function(input, output, session) {
  
  output$network <- renderSigmaNet({
    
    # choosing graph and colour grouping
    if (input$dataset == "Dolphins") {
      if (input$col_metric == "Edge Betweenness") {
        graph = dolphins_bet
      } else if (input$col_metric == "Random Walk") {
        graph = dolphins_rand
      } else {
        graph = dolphins
      }
    } else if (input$dataset == "American Football") {
      if (input$col_metric == "Edge Betweenness") {
        graph = football_bet
      } else if (input$col_metric == "Random Walk") {
        graph = football_rand
      } else {
        graph = football
      }
    } else {
      if (input$col_metric == "Edge Betweenness") {
        graph = lesmis_bet
      } else if (input$col_metric == "Random Walk") {
        graph = lesmis_rand
      } else {
        graph = lesmis
      }
    }
    
    # sort layout
    if (input$dataset == "Dolphins") {
      if (input$layout == "Circle") {
        network = sigmaFromIgraph(graph, layout = dolphins_circle)  
      } else if (input$layout == "Tree") {
        network = sigmaFromIgraph(graph, layout = dolphins_tree)
      } else if (input$layout == "kk") {
        network = sigmaFromIgraph(graph, layout = dolphins_kk)  
      } else {
        network = sigmaFromIgraph(graph, layout = dolphins_nicely)  
      }  
    } else if (input$dataset == "American Football") {
      if (input$layout == "Circle") {
        network = sigmaFromIgraph(graph, layout = football_circle)  
      } else if (input$layout == "Tree") {
        network = sigmaFromIgraph(graph, layout = football_tree)
      } else if (input$layout == "kk") {
        network = sigmaFromIgraph(graph, layout = football_kk)  
      } else {
        network = sigmaFromIgraph(graph, layout = football_nicely)  
      }
    } else {
      if (input$layout == "Circle") {
        network = sigmaFromIgraph(graph, layout = lesmis_circle)  
      } else if (input$layout == "Tree") {
        network = sigmaFromIgraph(graph, layout = lesmis_tree)
      } else if (input$layout == "kk") {
        network = sigmaFromIgraph(graph, layout = lesmis_kk)  
      } else {
        network = sigmaFromIgraph(graph, layout = lesmis_nicely)  
      }
    }
    
    
    # add labels 
    network = addNodeLabels(network, labelAttr = 'label')
    
    # control size
    if (input$size_metric != "None") {
      network = addNodeSize(network, minSize = 1, maxSize = 8, 
                            sizeMetric = input$size_metric)
    }
    
    # colour
    if (input$col_metric == "None") {
      network = addNodeColors(network, oneColor = "#E95420")
    } else {
      network = addNodeColors(network, colorAttr = 'group')  
    }
    
  })
  
  observeEvent(input$dataset, {
    if (input$dataset == "dolphins.gml") {
      shinyjs::show("load_dolphins")
      shinyjs::hide("load_football")
      shinyjs::hide("load_lesmis")
    } else if (input$dataset == "football.gml") {
      shinyjs::hide("load_dolphins")
      shinyjs::show("load_football")
      shinyjs::hide("load_lesmis")
    } else {
      shinyjs::hide("load_dolphins")
      shinyjs::hide("load_football")
      shinyjs::show("load_lesmis")
    }
  })
  
  observeEvent(input$col_metric, {
    if (input$col_metric == "Edge Betweenness") {
      shinyjs::show("colour_edge")
      shinyjs::hide("colour_random")
      shinyjs::show("colour_graph")
      shinyjs::show("size_col")
      shinyjs::show("final")
    } else if (input$col_metric == "Random Walk") {
      shinyjs::hide("colour_edge")
      shinyjs::show("colour_random")
      shinyjs::show("colour_graph")
      shinyjs::show("size_col")
      shinyjs::show("final")
    } else {
      shinyjs::hide("colour_edge")
      shinyjs::hide("colour_random")
      shinyjs::hide("colour_graph")
    }
  })
  
  
  observeEvent(input$layout, {
    if (input$layout == "Nicely") {
      shinyjs::show("layout_nicely")
      shinyjs::hide("layout_circle")
      shinyjs::hide("layout_tree")
      shinyjs::hide("layout_kk")
    } else if (input$layout == "Circle") {
      shinyjs::hide("layout_nicely")
      shinyjs::show("layout_circle")
      shinyjs::hide("layout_tree")
      shinyjs::hide("layout_kk")
    } else if (input$layout == "Tree") {
      shinyjs::hide("layout_nicely")
      shinyjs::hide("layout_circle")
      shinyjs::show("layout_tree")
      shinyjs::hide("layout_kk")
    } else {
      shinyjs::hide("layout_nicely")
      shinyjs::hide("layout_circle")
      shinyjs::hide("layout_tree")
      shinyjs::show("layout_kk")
    }
  })
  
  observeEvent(input$size_metric, {
    if (input$size_metric == "degree") {
      shinyjs::show("size_degree")
      shinyjs::hide("size_close")
      shinyjs::hide("size_between")
      shinyjs::show("size_col")
      shinyjs::show("final")
    } else if (input$size_metric == "closeness") {
      shinyjs::hide("size_degree")
      shinyjs::show("size_close")
      shinyjs::hide("size_between")
      shinyjs::show("size_col")
      shinyjs::show("final")
    } else if (input$size_metric == "betweenness") {
      shinyjs::hide("size_degree")
      shinyjs::hide("size_close")
      shinyjs::show("size_between")
      shinyjs::show("size_col")
      shinyjs::show("final")
    } else {
      shinyjs::hide("size_degree")
      shinyjs::hide("size_close")
      shinyjs::hide("size_between")
    }
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

