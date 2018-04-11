If we have decided to use either _edge betweenness_ or a _random walk_ to define groups within our networks then we can add this attribute to the graph too. 

```{r}
network %>%
  addNodeColors(colorAttr = 'group')
```

