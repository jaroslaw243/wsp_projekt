# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

source("server.R")

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),tags$head(tags$style(HTML('* {font-family: "Arial"};'))),
  titlePanel("Klasteryzacja danych mikromacierzowych"),
  sidebarLayout(
    sidebarPanel(

      selectInput(inputId = "dist_mes", label = strong("Miara odległości"),
                  choices = c("Euklidesowa" = "euclidean", "Maksimum" = "maximum", "Manhattan" = "manhattan",
                              "Canberra" = "canberra", "Binarna" = "binary", "Minkowskiego" = "minkowski"),
                  selected = "euclidean", width = '50%'),

      selectInput(inputId = "conn_met", label = strong("Metoda połączenia"),
                  choices = c("Pojedyncze" = "single", "Kompletne" = "complete", "Srednie" = "average",
                              "Centroidalne" = "centroid", "McQuitty'ego" = "mcquitty", "Medianowe" = "median",
                              "Ward'a (1)" = "ward.D", "Ward'a (2)" = "ward.D2"),
                  selected = "complete", width = '50%'),

      numericInput(inputId = "n_groups", label = strong("Liczba grup"), value = 1, min = 1, step = 1,
                   width = '25%'),
      numericInput(inputId = "n_gen", label = strong("Liczba genów"), value = 10, min = 1, step = 1, width = '25%'),

      fileInput("read_files", "Wybierz plik", multiple = FALSE, accept = c(".RData", ".csv", ".xlsx"),
                width = '50%')
    ),

    mainPanel(
      plotOutput(outputId = "norm_hist", height = "300px", width = "600px"),
      plotlyOutput(outputId = "clast_plot", height = "1000px", width = "1000px"),
      plotlyOutput(outputId = "dend", height = "1000px", width = "1000px"),
    )
  )
)

# Create Shiny object
shinyApp(ui = ui, server = server)
