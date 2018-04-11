If we choose degree then we can control the size using the following code.

```{r}
network %>%
  addNodeSize(minSize = 1, maxSize = 8, sizeMetric = "degree")
```

Degree counts the number of connections (edges) that each node has. In directed networks we can calculate connections into, out of and the total for each node. For undirected we can only count total. In `sigmaNet` it defaults to always counting the total. 

