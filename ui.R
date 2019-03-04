#setwd("C:/Users/Ryan/Documents/data_research position/data projects/first_destination/firstdestinations")
library(shiny)

source("setup_ui.R", local = T)

navbarPage(theme = shinythemes::shinytheme("yeti"), id = "taskbar",
           
    "UCSD - First Destinations",
           
    tabPanel("Overview",
        fluidRow(
          column(2, offset = 1,
             selectInput("selectyear", "Select Year", choices = c("(Select)",year_choices),
                         selected = "(Select)"),
             
             actionButton("updata_all", "Update Data", icon("check-circle"),
                          style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
          ), 
          
          column(9, 
             htmlOutput("classtats"), tags$br(),
             plotOutput("major.breakdown", height = "600px")
          )
        )         
    ),
    
    tabPanel("Departments", 
        selectInput("selectDept", "Select Department", choices = c("")),
        downloadButton("report", "Generate Department Report")
    ),
    
    tabPanel("Stats Explorer",
        
        sidebarLayout(
         
          sidebarPanel(width = 3, "Filters"
            
          ),
          
          mainPanel(    
            tabsetPanel(   
              
              tabPanel("All"),
              
              tabPanel("Employed"),
              
              tabPanel("Continuing Education"),
              
              tabPanel("Planning to Continue"),
              
              tabPanel("Seeking Employment"),
              
              tabPanel("Not Seeking"),
              
              tabPanel("Volunteer"),
              
              tabPanel("Service")
            )
          )
        ),
        
        actionButton("tomap", "Map these grads!"),
        downloadButton("download", "Download as .csv")
    ),
    
    tabPanel("Interactive Map",
        fluidRow(
          column(2, offset = 1,
            radioButtons("mapGroup","Select Group to Display",
                         choiceNames = c("Employed", "Continuing Education"), 
                         choiceValues = c("employed", "continue_edu")),
            tags$p("(Location data not available for Seeking/Not Seeking 
                   Employment or Planning to Continue Education)",
                   style = "font-size: 7pt")  
          ),
          column(2,
            radioButtons("maptype", "Choose map type: ", choices = c("US","World"))
                 
                 
          ),
          column(3, 
            actionButton("updatemap", "Update Map", icon("map"),
                         style="color: #fff; background-color: #337ab7; border-color: #2e6da4")    
          )
        ),
             
        fluidRow(
          column(9,
            leaflet::leafletOutput("map")         
          )  
        )     
    ),
    
    tabPanel("Admin Tools",
        fluidRow(
          
            column(3, offset = 1,
                 
                textInput("user", "Username: "),
                passwordInput("pw", "Password: "),
                
                actionButton("login", "Login"),
                
                htmlOutput("success")
            ),
            
            column(3, offset = 1,
              #only show if user provides correct credentials
              conditionalPanel(
                condition = "output.success == 'Access Granted'",
                
                
                tags$h2("Update/Upload Data"), tags$br(),
                textInput("newyear", "Enter New or Existing Year: (format - XXXX-XXXX)"),
                fileInput("newdata", "Upload 'master_outcomes.xlsx' file 
                          (see documentation for formatting instructions)"), tags$br(),
                actionButton("submit", "Submit", icon("cloud"),
                             style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                htmlOutput("complete")
              )
            )
                 
        )
             
                      
    )
           
)