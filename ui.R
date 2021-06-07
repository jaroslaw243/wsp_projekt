
            ui <- pageWithSidebar(
              
              
              headerPanel("Apka grupa wtorkowa"),
              
             
              sidebarPanel(radioButtons("normalizing data", "Wybierz rodzaj normalizacji",
                                        c("MAS-5" = "mas5",
                                          "RMA" = "rma",
                                          "GCRMA"="gcmra"))),
              
              # Main panel for displaying outputs ----
              mainPanel( fileInput("read.affymetrix.files", "Wybierz plik",
                                   multiple = TRUE,
                                   accept = c(".CEL", ".cel")))
            )
            #shinyApp(ui, shinyServer)