# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

source("server.R")

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
  titlePanel("Przetwarzanie danych mikromacierzowych"),
  sidebarLayout(
    sidebarPanel(

      # Select type of trend to plot
      selectInput(inputId = "type", label = strong("Metoda normalizacji"),
                  choices = c("RMA", "MAS", "GCRMA"),
                  selected = "RMA"),

      # Select date range to be plotted
      dateRangeInput("date", strong("Date range"), start = "2007-01-01", end = "2017-07-31",
                     min = "2007-01-01", max = "2017-07-31"),

      # Select whether to overlay smooth trend line
      checkboxInput(inputId = "log_scale", label = strong("Skala logarytmiczna"), value = TRUE),

      # Display only if the smoother is checked
      conditionalPanel(condition = "input.smoother == true",
                       sliderInput(inputId = "f", label = "Smoother span:",
                                   min = 0.01, max = 1, value = 0.67, step = 0.01,
                                   animate = animationOptions(interval = 100)),
                       HTML("Higher values give more smoothness.")
      )
    ),

    # Output: Description, lineplot, and reference
    mainPanel(
      plotOutput(outputId = "norm_hist", height = "300px"),
      fileInput("read_files", "Wybierz plik", multiple = TRUE,
                 accept = c(".RData", ".csv", ".xlsx"))
    )
  )
)

# Create Shiny object
shinyApp(ui = ui, server = server)
