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
                  wellPanel(
                    h3("About This App:"),
                    p("This shiny app uses a dataset collected from South Africa. It is Heart
    The disease dataset is collected to explore risk factors for coronary 
    heart disease. Select the variable from the drop list, and adjust the 
    sliders to see how different risk factor ranges affect CHD prevalence.")
                  ),
                  selectInput("variable", 
                              "Select a variable:",
                              choices = c("Systolic Blood Pressure"= "sbp",
                                          "Cumulative Tobacco (kg)"="tobacco",
                                          "Low Density Lipoprotein Cholesterol"="ldl",
                                          "Adiposity"="adiposity",
                                          "Family History of Heart Disease"="famhist",
                                          "Obesity" = "obesity", 
                                          "Alcohol" = "alcohol",
                                          "Age" = "age"),
                              selected =  "age", # select the initial variable for the drop list
                  ),
      br(),
      uiOutput("slider")
),
mainPanel(
  # App definition:
  h3(strong("About the data:")),
    p("This dataset originates from  retrospective study of adult males living in a 
      heart-diseases high-risk region of the Western Cape, South Africa. The sample 
      includes individuals with diagnosed coronary heart disease (CHD) and a larger 
      group of demographic factors. These data form part of a broader study described 
      in Roussaeuw et al. (1983) in the South African Medical Journal. Several 
      physiological measurements were recorded after treatment. This is an important
      consideration when interpreting predictors such as systolic blood pressure in 
      relation to CHD status"),
  
  tabsetPanel(
    tabPanel(p("Histogram:"),
             h3(strong("The histogram according to the selected variable:")
                ),
             br(),
             plotOutput("chd_histogram"),
             br(),
             verbatimTextOutput("summary_stats")),
             
             
    tabPanel(p("Box Plot"),
    h3(strong("Visualization 2: Box plot for (chd) variable and the 
                       selected variable:")),
             plotOutput("chd_boxplot"),
             h3(strong("Plot description in full range:")),
             uiOutput("analysisPlotDescription"))
    ),
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
  
  plotDescriptions <- c(
    sbp = "The plot shows the distribution of systolic blood pressure for males
    with and without CHD. On average, males with CHD have higher systolic blood 
    pressure than those without. This difference in means is approximately 8 mmHg. 
    Blood pressure also appears to have greater variation in the CHD group, while 
    outliers are present in both groups, with a higher number in males without CHD. 
    These observations suggest that systolic blood pressure is associated with CHD, 
    but individual variability exists, and high or low blood pressure can occur 
    even in males without CHD. Statistical testing will need to be conducted to 
    examine this association.",
    tobacco = "This plot shows cumulative tobacco use among individuals with and 
    without CHD. On average, males with CHD have higher cumulative tobacco use 
    than those without. This difference in means is approximately 3 kg Cumulative 
    tobacco use also appears to have greater variation in the CHD group, while 
    outliers are present in both groups. These observation suggest that cumulative 
    tobacco use is associated with CHD, but individual variability exists. 
    Statistical testing will need to be conducted to examine this association.",
    ldl = "This plot compares low-density lipoprotein cholesterol levels by CHD 
    status. Here, we see that individuals with CHD have a greater low-density 
    lipoprotein cholesterol levels compared to its counterpart. The difference 
    in  means is relatively small of approximately 1 mg/dL. The variability of 
    the two groups appears to be roughly the same, however, the CHD group has 
    slightly greater variation. With these observation, a statistical test should 
    be performed to determine if there is an association between low density 
    lipoprotein cholesterol levels and CHD.",
    adiposity = "This plot shows body fat distribution in relation to CHD. For 
    the CHD group, we have a slightly greater median compared to the no CHD group. 
    The mean measure of body fat for the CHD group is approximately 28.12, and for 
    the No CHD group it is approximately 23.97. This has an approximate mean 
    difference of 5 units. The variable between the two groups appears to be very 
    similar. Therefore, a statistical test should be performed to determine if 
    there is an association between body fat and CHD.",
    famhist = "This bar plot shows the proportion of CHD cases among those with 
    or without a family history of heart disease. We see an increase in about 25% 
    of cases in CHD when there is a family history of heart disease. On the other 
    hand, we see a decrease in about 25% of No CHD cases when there is a family 
    history of heart disease. From this plot, it appears there is an association 
    between family history of heart disease and CHD status, meaning individuals 
    who have a family history of heart disease have an increased chance of having 
    CHD. Statistical tests should be performed to determine if there is an association 
    between family history of heart disease and CHD.",
    obesity = "This plot compares obesity levels between CHD and No CHD groups. 
    The distribution appears to be fairly similar with the median obesity index 
    values super close to each other. The mean obesity index for the CHD group is 
    approximately 26.62, while for the No CHD group it is approximately 25.74. 
    There does not appear to be an association between obesity index and CHD status, 
    however, statistical testing should be performed in order to draw conclusions.",
    alcohol = "This plot displays alcohol consumption patterns by CHD status. The 
    distribution appears to be fairly similar with the median alcohol consumption 
    amount super close to each other. The mean alcohol consumption for the CHD 
    group is approximately 19.15, while for the No CHD group it is approximately 
    15.93. The variation between the groups appear to be equal. Due to these 
    examinations, statistical testing should be performed in order to draw 
    conclusions on whether or not there is an association between alcohol 
    consumption and CHD status. ",
    age = "This plot compares the age distribution of individuals with and without 
    CHD. We see that the median age for CHD does not overlap with the IQR range of 
    No CHD. Furthermore, the mean age of individuals with CHD is approximately 50, 
    while for no CHD the mean age is approximately 39. There appears to be more 
    variation in the No CHD group. These observation suggest that age is associated 
    with CHD, but individual variability exist. Statistical testing will need to 
    be conducted to examine this association."
    )
  
  output$analysisPlotDescription <- renderUI({
    var <- input$variable
    desc <- plotDescriptions[[var]]  # pulls description for selected variable
    
    p(desc) # paragraph from desc variable above
  })
  
  # Summary statistics for CHD
  output$summary_stats <- renderPrint({
    req(filtered_data())
    filtered <- filtered_data()
    cat("SUMMARY STATISTICS FOR CHD\n")
    cat("==========================\n")
    cat("Total observations:", nrow(filtered), "\n")
    cat("CHD cases:", sum(filtered$chd), "\n")
    cat("Non-CHD cases:", sum(!filtered$chd), "\n")
    cat("CHD prevalence:", round(mean(filtered$chd) * 100, 1), "%\n")
    cat("Detailed breakdown:(0 = No CHD , 1 = CHD)")
    print(table(filtered$chd))
    cat("Proportions:(0 = No CHD , 1 = CHD)")
    print(round(prop.table(table(filtered$chd))* 100, 1))
  })
 
}

# Run the application 
shinyApp(ui = ui, server = server)
