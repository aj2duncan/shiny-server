Now we have all the information necessary we can plot the graph. This seems to work best by saving the plot and then outputting it, particularly as `sigmaNet` allows us to update the graph. Creating the graph can take a long time for large graphs. If we wish to use the _kk_ layout then we can specify it. 

```{r}
network = sigmaFromIgraph(graph, layout = layout_with_kk(graph))
network # to plot it
```

The _kk_ layout is the __Kamada-Kawai__ layout and the `igraph` <a href = "http://igraph.org/r/doc/layout_with_kk.html", target = "_blank">manual</a> has the specific details and reference.
