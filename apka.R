# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

# Load data
trend_data <- read.csv("data/trend_data.csv")
trend_description <- read.csv("data/trend_description.csv")

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
  titlePanel("Google Trend Index"),
  sidebarLayout(
    sidebarPanel(

      # Select type of trend to plot
      selectInput(inputId = "type", label = strong("Trend index"),
                  choices = c("Travel", "Jajco"),
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

# Define server function
server <- function(input, output) {




  # Create scatterplot object the plotOutput function is expecting
  output$lineplot <- renderPlot({
    color <- "#434343"
    par(mar = c(4, 4, 1, 1))
    plot(x = trend_data$date, y = trend_data$close, type = "l",
         xlab = "Date", ylab = "Trend index", col = color, fg = color, col.lab = color, col.axis = color)
    # Display only if smoother is checked
    if(input$smoother){
      smooth_curve <- lowess(x = as.numeric(trend_data$date), y = trend_data$close, f = input$f)
      lines(smooth_curve, col = "#E6553A", lwd = 3)
    }
  })

  # Pull in description of trend
  output$desc <- renderText({
    paste("Placeholder", "The index is set to 1.0 on January 1, 2004 and is calculated only for US search traffic.")
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)
