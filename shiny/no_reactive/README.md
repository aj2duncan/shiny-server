# Demonstration of Reactivity

This app, along with it's [neighbour](https://shiny.aj2duncan.com/shiny/reactive/) demonstrate how the same app can be written slightly differently to minimise the number of calculations needed. 

In this app the sampling and filtering are inside the `renderPlot()` function. This means that when you change the type of plot, a different sample is used. 

In the [neighbouring app](https://shiny.aj2duncan.com/shiny/reactive/) they are separated and if you change the type of plot the same data is used.

If you change the inputs and (if needed) redraw the plot, the code will highlight as it runs. By comparing the two apps you can see the difference in behaviour. 