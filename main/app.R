# Shiny App: Risk Factors Associated with CHD Diagnosis

# Load packages
library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(bslib)
library(DT)

# Load the data
CHD <- read.table(
  "https://hastie.su.domains/ElemStatLearn/datasets/SAheart.data",
  sep = ",", head = TRUE, row.names = 1
)

CHD <- CHD %>% 
  mutate(chd = factor(chd, levels = c(0, 1), labels = c("No CHD", "CHD")))
CHD$famhist <- as.factor(CHD$famhist)

# UI

ui <- fluidPage(
  br(),
  fluidRow(titlePanel(strong("Risk Factors Associated with CHD Diagnosis in High-Risk South African Men")),
           align = "center"),
  fluidRow(h4("Published by: Bryanna Schaffer and Ibrahim Elbasheer"), align = "center"),
  
  tabsetPanel(
    
# 1. DATA OVERVIEW TAB - Bryanna/Ibrahim
    
    tabPanel(strong("Data Overview"),
             br(),
             mainPanel(
               width = 12,
               h3(strong("Research Question"), align = "center"),
               h4(textOutput("question")),
               br(),
               h3(strong("Data Overview"), align = "center"),
               textOutput("overview"),
               br(),
               h4(strong("Variables of Interest"), align = "center"),
               uiOutput("variables")
             )
    ),
    
# 2. DATA EXPLORATION TAB - Bryanna

    tabPanel(strong("Data Exploration"),
             br(),
             mainPanel(
               width = 12,
               h3(strong("Coronary Heart Disease Data Exploration"), align = "center"),
               textOutput("howtodata"),
               br(),
               
               fluidRow(
                 column(6,
                        selectInput("independent", strong("Select a Variable of Interest"),
                                    choices = c(
                                      "Systolic Blood Pressure" = "sbp",
                                      "Tobacco" = "tobacco",
                                      "Low Density Lipoprotein Cholesterol" = "ldl",
                                      "Measure of Body Fat" = "adiposity",
                                      "Family History of Heart Disease" = "famhist",
                                      "Obesity Index" = "obesity",
                                      "Alcohol Consumption" = "alcohol",
                                      "Age" = "age"
                                    ),
                                    selected = "sbp"),
                        
                        br(),
                        strong(tableOutput("summaryTable"), align = "center")
                 ),
                 
                 column(6,
                        strong("Discussion"),
                        uiOutput("summaryData")
                 )
               ),
               
               br(),
               
               div(style = "border: 3px solid #000; border-radius: 2px;",
                   h4(strong("Full Dataset"), align = "center"),
                   strong(DTOutput("fullDataTable"))
               )
             )
    ),
    

# 3. HISTOGRAM WITH SLIDER TAB - Ibrahim

    tabPanel(strong("Data Exploration - Histograms"),
             
             sidebarLayout(
               sidebarPanel(
                 width = 4,
                 
                 # variable selector
                 selectInput("histVar", "Select a variable:",
                             choices = c(
                               "Systolic Blood Pressure" = "sbp",
                               "Tobacco" = "tobacco",
                               "Low Density Lipoprotein Cholesterol" = "ldl",
                               "Adiposity" = "adiposity",
                               "Obesity Index" = "obesity",
                               "Family History" = "famhist",
                               "Alcohol Consumption" = "alcohol",
                               "Age" = "age"
                             ),
                             selected = "age"),
                 
                 # slider created dynamically
                 uiOutput("histSlider")
               ),
               
               mainPanel(
                 h3(strong("Histogram of CHD for Selected Range")),
                 h4("Select the variable from the drop list, and adjust the 
    sliders to see how different risk factor ranges affect CHD prevalence."),
                 plotOutput("histPlot"),
                 br(), 
                 verbatimTextOutput("summaryIbrahim")
               )
             )
    ),
 
# 4. DATA ANALYSIS TAB WITH SUMMARY - Bryanna

  tabPanel(strong("Data Analysis - Boxplot/Bar Plots"),
           br(),
           h3(strong("Variable of Interest vs CHD"), align = "center"),
           
           selectInput("analysisVar", "Select a Variable of Interest:",
                       choices = c(
                         "Systolic Blood Pressure" = "sbp",
                         "Tobacco" = "tobacco",
                         "Low Density Lipoprotein Cholesterol" = "ldl",
                         "Measure of Body Fat" = "adiposity",
                         "Family History of Heart Disease" = "famhist",
                         "Obesity Index" = "obesity",
                         "Alcohol Consumption" = "alcohol",
                         "Age" = "age"
                       )),
           
           br(),
           plotOutput("analysisPlot", height = "450px"),
           uiOutput("analysisPlotDescription")
  )
  )
)

# Server

server <- function(input, output, session){
  
# DATA OVERVIEW TEXT

  output$question <- renderText({
    "Which risk factors are most strongly associated with CHD diagnosis in high-risk South African men?"
  }) # research question
  
  output$overview <- renderText({
    "This dataset originates from  retrospective study of adult males living in a 
    heart-diseases high-risk region of the Western Cape, South Africa. The sample 
    includes individuals with diagnosed coronary heart disease (CHD) and a larger 
    group of demographic factors. These data form part of a broader study described 
    in Roussaeuw et al. (1983) in the South African Medical Journal. Several 
    physiological measurements were recorded after treatment. This is an important 
    consideration when interpreting predictors such as systolic blood pressure in relation to CHD status"
  }) # about the data
  
  output$variables <- renderUI({
    tagList(
      p("Variables included in this analysis:"),
      tags$ul(
        tags$li("sbp: systolic blood pressure"),
        tags$li("tobacco: cumulative tobacco use (kg)"),
        tags$li("ldl: low-density lipoprotein cholesterol"),
        tags$li("adiposity: measure of body fat"),
        tags$li("famhist: family history of heart disease (Present/Absent)"),
        tags$li("obesity: obesity score"),
        tags$li("alcohol: alcohol consumption"),
        tags$li("age: age at onset"),
        tags$li("chd: coronary heart disease (Absent/Present)")
      )
    ) # variables of interest
  })
  
  

# FULL DATA TABLE

  output$fullDataTable <- renderDT({
    datatable(CHD, options = list(pageLength = 10, scrollX = TRUE))
  }) # adding data to tab
  
  

# SUMMARY TABLES

  output$summaryTable <- renderTable({
    var <- input$independent
    
    if (is.factor(CHD[[var]])) {
      CHD %>%
        group_by(.data[[var]], chd) %>%
        summarise(n = n(), .groups = "drop_last") %>%
        mutate(proportion = round(n / sum(n), 3))
      
    } else {
      CHD %>%
        group_by(chd) %>%
        summarise(
          Mean = round(mean(.data[[var]]), 2),
          Median = round(median(.data[[var]]), 2),
          SD = round(sd(.data[[var]]), 2),
          Min = round(min(.data[[var]]), 2),
          Max = round(max(.data[[var]]), 2)
        )
    } # five number summary of the data based on selection of variable
  })
  
  output$summaryData <- renderUI({
    var <- input$independent
    
    if (is.factor(CHD[[var]])) {
      HTML(paste("This table shows the proportion of CHD vs No CHD for each category of", var_names[[var]]))
    } else {
      HTML(paste("This table shows summary statistics of", var_names[[var]], "grouped by CHD status."))
    } # title of summary table based on selection of variable
  })
  

# ANALYSIS PLOTS - BOXPLOT

  output$analysisPlot <- renderPlot({
    var <- input$analysisVar
    
    if (is.numeric(CHD[[var]])) {
      ggplot(CHD, aes(x = chd, y = .data[[var]], fill = chd)) +
        geom_boxplot() +
        theme_minimal() + 
        labs(
          title = paste(var_names[[var]], "by CHD Status"),
          x = "CHD Status",
          y = var_names[[var]]
        ) +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))
    } else {
      ggplot(CHD, aes(x = .data[[var]], fill = chd)) +
        geom_bar(position = "fill") +
        theme_minimal() + 
        labs(
          title = paste("Proportion of CHD by", var_names[[var]]),
          x = var_names[[var]],
          y = "Proportion"
        ) +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))
    } # boxplot of variable of interest vs. CHD status
  })
  
  output$summaryIbrahim <- renderPrint({
    req(histData())
    filtered <- histData()
    cat("SUMMARY STATISTICS FOR CHD\n")
    cat("==========================\n")
    cat("Total observations:", nrow(filtered), "\n")
    cat("CHD cases:", sum(filtered$chd == "CHD"), "\n")
    cat("Non-CHD cases:", sum(filtered$chd == "No CHD"), "\n")
    cat("CHD prevalence:", round(mean(filtered$chd == "CHD") * 100, 1), "%\n\n")
    
    cat("Detailed breakdown (No CHD / CHD):\n")
    print(table(filtered$chd))
    
    cat("\nProportions (%):\n")
    print(round(prop.table(table(filtered$chd)) * 100, 1))
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
    be conducted to examine this association.") # summary/findings on each variable
  
  output$analysisPlotDescription <- renderUI({
    p(plotDescriptions[[input$analysisVar]])
  }) # displays the summary based on input from user
  
  

# HISTOGRAM PLOT
  
  # slider based on selected variable
  output$histSlider <- renderUI({
    var <- CHD[[input$histVar]]
    
    if (!is.numeric(var)) {
      return(NULL)   # no slider for categorical variable
    }
    
    sliderInput(
      "histRange",
      paste("Select", input$histVar, "range:"),
      min = floor(min(var)),
      max = ceiling(max(var)),
      value = c(floor(min(var)), ceiling(max(var))),
      step = 1
    )
  })
  
  # filtered data based on slider
  histData <- reactive({
    var <- CHD[[input$histVar]]
    
    if (!is.numeric(var)) {
      return(NULL)   # if categorical, then return nothing (no summary stats)
    } # if numerical, this is skipped and proportions/counts are shown
    
    req(input$histRange)
    
    CHD %>%  
      filter(
        .data[[input$histVar]] >= input$histRange[1] &
          .data[[input$histVar]] <= input$histRange[2]
      )
  })
  
  
  
  var_names <- c(
    sbp = "Systolic Blood Pressure",
    tobacco = "Tobacco",
    ldl = "Low Density Lipoprotein Cholesterol",
    adiposity = "Measure of Body Fat",
    famhist = "Family History of Heart Disease",
    obesity = "Obesity Index",
    alcohol = "Alcohol Consumption",
    age = "Age"
  )
  
  
  # histogram output
  output$histPlot <- renderPlot({
    var <- input$histVar
    
    # If the variable is categorical, output a grouped bar plot
    if (!is.numeric(CHD[[var]])) {
      ggplot(CHD, aes(x = .data[[var]], fill = chd)) +
        geom_bar(position = "dodge") +
        theme_minimal() +
        labs(
          title = paste("CHD Counts by", var_names[[var]]),
          x = var_names[[var]],
          y = "Count"
        ) +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))
      
    } else {
      # plot for numerical variable, which uses filtered data and slider function
      ggplot(histData(), aes(x = chd)) +
        geom_bar(fill = "lightblue") +
        theme_minimal() +
        labs(
          title = paste("CHD Distribution for", var_names[[var]],
                        "between", input$histRange[1], "and", input$histRange[2]),
          x = "CHD Status",
          y = "Count"
        ) +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))
    }
  })
  
}

# Run App
shinyApp(ui = ui, server = server)

