library(shiny)
library(dplyr)
library(plyr)
library(caret)
library(shinyapps)
library(data.table)
library(shinythemes)




features <- readRDS("features.rda")


shinyServer(
  function(input, output){
    model <- readRDS("model2.rda")
    training <- readRDS("features.rda")
    userdf <- training[1,]
    
    values <- reactiveValues()
    values$df <- userdf
    newEntry <- observe({
      values$df$province <- input$province
      values$df$region <- input$region
      values$df$read_and_write <- input$read_and_write
      values$df$math_solve <- input$math_solve
      values$df$problems_insti <- input$problems_insti
      values$df$reason_for_no_education <- input$reason_for_no_education
      values$df$resid_status <- input$resid_status
      values$df$rooms <- as.integer(input$rooms)
      values$df$source_water <- input$source_water
      values$df$source_ligth <- input$source_ligth
      values$df$reach_transport <- input$reach_transport
    })
    
    output$results <- renderPrint({
      { ds1 <- values$df
      a <- paste(predict(model, newdata = data.frame(ds1), type = "raw"))
      names(a) <- NULL
      a[1]
      
      }
    })
  })