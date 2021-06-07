library(shiny)

.GlobalEnv$dane <- 0
.GlobalEnv$dane_znormalizowane <- 0


Normalizacja_dd <- function(dane_znormalizowane, dane){
  if(dane_znormalizowane == "mas5"){
    dane.norm = simpleaffy::call.exprs(dane, "mas5")
  } 
  else if(dane_znormalizowane == "gcmra"){
    dane.norm = simpleaffy::call.exprs(dane, "gcmra")
  } 
  
  
  else{
    dane.norm = simpleaffy::call.exprs(dane, "rma")
  }
  return(dane.norm)
}


  shinyServer(function(input, output, session) {
    
   
    
    observeEvent(input$read.affymetrix.files, {
      
      progress <- shiny::Progress$new()
      on.exit(progress$close())
      progress$set(message = "Wczytuje dane", value = 0)
      n <- 4
      progress$inc(1/n, detail = "reading data")
      name <- input$read.affymetrix.files$name
      datapath <- input$read.affymetrix.files$datapath
      dane <<- affy::read.affybatch(datapath)
      sampleNames(dane) <<- name
      sampleNames(dane) <<- sub("\\.CEL$", "", sampleNames(dane))
      num.probes <<- length(sampleNames(dane))
      
      progress$inc(1/n, detail = "aktualizacja")
      updateSelectInput(session = session, inputId = "input.control.labels",
                        choices = c(sampleNames(dane)))
      
      norm.alg <<- switch(input$normalization.algorithm,
                          mas5 = "mas5",
                          rma = "rma",
                          gcmra ="gcmra")
      progress$inc(1/n, detail = "normalizing data")
      dane.norm <<- Normalizacja_dd(dane_znormalizowane, data)
  
      
    })
    

    
  })