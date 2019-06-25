function(input, output, session) {
  
  date_range <- reactive({
    date_range <- seq(as.Date(input$date_select[1]), as.Date(input$date_select[2]), by="days")
    date_range <- format(date_range, "%d %b")
    date_range <- gsub("^0", "", date_range)
    date_range <- paste0(date_range, collapse = "|\\b")
    date_range <- paste0("\\b", date_range)
    return(date_range)
  })
  
  show_result <- eventReactive(input$random_show, {
    Sys.sleep(2)
    shows <- copy(fringe_shows)
    if (input$show_options == TRUE) {
      shows <- shows[Category %in% input$category_select &
                       Dates %like% date_range()]
    }
    show_result <- shows[sample(nrow(shows), 1)]
    return(show_result)
  })
  
  output$roulette_result <- renderUI({
    outcome_text <- HTML(paste0(
      "<div id='mydiv'><f><b>", show_result()[, Title], 
      "</f></b><br /><br /><br />This is in the ", show_result()[, Category], 
      " category and is showing at ", show_result()[, Venue], ". ", 
      "<br />",
      "Find out more about this event on its ", 
      tags$a("official Edinburgh Fringe page", href = paste0("https://tickets.edfringe.com", show_result()[, 'Book Tickets'])), 
      ". "
    ))
    return(outcome_text)
  })
  
}



