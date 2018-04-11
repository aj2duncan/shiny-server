Having created the graph using <a href = "http://igraph.org/r/doc/read_graph.html" target = "_blank">igraph's</a> `read_graph()` function we can assign each node a group. This is based on which cluster they belong too. In this case we use a short random walk from each node. Other nodes have a particular probability of being on such a walk (randomly choosing an edge out of a node), the higher the probability - the more likely it is that the node is in the same community. The code to produce the groups is below. 

```{r}
# calculate the groups
clust = cluster_walktrap(graph)$membership

# add this property to the graph
V(graph)$group = clust
```

