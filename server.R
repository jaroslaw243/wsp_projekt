library(xlsx)
library(affy)
library(tools)

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

    output$norm_hist <- renderPlot({
      par(mar = c(4, 4, 1, 1))
      plotDensity(data_norm, main = 'Histogram dla znormalizowanych danych',
                  xlab = 'Ekspresja', ylab = 'Liczebnosc')
    })
  })

}
