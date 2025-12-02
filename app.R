# Shiny App: Risk Factors Associated with CHD Diagnosis
# 

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

#          UI
ui <- fluidPage(
  br(),
  fluidRow(titlePanel(strong("Risk Factors Associated with CHD Diagnosis in High-Risk South African Men")),
           align = "center"),
  fluidRow(h4("Published by: Bryanna Schaffer and Ibrahim Elbasheer"), align = "center"),
  
  tabsetPanel(
    

  # 1. DATA OVERVIEW TAB
    
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
    

# 2. DATA EXPLORATION TAB
  
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
    

# 3. DATA ANALYSIS TAB
    tabPanel(strong("Data Analysis"),
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


#        SERVER

server <- function(input, output, session){
  
  # -----------------------------
  # DATA OVERVIEW TEXT
  # -----------------------------
  output$question <- renderText({
    "Which risk factors are most strongly associated with CHD diagnosis in high-risk South African men?"
  })
  
  output$overview <- renderText({
    "This dataset originates from a retrospective study of adult males living in a heart-disease high-risk region of the Western Cape, South Africa. The sample includes individuals with diagnosed coronary heart disease (CHD) and several demographic and physiological measurements. Some measurements were recorded after treatment, which should be considered when interpreting predictors such as systolic blood pressure."
  })
  
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
    )
  })
  

  # FULL DATA TABLE

  output$fullDataTable <- renderDT({
    datatable(CHD, options = list(pageLength = 10, scrollX = TRUE))
  })
  

  # SUMMARY TABLES

  output$summaryTable <- renderTable({
    var <- input$independent
    df <- CHD
    
    if (is.factor(df[[var]])) {
      df %>%
        group_by(.data[[var]], chd) %>%
        summarise(n = n(), .groups = "drop_last") %>%
        mutate(proportion = round(n / sum(n), 3)) %>%
        rename(Level = .data[[var]])
    } else {
      df %>%
        group_by(chd) %>%
        summarise(
          Mean = round(mean(.data[[var]]), 2),
          Median = round(median(.data[[var]]), 2),
          SD = round(sd(.data[[var]]), 2),
          Min = round(min(.data[[var]]), 2),
          Max = round(max(.data[[var]]), 2)
        )
    }
  })
  
  output$summaryData <- renderUI({
    var <- input$independent
    
    if (is.factor(CHD[[var]])) {
      HTML(paste("This table shows the proportion of CHD vs No CHD for each category of", var))
    } else {
      HTML(paste("This table shows summary statistics of", var, "grouped by CHD status."))
    }
  })

  # ANALYSIS PLOTS

  plotVariableNames <- c(
    sbp = "Systolic Blood Pressure",
    tobacco = "Tobacco Use",
    ldl = "Low Density Lipoprotein Cholesterol",
    adiposity = "Measure of Body Fat",
    famhist = "Family History of Heart Disease",
    obesity = "Obesity Index",
    alcohol = "Alcohol Consumption",
    age = "Age"
  )
  
  output$analysisPlot <- renderPlot({
    var <- input$analysisVar
    titleName <- plotVariableNames[[var]]
    
    if (is.numeric(CHD[[var]])) {
      ggplot(CHD, aes(x = chd, y = .data[[var]], fill = chd)) +
        geom_boxplot() +
        theme_minimal() +
        labs(
          title = paste(titleName, "vs CHD"),
          x = "CHD Status",
          y = titleName
        )
    } else {
      ggplot(CHD, aes(x = .data[[var]], fill = chd)) +
        geom_bar(position = "fill") +
        theme_minimal() +
        labs(
          title = paste(titleName, "vs CHD"),
          x = titleName,
          y = "Proportion"
        )
    }
  })
  

  # ANALYSIS DESCRIPTIONS

  plotDescriptions <- list(
    sbp = "Individuals with CHD tend to have higher systolic blood pressure...",
    tobacco = "Tobacco consumption is higher among the CHD group...",
    ldl = "LDL cholesterol levels tend to be higher among those with CHD...",
    adiposity = "Body fat levels show mild differences between CHD groups...",
    famhist = "Family history appears strongly associated with CHD...",
    obesity = "Obesity index shows similar distributions across groups...",
    alcohol = "Alcohol use varies only slightly between CHD groups...",
    age = "Individuals with CHD tend to be older on average..."
  )
  
  output$analysisPlotDescription <- renderUI({
    p(plotDescriptions[[input$analysisVar]])
  })
}

shinyApp(ui = ui, server = server)
