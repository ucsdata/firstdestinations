source("setup_server.R", local = T)

shinyServer(function(input, output, session) {
  
    #grab the data for the selected year and update text/overview visualizations
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
      
      #generate plot for top 20 majors
      output$major.breakdown <- renderPlot({
        top15Majors <- names(summary(factor(mydfs$grads$Subdepartment))[1:15])
        myMajors <- mydfs$grads[mydfs$grads$Subdepartment %in% top15Majors,]
        myMajors$Subdepartment <- factor(myMajors$Subdepartment, 
                                         levels = rev(top15Majors))
        
        ggplot2::ggplot(myMajors, ggplot2::aes(x = Subdepartment, fill = Department)) +
          ggplot2::geom_bar(stat = "count") +
          ggplot2::theme_bw() +
          ggplot2::theme(legend.position = "none") +
          ggplot2::labs(title = paste("Top 15 Majors,", year), x = "major") +
          ggplot2::coord_flip()
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
