Having created the graph using <a href = "http://igraph.org/r/doc/read_graph.html" target = "_blank">igraph's</a> `read_graph()` function we can assign each node a group. This is based on which cluster they belong too. In this case we use the network metric of **edge betweenness** which counts how many shortest paths (from node to node) pass through each edge. Edges with higher betweenness are the joins betweens clusters. The code to produce the groups is below. 

```{r}
# calculate the groups
clust = cluster_edge_betweenness(graph)$membership

# add this property to the graph
V(graph)$group = clust
```

