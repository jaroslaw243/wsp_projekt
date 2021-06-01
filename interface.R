setwd("C:/Users/jarek/PycharmProjects/wsp_projekt")

# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

library(affy)

source("server.R")

abatch <- ReadAffy(filenames = c("data/CL2001031606AA.CEL"))

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
  titlePanel("Google Trend Index"),
  sidebarLayout(
    sidebarPanel(

      # Select type of trend to plot
      selectInput(inputId = "type", label = strong("Trend index"),
                  choices = c("Travel", "Placeholder"),
                  selected = "Travel"),

      # Select date range to be plotted
      dateRangeInput("date", strong("Date range"), start = "2007-01-01", end = "2017-07-31",
                     min = "2007-01-01", max = "2017-07-31"),

      # Select whether to overlay smooth trend line
      checkboxInput(inputId = "smoother", label = strong("Overlay smooth trend line"), value = FALSE),

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
      plotOutput(outputId = "lineplot", height = "300px"),
      textOutput(outputId = "desc"),
      tags$a(href = "https://www.google.com/finance/domestic_trends", "Source: Google Domestic Trends", target = "_blank")
    )
  )
)

# Create Shiny object
shinyApp(ui = ui, server = server)
