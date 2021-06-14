library(xlsx)
library(affy)
library(tools)
library(dendextend)
library(factoextra)
library(ggdendro)
library(colorspace)
library(heatmaply)
library(stringr)
library(gplots)

source("hc.R")

# Define server function
server <- function(input, output) {
  observeEvent(input$read_files, {
    if (file_ext(input$read_files$datapath) == 'RData') {
      load(input$read_files$datapath)
    }
    else if (file_ext(input$read_files$datapath) == 'csv'){
      data_norm <- read.csv(input$read_files$datapath, stringsAsFactors = FALSE)
      rownames(data_norm) <- data_norm[, 1]
      data_norm <- data_norm[,-1]
    }
    else{
      data_norm <- read.xlsx(input$read_files$datapath, 1, stringsAsFactors = FALSE)
      rownames(data_norm) <- data_norm[, 1]
      data_norm <- data_norm[,-1]
    }

    clast_data <- hc(data_norm, input$n_gen, input$dist_mes, input$conn_met, input$n_groups)

    output$norm_hist <- renderPlot({
      par(mar = c(4, 4, 1, 1))
      plotDensity(data_norm, main = 'Histogram dla wczytanych danych',
                  xlab = 'Ekspresja', ylab = 'Liczebnosc')
    })

    output$clast_plot <- renderPlotly({clast_data[[1]]})
    output$dend <- renderPlotly({clast_data[[2]]})
  })

}
