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
library(officer)
library(hgu95av2)
library(hgu95av2cdf)
library(doBy)

source("hc.R")
source("pca_genes.R")
source("raport.R")

filtMinAndControl <- function (un_filt_data){
  un_filt_data_means <- rowMeans(un_filt_data)
  un_filt_data_means_mink <- which.minn(un_filt_data_means, round(length(un_filt_data_means)*0.05))
  filt_data <- un_filt_data[-un_filt_data_means_mink,]

  filt_data <- filt_data[!grepl("AFFX", rownames(filt_data)),]

  return(filt_data)
}

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

    data_filtered <<- filtMinAndControl(data_norm)

    pca_data <<- pca_genes(data_filtered)
    clast_data <<- hc(data_filtered, input$n_gen, input$dist_mes, input$conn_met, input$n_groups)

    output$norm_hist <- renderPlot({
      plotDensity(data_norm, main = 'Histogram dla wczytanych danych',
                  xlab = 'Ekspresja', ylab = 'Liczebnosc')
    })

    output$pca_screeplot <- renderPlot({pca_data[[2]]})
    output$pca_ggplot <- renderPlot({pca_data[[1]]})
    output$clast_plot <- renderPlotly({clast_data[[1]]})
    output$dend <- renderPlotly({clast_data[[2]]})
  })

  observeEvent(input$make_report, {
    slide(pca_data[[3]], pca_data[[2]], pca_data[[1]], clast_data[[3]], clast_data[[4]])
  })

}
