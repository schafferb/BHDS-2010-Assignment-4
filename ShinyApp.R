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
  fluidRow(titlePanel(strong("Risk Factors Associated with CHD Diagnosis in High-Risk South African Men")), align = "center"),
  fluidRow(h5("Published by: Bryanna Schaffer and Ibrahim Elbasheer"), align = "center"),
  tabsetPanel(
    tabPanel(strong("Data Overview"),
             br(),
             mainPanel(width = 12,
                       h3(strong("Research Question"), align = "center"),
                       textOutput("question"),
                       br(),
                       h3(strong("Data Overview"), align = "center"),
                       textOutput("data"),
                       br(),
                       h4(strong("Variables of Interest"), align = "center"),
                       textOutput("variables")
                       )
             ),
    tabPanel(strong("Data Exploration"),
             ),
    tabPanel(strong("Data Analysis"))
  )
)

server <- function(input, output, session){
  
}

# writing for data overview section 
output$question <- renderText({
  ""
})

# Run the application
shinyApp(ui = ui, server = server)
