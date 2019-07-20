function(input, output, session) {
  
  date_range <- reactive({
    if (input$show_options == TRUE) {
      req(input$date_select[2] >= input$date_select[1])
    }
    date_range <- seq(as.Date(input$date_select[1]), as.Date(input$date_select[2]), by="days")
    date_range <- format(date_range, "%d %b")
    date_range <- gsub("^0", "", date_range)
    date_range <- paste0(date_range, collapse = "|\\b")
    date_range <- paste0("\\b", date_range)
    return(date_range)
  })
  
  time_range_seq <- reactive({
    if (input$show_options == TRUE) {
      req(paste0(input$end_hour, input$end_min) >= paste0(input$start_hour, input$start_min))
    }
    start <- strptime(paste0(input$start_hour, ":", input$start_min), "%H:%M")
    end <- strptime(paste0(input$end_hour, ":", input$end_min), "%H:%M")
    time_seq <- strftime(seq(start, end, by = 300), format = "%H:%M")
    return(time_seq <- paste0(time_seq, collapse = "|"))
  })
  
  show_result <- eventReactive(input$random_show, {
    Sys.sleep(1)
    shows <- copy(fringe_shows)
    if (input$show_options == TRUE) {
      shows <- shows[Category %in% input$category_select &
                       Dates %like% date_range() &
                       Times %like% time_range_seq()]
    }
    show_result <- shows[sample(nrow(shows), 1)]
    return(show_result)
  })
  
  output$roulette_result <- renderUI({
    if (input$show_options == TRUE) {
    validate(
      need(input$category_select != "", 
           "You have no categories selected.")
    )
      validate(
      need(input$date_select[2] >= input$date_select[1], 
           "End date is earlier than start date")
      )
      validate(
        need(paste0(input$end_hour, input$end_min) >= paste0(input$start_hour, input$start_min), 
             "End time is earlier than start time")
      )
    }
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
  
  output$no_shows <- renderText({
  validate(
    need(show_result()[, .N] != 0, 
         "There are no events matching your requirements. Try again with different filters. ")
  )
  }
  )
  
  output$multiple_times <- renderUI({
    validate(
      need(show_result()[, Times %like% ","], "")
    )
    "This event has multiple showing times; please check the official page for details."
  })
  

## Rules

  observeEvent(input$rules, {
    sendSweetAlert(
      session = session,
      title = "How to play Fringe Roulette",
      text = tags$span("1) Choose the category of show you want, and the dates and times that work for you.",
                       tags$br(),
                       "2) Press \"Show me\" and wait for your result...",
                       tags$br(),
                       "3) Challenge yourself to see one of the first three shows that comes up!",
                       tags$br(),
                       tags$br(),
                       
                       "If you're ready for the advanced version - don't use any filters, and you MUST see the first show that you get (assuming you can).", 
                       tags$br(),
                       tags$br(),
                       "And be sure to use #fringeroulette if you mention the show on social media!",
                       tags$br(),
                       tags$br(),
                       
                       "Fringe Roulette was created by", 
                       tags$a(href="https://www.meganstodel.com/posts/fringe-roulette/", "Megan Stodel", target="_blank"), ". "),
      type = "info", 
      html = TRUE
    )
  }
  )

}



