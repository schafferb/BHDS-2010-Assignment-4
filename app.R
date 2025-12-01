
library(shiny)
library(ggplot2)
library(dplyr)
library(openxlsx)

setwd("D:/Colleges/Brown University/BHDS 2010/Assignment4/BHDS-2010-Assignment-4")

data <- read.xlsx("SAheart.xlsx")

data$famhist <- ifelse(data$famhist == "Present", 1, 0)

ui <-fluidPage( 
  titlePanel("SA Heart Disease Data Explorer"),
  sidebarLayout(
    sidebarPanel( width = 4,
      selectInput("variable", 
                  "Select a variable:",
               choices = c("Systolic Blood Pressure"= "sbp",
                           "Cumulative Tobacco (kg)"="tobacco",
                           "Low Density Lipoprotein Cholesterol"="ldl",
                           "Adiposity"="adiposity",
                           "Family History of Heart Disease"="famhist",
                           "Type A Behavior" = "typea",
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
                min = floor(min(var_data)),
                max = ceiling(max(var_data)),
                value = c(floor(min(var_data)), 
                          ceiling(max(var_data))),
                step = 1)
  })
  
  # Filtered data based on slider selection
  filtered_data <- reactive({
    req(input$range)
    data %>%
      filter(.data[[input$variable]] >= input$range[1] &
               .data[[input$variable]] <= input$range[2])
  })
  
  output$chd_histogram <- renderPlot({
    req(filtered_data())
    
    ggplot(filtered_data(), aes(x = factor(chd))) +
      geom_bar(fill = "lightblue", alpha = 0.7) +
      labs(title = paste("CHD Distribution for", input$variable, 
                         "in range [", input$range[1], ",", input$range[2], "]"),
           x = "Coronary Heart Disease (0 = No, 1 = Yes)",
           y = "Count") +
      theme_minimal() +
      scale_x_discrete(labels = c("No CHD", "CHD"))
  })
 
}

# Run the application 
shinyApp(ui = ui, server = server)
