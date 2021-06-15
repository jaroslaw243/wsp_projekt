# Przerobiony kod, dodane funkcjonalnoci generowania wykresu.


library(affy)
library(tools)
.GlobalEnv$dane <- 0
.GlobalEnv$dane_znormalizowane <- 0

# Funkcja serwerowa
server <- function(input, output) {
  observeEvent(input$read_files, {
    if (file_ext(input$read_files$datapath) == 'RData') {
      load(input$read_files$datapath)
    }
    else if (file_ext(input$read_files$datapath) == 'csv'){
     dznormalizowane <- read.csv(input$read_files$datapath, stringsAsFactors = FALSE)
      rownames( dznormalizowane ) <-  dznormalizowane [, 1]
      dznormalizowane  <-  dznormalizowane [,-1]
    }
    else{
      dznormalizowane  <- read.xlsx(input$read_files$datapath, 1, stringsAsFactors = FALSE)
      rownames( dznormalizowane ) <-  dznormalizowane [, 1]
      dznormalizowane  <-  dznormalizowane [,-1]
    }
    
    output$histogramZdanych <- renderPlot({
      par(mar = c(4, 4, 1, 1))
      plotDensity( dznormalizowane , main = 'Histogram z danych',
                  xlab = 'Ekspresja', ylab = 'Liczebnosc')
    })
  })
  
}
