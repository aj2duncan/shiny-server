Now we have all the information necessary we can plot the graph. This seems to work best by saving the plot and then outputting it, particularly as `sigmaNet` allows us to update the graph. Creating the graph can take a long time for large graphs. If we wish to use the circle layout then we can specify it. 

```{r}
network = sigmaFromIgraph(graph, layout = layout_circle(graph))
network # to plot it
```

