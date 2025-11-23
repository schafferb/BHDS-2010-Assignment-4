
library(shiny)
library(ggplot2)

setwd("D:/Colleges/Brown University/BHDS 2010/Assignment4/BHDS-2010-Assignment-4")

ui <-fluidPage( 
  # inputs 
  ## text input <inputId1> 
  textInput(...), 
  ## select input <inputId2> 
  selectInput(), 
  ## text input <inputId3> 
  # … 
  #outputs 
  ## data table 
  DT::dataTableOutput("dataTable"), 
  ## figure 
  plotOutput("scatterPlot"), 
) 
# Define server logic required to draw a histogram
server <- server <-function(input, output) { 
  ## data management 
  Data <-reactive({... 
  }) 
  ## output 1. Generate data table based on filtered data 
  output$dataTable <-DT::renderDataTable({... 
  }) 
  ## output 2. Generate a plot 
  output$scatterPlot <-renderPlot({... 
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
