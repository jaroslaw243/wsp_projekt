abatch <- ReadAffy(filenames = c("data/CL2001031606AA.CEL", "data/CL2001031607AA.CEL",
                                 "data/CL2001031608AA.CEL", "data/CL2001031609AA.CEL"))

data.rma.norm <- rma(abatch)
data.mas.norm <- mas5(abatch)
data.gcrma.norm <- gcrma(abatch)

# Define server function
server <- function(input, output) {
  # Create scatterplot object the plotOutput function is expecting

  output$lineplot <- renderPlot({
    color <- "#434343"
    par(mar = c(4, 4, 1, 1))
    if (input$type == 'RMA'){
      abatch_norm_pre_log <- data.rma.norm
    }
    else if (input$type == 'MAS'){
      abatch_norm_pre_log <- data.mas.norm
    }
    else{
      abatch_norm_pre_log <- data.gcrma.norm
    }

    if (input$log_scale & input$type != 'RMA' & input$type != 'GCRMA'){
      abatch_norm <- log(exprs(abatch_norm_pre_log))
    }
    else{
      abatch_norm <- exprs(abatch_norm_pre_log)
    }

    plotDensity(abatch_norm, main='Histogram dla znormalizowanych danych',
     xlab='Ekspresja', ylab='Liczebnosc')
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
