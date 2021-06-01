# Define server function
server <- function(input, output) {
  # Create scatterplot object the plotOutput function is expecting
  output$lineplot <- renderPlot({
    color <- "#434343"
    par(mar = c(4, 4, 1, 1))
    hist(abatch, main='Histogram w skali logarytmicznej dla nieznormalizowanych danych',
     xlab='log(Ekspresja)', ylab='Liczebność')
    # Display only if smoother is checked
    # if(input$smoother){
    #   smooth_curve <- lowess(x = as.numeric(trend_data$date), y = trend_data$close, f = input$f)
    #   lines(smooth_curve, col = "#E6553A", lwd = 3)
    # }
  })

  # Pull in description of trend
  output$desc <- renderText({
    paste("Placeholder", "The index is set to 1.0 on January 1, 2004 and is calculated only for US search traffic.")
  })
}
