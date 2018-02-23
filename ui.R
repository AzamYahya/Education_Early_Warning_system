library(shiny)
library(shinythemes)
library(caret)
features <- readRDS("features.rda")
model <- readRDS("model2.rda")
shinyUI(
  fluidPage(
    
    theme = shinytheme("cerulean"),
    
    tags$head(
      tags$style(HTML("
                      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                      
                      h1 {
                      font-family: 'Lobster', cursive;
                      font-weight: 500;
                      line-height: 1.1;
                      color: #48ca3b;
                      }
                      
                      "))
      ),
    # Application title
    titlePanel("Early Warning System for Early Dropout from Schools",
               windowTitle = "Important Parameters for Education"),
    h5("The Input Yield Prediction for Childs Dropout"),
    
    sidebarLayout(
      # sidebarPanel ------------------------------------------------------------
      sidebarPanel(
        #tags$img(src="StackOverflow.jpg"),
        # width = "200px", height = "200px"),
        hr(),
        h5('Enter parameters:'),
        hr(),
        selectInput("province", "Province", 
                    choices= unique(as.character(features$province))),
        
        selectInput("region", "Region", 
                    choices= unique(as.character(features$region))),
        
        
        selectInput("read_and_write", "Read and Write", 
                    choices= unique(as.character(features$read_and_write))),
        
        selectInput("math_solve", "Can Solve basic Mathematics", 
                    choices= unique(as.character(features$math_solve))),
        
        
        selectInput("problems_insti", "Problem with your institute?", selected = "satisfied",
                    choices= unique(as.character(features$problems_insti))),
        
        
        selectInput("reason_for_no_education", "Reason for attaining No Education", selected = "marriage",
                    choices= unique(as.character(features$reason_for_no_education))),
        
        selectInput("resid_status", "Residential Status", 
                    choices= unique(as.character(features$resid_stat))),
        
        selectInput("rooms", "Number of Rooms in Dwelling", 
                    choices= unique(as.integer(features$rooms))),
        
        selectInput("source_water", "Drinking Source", 
                    choices= unique(as.character(features$source_water))),
        
        selectInput("source_ligth", "Source of Light", 
                    choices= unique(as.character(features$source_ligth))),
        
        
        selectInput("reach_transport", "Time to Reseach Public Transport", 
                    choices= unique(as.character(features$reach_transport))),
        
        h5("********** ")
        
      ),
      
      mainPanel(
        tabsetPanel(
          tabPanel("Results", h3("Based on your input, the machine learning Algorithm Predicts that this Child will"),
                   h2(textOutput("results")),
                   p(), 
                   p(),
                   "About:" , p(), "Research indicates that 3rd grade is a crucial milestone for children;
                   students behind academically at this point are more likely to struggle throughout
                   their education. Early identification of children at risk of falling behind their 
                   peers, particularly on reading skills, can help teachers and schools provide additional
                   help as soon as possible, returning kids to the appropriate grade level.",p(),
                   
                   "The Current model uses data from 'Pakistan Social and Living Standards Measurement Survey(PSLM'). 
                   It uses individualized data such as province, region, ability of solve maths, ability to read and write, and 
                   problems with schools. However, going forward other features such as 
                   attendance, grades, zip code,and other anonymized information will be required for better accuracy. The utility of this prediction model is that
                    will help public and private
                   school develop an 'early warning system' to help teachers identify which of their students most need
                   the most assistance in meeting grade level goals, and what addressable 
                   factors are predictive of falling behind. Additionally, the schools can enroll students at
                   highest risk of falling behind by third grade into a reading aid course, and will use data to assess the 
                   effectiveness of different intervention programs.",p(),"For more information contact @ azam.yahya@khi.iba.edu.pk")
          )
          )
        )
        ))