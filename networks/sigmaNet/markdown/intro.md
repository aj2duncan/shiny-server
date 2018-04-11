This shiny app shows an example of how to use the <a href = "https://iankloo.github.io/sigmaNet/", target = _"blank">sigmaNet</a> R package to plot networks. The code used and explanation of the metrics used can be found below whilst the network plotted is an interative plot. You can click on individual nodes to identify their neighbours. Scrolling will zoom in and mouseover will show the labels on the nodes.

We get started by loading the necessary packages and the data for the network. 

```{r}
library(igraph)
library(sigmaNet)
library(magrittr) # for the %>% 'pipe' operator
```

A network is comprised of nodes or vertices (the points which could represent the individuals in the network) and edges which are the connections between the nodes (for example the connections are meetings between the individuals either physical or virtual). We can use `metrics` to establish which nodes are influential in the network, identify important connections and estimate communities. 
