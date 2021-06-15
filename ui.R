
setwd("C:/Users/Patryk/Desktop/Projekt/nowe")
library(shiny)
library(dplyr)
library(readr)
library(shinythemes)


source("server.R")


ui <- fluidPage(theme = shinytheme("superhero"),
                titlePanel("Apka grupa wtorkowa"),
                sidebarLayout(
                  tabsetPanel(
                    
                    # Select type of trend to plot
                   selectInput(inputId = "type", label = strong("Wybierz rodzaj normalizacji"),
                              choices = c("MAS", "RMA", "GCRMA"))),
                   
                    
                    
                    
                  mainPanel(
                     plotOutput(outputId = "histogramZdanych", height = "250px"),
                     fileInput("read_files", "Wybierz plik", multiple = TRUE,
                               accept = c(".RData", ".csv", ".xlsx")
                   ),
                  
                  
             
                )))



shinyApp(ui = ui, server = server)