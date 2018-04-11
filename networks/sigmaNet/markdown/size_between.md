If we choose betweenness then we can control the size using the following code.

```{r}
network %>%
  addNodeSize(minSize = 1, maxSize = 8, sizeMetric = "betweenness")
```

Betweenness is a measure of how central the node is to the network by counting the number of shortest paths from one node to another that pass through the node. The higher the number of shortest paths, the higher the betweenness and the more central the node is.

