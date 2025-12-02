## Load Packages 
library(shiny)
library(ggplot2)
library(dplyr)
library(openxlsx)

## Set the work directory. This part needs to be adjusted to match data file.
setwd("D:/Colleges/Brown University/BHDS 2010/Assignment4/BHDS-2010-Assignment-4")

## Load the data and store it in "data" variable:
data <- read.xlsx("SAheart.xlsx")

## Change the values of the variable "famhist" from (Present, Absent) to (1,0), 
## for data processing purpose.
data$famhist <- ifelse(data$famhist == "Present", 1, 0)

## Create the UI:
ui <-fluidPage(
  # the app title 
  titlePanel("SA Heart Disease Data Explorer"),
  # Side bar contents
  sidebarLayout(
    sidebarPanel( width = 4,
                  # Drop list of all variables, one variable is selected to be
                  # used in the slide bar for data filtering. 
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
               selected =  "age", # select the initial variable for the drop list
      ),
      uiOutput("slider")
),
mainPanel(
  # App definition:
  paste("About This App:"),
    p("This shiny app uses a dataset collected from South Africa. It is the 
      heart disease dataset, and it is collected to explore risk factors for 
      coronary heart disease. Select the variable from the drop list and adjust 
      the sliders to see how different risk factors affect CHD prevalence."),
  plotOutput("chd_histogram"),
  
  plotOutput("chd_boxplot"),
  
  verbatimTextOutput("summary_stats"),

)
))

## Define server logic required to draw a histogram and box plot:

server <- server <-function(input, output) { 
  output$slider <- renderUI({
    # here is the selected variable from the drop list
    var_data <- data[[input$variable]] 
    # Slide bar to select the range of the values in the selected variable 
    sliderInput("range", 
                paste("Select", input$variable, "range:"),
                min = floor(min(var_data)),
                max = ceiling(max(var_data)), # some variables have fraction value 
                value = c(floor(min(var_data)), 
                          ceiling(max(var_data))),
                step = 1)
  })
  
  # Filtered data based on slider selection
  filtered_data <- reactive({
    req(input$range)
    data %>% filter(.data[[input$variable]] >= input$range[1] & 
                      .data[[input$variable]] <= input$range[2])
  })
  # Visualization 1: create the histogram:
  
  # Storing the chd histogram as an output variable
  output$chd_histogram <- renderPlot({
    # selecting the required data, which is the filtered data.
    req(filtered_data())  
    
    ggplot(filtered_data(), aes(x = factor(chd))) +
      geom_bar(fill = "lightblue") +
      labs(title = paste("CHD Distribution for", input$variable, 
                         "in range [", input$range[1], ",", input$range[2], "]"),
           x = "Coronary Heart Disease (0 = No, 1 = Yes)",
           y = "Count") +
      theme_minimal() +
      scale_x_discrete(labels = c("No CHD", "CHD"))
  })
  
  
  # Visualization 2: box plot for "chd" variable with the selected variable:
  
  # Storing the chd box plot as an output variable
  output$chd_boxplot <- renderPlot({
    # selecting the required data, which is the filtered data.
    req(filtered_data())
    
    ggplot(filtered_data(), aes(x = factor(chd), y = !!sym(input$variable),
                                fill = factor(chd))) + geom_boxplot() + 
      labs(
        title = paste("CHD Distribution for", input$variable, "in range [", input$range[1], ",", input$range[2], "]"),
        x = "Coronary Heart Disease (0 = No, 1 = Yes)",
        y = paste(input$variable, "in range [", input$range[1],
                  ",", input$range[2], "]")
      ) + 
      theme_minimal()
  })
 
}

# Run the application 
shinyApp(ui = ui, server = server)
