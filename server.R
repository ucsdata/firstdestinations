source("setup_server.R", local = T)

shinyServer(function(input, output, session) {
  
    #grab the data for the selected year and update text
    observeEvent(input$updata_all, {
      year = input$selectyear
      
      if(year == "(Select)") return()
     
      source("grabdata.R", local = T)
      
      
      #generate text for overall class stats
      output$classtats <- renderText({
        HTML(paste(sep = "", tags$h2(paste(year, "UCSD Graduates")),
              tags$br(), tags$br(),
              "Total Undergraduates: ", mydfs$progress[["grads"]], tags$br(),
              "Total Outcomes Known: ", mydfs$progress[["outcomes"]], tags$br(),
              "Knowledge Rate: ", round(mydfs$progress[["ratio"]] * 100, 2), "%", tags$br()
        ))
      })
      
      updateSelectInput(session, "selectDept", choices = mydfs$grads$Department)
      
    })
    
   
    #take user to map page
    observeEvent(input$tomap, {
      updateTabsetPanel(session, "taskbar", selected = "Interactive Map")
    })
  
    #render initial map
    output$map <- leaflet::renderLeaflet({
      gradmap
    })
    
    #have the map respond to changes caused by the user
    observeEvent(c(input$updatemap, input$tomap),{ 
       if(!(exists("mydfs")))
         return()
      
       source("update_map.R", local = T)
       proxy
    })
    
    
    #check login credentials
    observeEvent(input$login, {
      if(!(input$user == "ucsdataresearch" && input$pw == "ucalumnisd")){
        output$success <- renderText({"Invalid Login"})
      } else {
        output$success <- renderText({"Access Granted"})
      }
        
    })
    
    #update dropbox database
    observeEvent(input$submit, {
      source("update_dropbox.R", local = T)
      output$complete <- renderText({"Finished!"})
    })
    
    #generate RMD PDF
    output$report <- downloadHandler(
      filename = "report.html",
      content = function(file) {
        tempReport <- file.path(tempdir(), "report.Rmd")
        file.copy("report.Rmd", tempReport, overwrite = T)
        
        parameters <- list(dfs = mydfs, dept = input$selectDept, year=input$selectyear)
        
        rmarkdown::render(tempReport, output_file = file,
          params = parameters)                  
        
      }
    )
    
})
