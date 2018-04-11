Now we have all the information necessary we can plot the graph. This seems to work best by saving the plot and then outputting it, particularly as `sigmaNet` allows us to update the graph. Creating the graph can take a long time for large graphs. 

```{r}
network = sigmaFromIgraph(graph)
network # to plot it
```

The default format is the _nicely_ layout but this can also be specified directly.  

```{r}
network = sigmaFromIgraph(graph, layout = layout_nicely(graph))
network # to plot it
```

The _nicely_ layout uses a different method depending on whether there are more or less than 1000 vertices. All of the networks here have less than 1000 vertices and so we use the __Fruchterman-Reingold__ layout algorithm. The `igraph` <a href = "http://igraph.org/r/doc/layout_with_fr.html", target = "_blank">manual</a> has the specific details and reference.
