
library(shiny)
library(ggplot2)
library(dplyr)
library(openxlsx)

setwd("D:/Colleges/Brown University/BHDS 2010/Assignment4/BHDS-2010-Assignment-4")

data <- read.xlsx("SAheart.xlsx")

ui <-fluidPage( 
  titlePanel("SA Heart Disease Data Explorer"),
  sidebarLayout(
    sidebarPanel( width = 4,
      selectInput("variable", 
                  "Select a variable:",
               choices = c("Type A Behavior" = "typea", 
                           "Obesity" = "obesity", 
                           "Alcohol" = "alcohol",
                           "Age" = "age"),
               selected =  "age",
      ),
      uiOutput("slider")
),
mainPanel(
  paste("About This App:"),
    p("This shiny app uses a dataset collected from South Africa. It is the 
      heart disease dataset, and it is collected to explore risk factors for 
      coronary heart disease. Select the variable from the drop list and adjust 
      the sliders to see how different risk factors affect CHD prevalence."),
  plotOutput("chd_histogram"),
  verbatimTextOutput("summary_stats")
)
))

# Define server logic required to draw a histogram

server <- server <-function(input, output) { 
  output$slider <- renderUI({
    var_data <- data[[input$variable]]
    sliderInput("range", 
                paste("Select", input$variable, "range:"),
                min = floor(min(var_data, na.rm = TRUE)),
                max = ceiling(max(var_data, na.rm = TRUE)),
                value = c(floor(min(var_data, na.rm = TRUE)), 
                          ceiling(max(var_data, na.rm = TRUE))),
                step = 1)
  })
 
}

# Run the application 
shinyApp(ui = ui, server = server)
