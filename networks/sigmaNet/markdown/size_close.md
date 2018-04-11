If we choose closeness then we can control the size using the following code.

```{r}
network %>%
  addNodeSize(minSize = 1, maxSize = 8, sizeMetric = "closeness")
```
Closeness is a measure of centrality in the network and in igraph is defined as 1 over the average length of all the shortest paths involving the node, the function definition is provided <a href = "http://igraph.org/r/doc/closeness.html", target = "_blank">here</a>.
