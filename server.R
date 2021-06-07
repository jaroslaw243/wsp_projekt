abatch <- ReadAffy(filenames = c("data/CL2001031606AA.CEL", "data/CL2001031607AA.CEL",
                                 "data/CL2001031608AA.CEL", "data/CL2001031609AA.CEL"))

data.rma.norm <- rma(abatch)
data.mas.norm <- mas5(abatch)
data.gcrma.norm <- gcrma(abatch)

probes <- row.names(exprs(data.rma.norm))

Symbols <- unlist(mget(probes, hgu95av2SYMBOL, ifnotfound=NA))
Entrez_IDs <- unlist(mget(probes, hgu95av2ENTREZID, ifnotfound=NA))

# Define server function
server <- function(input, output) {

  output$norm_hist <- renderPlot({
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

    if (input$log_scale & input$type == 'MAS'){
      abatch_norm <- log(exprs(abatch_norm_pre_log))
    }
    else if (input$log_scale & input$type != 'MAS'){
      abatch_norm <- exprs(abatch_norm_pre_log)
    }
    else if (!input$log_scale & input$type != 'MAS'){
      abatch_norm <- exp(exprs(abatch_norm_pre_log))
    }
    else{
      abatch_norm <- exprs(abatch_norm_pre_log)
    }

    plotDensity(abatch_norm, main='Histogram dla znormalizowanych danych',
     xlab='Ekspresja', ylab='Liczebnosc')
  })

  # Pull in description of trend
  output$desc <- renderText({
    paste("Placeholder", "The index is set to 1.0 on January 1, 2004 and is calculated only for US search traffic.")
  })
}
