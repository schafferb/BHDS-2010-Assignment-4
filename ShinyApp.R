#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/

# Uploading necessary packages
library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(bslib)
library(DT)


# loading the data
# Some data manipulation was done before being placed into the Shiny App. 

CHD <- read.table("https://hastie.su.domains/ElemStatLearn/datasets/SAheart.data",
                  sep=",",head=T,row.names=1)

CHD <- CHD %>%
  mutate(chd = factor(chd,
                      levels = c(0, 1),
                      labels = c("No CHD", "CHD")))

is.factor(CHD$chd) # double check factor 

CHD$famhist <- as.factor(CHD$famhist)

is.factor(CHD$famhist) # double check factor

# write.csv(CHD, "CHD", row.names = FALSE)
# CHD <- read.csv("CHD")

# Define UI
ui <- fluidPage(
  br(), 
  fluidRow(titlePanel(strong("Risk Factors Associated with CHD Diagnosis in 
                             High-Risk South African Men")), align = "center"),
  fluidRow(h4("Published by: Bryanna Schaffer and Ibrahim Elbasheer"), align = "center"),
  tabsetPanel(
    tabPanel(strong("Data Overview"),
             br(),
             mainPanel(width = 12,
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
    tabPanel(strong("Data Exploration"),
             br(),
             mainPanel(width = 12,
                       h3(strong("Coronary Heart Disease Data Exploration"), align = "center"),
                       textOutput("howtodata"),
                       br(),
                       
                       # dropdown first
                       fluidRow(
                         column(6,
                                selectInput("independent", strong("Select a Variable of Interest"),
                                   choices = c("Systolic Blood Pressure" = "sbp",
                                               "Tobacco" = "tobacco",
                                               "Low Density Lipoprotein Cholesterol" = "ldl",
                                               "Measure of Body Fat" = "adiposity",
                                               "Family History of Heart Disease" = "famhist",
                                               "Obesity Index" = "obesity",
                                               "Alcohol Consumption" = "alcohol",
                                               "Age" = "age"),
                                   selected = "sbp"),
                       br(),
                       
                       # summary/proportion table
                       strong(tableOutput("summaryTable"), align = "center")),
                       column(6,
                              strong("Discussion"),
                              uiOutput("summaryData"))),
                       br(),
                       
                       # full dataset table
                       div(
                         style = "border: 3px solid #000; 
                                  border-radius: 2px;",
                         h4(strong("Full Dataset"), align = "center"),
                         strong(DTOutput("fullDataTable"))
                       )
             )
    ),
    tabPanel(strong("Data Analysis"),
             br(),
             h3(strong("Plot of Selected Variable vs CHD"), align = "center"),
             
             selectInput("analysisVar", "Select a Variable of Interest:",
                         choices = c("Systolic Blood Pressure" = "sbp",
                                     "Tobacco" = "tobacco",
                                     "Low Density Lipoprotein Cholesterol" = "ldl",
                                     "Measure of Body Fat" = "adiposity",
                                     "Family History of Heart Disease" = "famhist",
                                     "Obesity Index" = "obesity",
                                     "Alcohol Consumption" = "alcohol",
                                     "Age" = "age")),
             
             br(),
             plotOutput("analysisPlot", height = "450px"))
    )
  )


server <- function(input, output, session){
  # writing for data overview section 
  output$question <- renderText({
    "Which risk factors are most strongly associated with CHD diagnosis in high-risk 
    South African men?"
  })
  
  output$overview <- renderText({
    "This dataset originates from  retrospective study of adult males living in a 
    heart-diseases high-risk region of the Western Cape, South Africa. The sample 
    includes individuals with diagnosed coronary heart disease (CHD) and a larger 
    group of demographic factors. These data form part of a broader study described 
    in Roussaeuw et al. (1983) in the South African Medical Journal. Several physiological measurements were recorded after treatment. This is an important consideration when interpreting predictors such as systolic blood pressure in relation to CHD status"
  })
  
  output$variables <- renderUI({
    tagList(
      p("For this analysis, the following variables will be used:"),
      tags$ul(
        tags$li("sbp: systolic blood pressure"),
        tags$li("tobacco: cumulative tobacco use (kg)"),
        tags$li("ldl: low-density lipoprotein cholesterol"),
        tags$li("adiposity: measure of body fat"),
        tags$li("famhist: family history of heart disease (Present/Absent)"),
        tags$li("obesity: obesity score or index"),
        tags$li("alcohol: current alcohol consumption"),
        tags$li("age: age at onset"),
        tags$li("chd: coronary heart disease (Absent/Present)")
      )
    )
  })
  output$fullDataTable <- renderDT({
    datatable(CHD,
              options = list(
                pageLength = 10,     # number of rows per page
                scrollX = TRUE       # horizontal scroll if table is wide
              ))
  })
  
  output$summaryTable <- renderTable({

  var <- input$independent
  df <- CHD

  # If variable is categorical → show proportions of CHD
  if (is.factor(df[[var]])) {

    table_df <- df %>%
      group_by(.data[[var]], chd) %>%
      summarise(n = n(), .groups = "drop_last") %>%
      mutate(proportion = round(n / sum(n), 3)) %>%
      rename(Level = .data[[var]])

    return(table_df)

  } else {

    # If numeric → show summary statistics by CHD group
    table_df <- df %>%
      group_by(chd) %>%
      summarise(
        Mean = round(mean(.data[[var]]), 2),
        Median = round(median(.data[[var]]), 2),
        SD = round(sd(.data[[var]]), 2),
        Min = round(min(.data[[var]]), 2),
        Max = round(max(.data[[var]]), 2)
      )

    return(table_df)
  }
})
  
  output$summaryData <- renderUI({
    var <- input$independent
    
    if (is.factor(CHD[[var]])) {
      HTML(paste(
        "This table shows the proportion of CHD cases vs No CHD for each level of",
        var, ". Use these proportions to understand which categories have higher risk."
      ))
    } else {
      HTML(paste(
        "This table shows summary statistics (Mean, Median, SD, Min, Max) of",
        var, "grouped by CHD status. Compare the values to see if the variable differs between No CHD and CHD groups."
      ))
    }
  })
  
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
    titleName <- plotVariableNames[[var]]   # allows for title to be written out
    
    if (is.numeric(CHD[[var]])) {
      ggplot(CHD, aes(x = chd, y = .data[[var]], fill = chd)) +
        geom_boxplot() +
        theme_minimal() +
        labs(
          title = paste(titleName, "vs CHD"),
          x = "CHD Status",
          y = titleName,
          fill = "CHD Status"      
        )
      
    } else {
      ggplot(CHD, aes(x = .data[[var]], fill = chd)) +
        geom_bar(position = "fill") +
        theme_minimal() +
        labs(
          title = paste(titleName, "vs CHD"),
          x = titleName,
          y = "Proportion",
          fill = "CHD Status"     
        )
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
